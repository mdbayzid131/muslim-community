import 'dart:convert';
import 'package:get/get.dart';
import 'package:muslim_community/config/constants/storage_constants.dart';
import 'package:muslim_community/config/routes/app_routes.dart';
import 'package:muslim_community/core/services/socket_service.dart';
import 'package:muslim_community/core/services/storage_service.dart';
import 'package:muslim_community/data/models/user_model.dart';

class AuthService extends GetxService {
  final RxString _userRole = ''.obs;
  final RxString _userId = ''.obs;
  final RxBool _isLoggedIn = false.obs;
  final Rxn<UserModel> currentUser = Rxn<UserModel>();

  String get userRole => _userRole.value;
  String get userId => _userId.value;
  bool get isLoggedIn => _isLoggedIn.value;

  @override
  void onInit() {
    super.onInit();
    checkAuthStatus();
  }

  Future<void> checkAuthStatus() async {
    final token = await StorageService.getString(StorageConstants.bearerToken);
    if (token.isNotEmpty) {
      _isLoggedIn.value = true;
      _userId.value = getUserIdFromToken(token) ?? '';
      _userRole.value = await getRole();
      currentUser.value = UserModel(
        id: _userId.value,
        name: '',
        email: '',
        role: _userRole.value,
      );
      if (Get.isRegistered<SocketService>()) {
        Get.find<SocketService>().connect();
      }
    } else {
      _isLoggedIn.value = false;
      _userId.value = '';
      _userRole.value = '';
      currentUser.value = null;
    }
  }

  Future<void> saveAuthData({
    required String accessToken,
    required String refreshToken,
    String? fallbackRole,
  }) async {
    await StorageService.setString(StorageConstants.bearerToken, accessToken);
    await StorageService.setString(StorageConstants.refreshToken, refreshToken);

    String? role = getRoleFromToken(accessToken) ?? fallbackRole;
    if (role != null) {
      await StorageService.setString(StorageConstants.userRole, role);
      _userRole.value = role;
    }

    final id = getUserIdFromToken(accessToken);
    if (id != null) {
      await StorageService.setString(StorageConstants.userId, id);
      _userId.value = id;
    }

    _isLoggedIn.value = true;
    currentUser.value = UserModel(
      id: _userId.value,
      name: '',
      email: '',
      role: _userRole.value,
    );
    if (Get.isRegistered<SocketService>()) {
      Get.find<SocketService>().connect();
    }
  }

  String? getUserIdFromToken(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;

      final payload = parts[1];
      final normalized = base64Url.normalize(payload);
      final decodedBytes = base64Url.decode(normalized);
      final decodedString = utf8.decode(decodedBytes);
      final Map<String, dynamic> payloadMap = jsonDecode(decodedString);

      return payloadMap['id']?.toString() ??
          payloadMap['_id']?.toString() ??
          payloadMap['userId']?.toString() ??
          payloadMap['sub']?.toString();
    } catch (_) {
      return null;
    }
  }

  String? getRoleFromToken(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;

      final payload = parts[1];
      final normalized = base64Url.normalize(payload);
      final decodedBytes = base64Url.decode(normalized);
      final decodedString = utf8.decode(decodedBytes);
      final Map<String, dynamic> payloadMap = jsonDecode(decodedString);

      final rawRole = payloadMap['role']?.toString().toLowerCase() ??
          payloadMap['userRole']?.toString().toLowerCase() ??
          payloadMap['roles']?.toString().toLowerCase() ??
          payloadMap['type']?.toString().toLowerCase();

      if (rawRole == null) return null;

      if (rawRole == 'brother' || rawRole == 'male') return 'male';
      if (rawRole == 'sister' || rawRole == 'female') return 'female';
      if (rawRole == 'jummah' || rawRole == 'jumma') return 'jumma';
      return rawRole;
    } catch (_) {
      return null;
    }
  }

  Future<String> getRole() async {
    final token = await StorageService.getString(StorageConstants.bearerToken);
    if (token.isNotEmpty) {
      final jwtRole = getRoleFromToken(token);
      if (jwtRole != null && jwtRole.isNotEmpty) {
        return jwtRole;
      }
    }
    return await StorageService.getString(StorageConstants.userRole);
  }

  Future<void> logout() async {
    if (Get.isRegistered<SocketService>()) {
      Get.find<SocketService>().disconnect();
    }
    await StorageService.clearAll();
    _isLoggedIn.value = false;
    _userId.value = '';
    _userRole.value = '';
    currentUser.value = null;
    Get.offAllNamed(AppRoutes.splash);
  }
}
