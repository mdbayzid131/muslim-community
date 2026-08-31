import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'dart:io';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:muslim_community/config/constants/api_constants.dart';
import 'package:muslim_community/config/constants/storage_constants.dart';
import 'package:muslim_community/config/routes/app_routes.dart';
import 'package:muslim_community/core/services/storage_service.dart';
import 'package:muslim_community/core/utils/helpers.dart';
import 'package:muslim_community/core/utils/logger.dart';

/// ===================== API CLIENT =====================
/// Centralized HTTP client built on Dio with:
/// - Automatic token injection via interceptors
/// - Token refresh on 401 with retry
/// - Structured request/response logging
/// - Multipart upload support with progress

class ApiClient extends GetxService {
  static late Dio _dio;
  static String _bearerToken = '';
  static Future<bool>? _refreshFuture;

  static const String _fallbackMessage =
      'Something went wrong, please try again';
  static const int _timeoutSeconds = 30;

  Dio get dio => _dio;

  // ─────────────────────────── LIFECYCLE ───────────────────────────

  @override
  void onInit() {
    super.onInit();
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: _timeoutSeconds),
        receiveTimeout: const Duration(seconds: _timeoutSeconds),
        headers: {'Content-Type': 'application/json'},
      ),
    );
    _dio.interceptors.add(_buildInterceptor());
  }

  // ──────────────────────── INTERCEPTOR ────────────────────────

  InterceptorsWrapper _buildInterceptor() {
    return InterceptorsWrapper(
      onRequest: _onRequest,
      onResponse: _onResponse,
      onError: _onError,
    );
  }

  Future<void> _onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final bool requiresAuth = options.extra['requiresAuth'] ?? true;
    _bearerToken = await StorageService.getString(StorageConstants.bearerToken);

    if (requiresAuth &&
        _bearerToken.isNotEmpty &&
        !options.path.contains(ApiConstants.refreshToken)) {
      options.headers['Authorization'] = 'Bearer $_bearerToken';
    } else if (!requiresAuth) {
      options.headers.remove('Authorization');
    }

    AppLogger.request(options);
    return handler.next(options);
  }

  void _onResponse(Response response, ResponseInterceptorHandler handler) {
    AppLogger.response(response);
    return handler.next(response);
  }

  Future<void> _onError(DioException e, ErrorInterceptorHandler handler) async {
    // 1️⃣ Connection Error
    final isConnectionError =
        e.type == DioExceptionType.connectionError ||
        (e.type == DioExceptionType.unknown && e.error is SocketException) ||
        e.message?.contains('SocketException') == true ||
        e.error?.toString().contains('SocketException') == true;

    if (isConnectionError) {
      return handler.next(e);
    }

    // 2️⃣ Token expired → refresh & retry
    if (e.response?.statusCode == 401 &&
        !e.requestOptions.path.contains(ApiConstants.refreshToken) &&
        !e.requestOptions.path.contains(ApiConstants.login)) {
      final refreshToken = await StorageService.getString(
        StorageConstants.refreshToken,
      );
      if (refreshToken.isEmpty) {
        _forceLogout();
        return handler.next(e);
      }

      final refreshed = await _refreshToken();

      if (refreshed) {
        final retryResponse = await _retryRequest(e.requestOptions);
        return handler.resolve(retryResponse);
      } else {
        _forceLogout();
        return handler.next(e);
      }
    }

    AppLogger.error(e);
    return handler.next(e);
  }

  // ──────────────────────── HTTP METHODS ────────────────────────

  /// GET request
  Future<Response> getData(
    String uri, {
    Map<String, dynamic>? query,
    CancelToken? cancelToken,
    Map<String, dynamic>? extraHeaders,
    bool requiresAuth = true,
  }) async {
    try {
      return await _dio.get(
        uri,
        queryParameters: query,
        cancelToken: cancelToken,
        options: Options(
          headers: extraHeaders,
          extra: {'requiresAuth': requiresAuth},
        ),
      );
    } on DioException catch (e) {
      return _buildErrorResponse(e);
    }
  }

  /// POST request
  Future<Response> postData(
    String uri,
    dynamic body, {
    CancelToken? cancelToken,
    Map<String, dynamic>? extraHeaders,
    bool requiresAuth = true,
  }) async {
    try {
      return await _dio.post(
        uri,
        data: body,
        cancelToken: cancelToken,
        options: Options(
          headers: extraHeaders,
          extra: {'requiresAuth': requiresAuth},
        ),
      );
    } on DioException catch (e) {
      return _buildErrorResponse(e);
    }
  }

  /// PUT request
  Future<Response> putData(
    String uri,
    dynamic body, {
    CancelToken? cancelToken,
    Map<String, dynamic>? extraHeaders,
    bool requiresAuth = true,
  }) async {
    try {
      return await _dio.put(
        uri,
        data: body,
        cancelToken: cancelToken,
        options: Options(
          headers: extraHeaders,
          extra: {'requiresAuth': requiresAuth},
        ),
      );
    } on DioException catch (e) {
      return _buildErrorResponse(e);
    }
  }

  /// PATCH request
  Future<Response> patchData(
    String uri,
    dynamic body, {
    CancelToken? cancelToken,
    Map<String, dynamic>? extraHeaders,
    bool requiresAuth = true,
  }) async {
    try {
      return await _dio.patch(
        uri,
        data: body,
        cancelToken: cancelToken,
        options: Options(
          headers: extraHeaders,
          extra: {'requiresAuth': requiresAuth},
        ),
      );
    } on DioException catch (e) {
      return _buildErrorResponse(e);
    }
  }

  /// DELETE request
  Future<Response> deleteData(
    String uri, {
    dynamic body,
    CancelToken? cancelToken,
    Map<String, dynamic>? extraHeaders,
    bool requiresAuth = true,
  }) async {
    try {
      return await _dio.delete(
        uri,
        data: body,
        cancelToken: cancelToken,
        options: Options(
          headers: extraHeaders,
          extra: {'requiresAuth': requiresAuth},
        ),
      );
    } on DioException catch (e) {
      return _buildErrorResponse(e);
    }
  }

  /// Multipart POST with progress tracking
  Future<Response> postMultipartData(
    String uri,
    Map<String, dynamic> body, {
    required List<MultipartBody> multipartBody,
    ProgressCallback? onSendProgress,
    CancelToken? cancelToken,
  }) async {
    try {
      final formData = await _buildFormData(body, multipartBody);
      return await _dio.post(
        uri,
        data: formData,
        onSendProgress: onSendProgress,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      return _buildErrorResponse(e);
    }
  }

  /// Multipart PATCH with progress tracking
  Future<Response> patchMultipartData(
    String uri,
    Map<String, dynamic> body, {
    required List<MultipartBody> multipartBody,
    ProgressCallback? onSendProgress,
    CancelToken? cancelToken,
  }) async {
    try {
      final formData = await _buildFormData(body, multipartBody);
      return await _dio.patch(
        uri,
        data: formData,
        onSendProgress: onSendProgress,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      return _buildErrorResponse(e);
    }
  }

  // ──────────────────── PRIVATE HELPERS ────────────────────

  Future<FormData> _buildFormData(
    Map<String, dynamic> body,
    List<MultipartBody> multipartBody,
  ) async {
    final formData = FormData.fromMap(body);
    for (final part in multipartBody) {
      formData.files.add(
        MapEntry(part.key, await MultipartFile.fromFile(part.file.path)),
      );
    }
    return formData;
  }

  Response _buildErrorResponse(DioException e) {
    final String message;
    final isConnectionError =
        e.type == DioExceptionType.connectionError ||
        (e.type == DioExceptionType.unknown && e.error is SocketException) ||
        e.message?.contains('SocketException') == true ||
        e.error?.toString().contains('SocketException') == true;

    if (isConnectionError) {
      message =
          'Unable to connect to server. Please check your internet connection.';
    } else {
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
          message = 'Connection timed out';
          break;
        case DioExceptionType.receiveTimeout:
          message = 'Server took too long to respond';
          break;
        case DioExceptionType.badResponse:
          final data = e.response?.data;
          if (data is Map && data['message'] != null) {
            message = data['message'].toString();
          } else {
            message = 'Bad response: ${e.response?.statusMessage ?? 'Unknown'}';
          }
          break;
        case DioExceptionType.cancel:
          message = 'Request cancelled';
          break;
        default:
          message = _fallbackMessage;
      }
    }

    return Response(
      requestOptions: e.requestOptions,
      statusCode: e.response?.statusCode ?? 0,
      statusMessage: message,
      data: e.response?.data,
    );
  }

  Future<bool> _refreshToken() async {
    if (_refreshFuture != null) {
      return _refreshFuture!;
    }

    final completer = Completer<bool>();
    _refreshFuture = completer.future;

    try {
      final refreshTokenValue = await StorageService.getString(
        StorageConstants.refreshToken,
      );
      if (refreshTokenValue.isEmpty) {
        completer.complete(false);
        return false;
      }

      final refreshDio = Dio(BaseOptions(baseUrl: ApiConstants.baseUrl));
      final response = await refreshDio.post(
        ApiConstants.refreshToken,
        data: {'refreshToken': refreshTokenValue},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final authData = response.data['data'] ?? response.data;
        final newAccessToken = authData['accessToken'] ?? authData['token'];
        final newRefreshToken = authData['refreshToken'];

        if (newAccessToken != null) {
          await StorageService.setString(
            StorageConstants.bearerToken,
            newAccessToken,
          );
        }
        if (newRefreshToken != null) {
          await StorageService.setString(
            StorageConstants.refreshToken,
            newRefreshToken,
          );
        }
        completer.complete(true);
        return true;
      }
    } catch (e) {
      Helpers.debug('Error refreshing token: $e');
    } finally {
      _refreshFuture = null;
    }

    completer.complete(false);
    return false;
  }

  Future<Response> _retryRequest(RequestOptions requestOptions) async {
    final newToken = await StorageService.getString(
      StorageConstants.bearerToken,
    );
    requestOptions.headers['Authorization'] = 'Bearer $newToken';
    return await _dio.fetch(requestOptions);
  }

  void _forceLogout() {
    StorageService.clearAll();
    try {
      Get.offAllNamed(AppRoutes.splash);
      Helpers.showError('Session expired. Please log in again.');
    } catch (e) {
      Helpers.debug('Force logout navigation error: $e');
    }
  }
}

/// Wraps a file with its form-data key for multipart uploads.
class MultipartBody {
  final String key;
  final File file;

  const MultipartBody(this.key, this.file);
}
