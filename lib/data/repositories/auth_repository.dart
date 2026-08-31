import 'dart:io';
import 'package:dio/dio.dart';
import 'package:muslim_community/config/constants/api_constants.dart';
import 'package:muslim_community/core/services/api_client.dart';

class AuthRepository {
  final ApiClient apiClient;

  AuthRepository({required this.apiClient});

  Future<Response> login({
    required String email,
    required String password,
  }) async {
    return await apiClient.postData(
      ApiConstants.login,
      {
        'email': email.trim(),
        'password': password,
      },
      requiresAuth: false,
    );
  }

  Future<Response> signUp({
    required Map<String, dynamic> body,
    File? verificationImage,
    File? verificationVideo,
    File? profileImage,
  }) async {
    final List<MultipartBody> multipartBody = [];
    if (verificationImage != null) {
      multipartBody.add(MultipartBody('verificationImage', verificationImage));
    }
    if (verificationVideo != null) {
      multipartBody.add(MultipartBody('verificationVideo', verificationVideo));
    }
    if (profileImage != null) {
      multipartBody.add(MultipartBody('profileImage', profileImage));
    }

    if (multipartBody.isNotEmpty) {
      return await apiClient.postMultipartData(
        ApiConstants.signup,
        body,
        multipartBody: multipartBody,
      );
    }
    return await apiClient.postData(
      ApiConstants.signup,
      body,
      requiresAuth: false,
    );
  }

  Future<Response> verifyOtp({
    required String email,
    required String otp,
  }) async {
    return await apiClient.postData(
      ApiConstants.verifyOtp,
      {
        'email': email.trim(),
        'otp': otp.trim(),
      },
      requiresAuth: false,
    );
  }

  Future<Response> resendOtp({
    required String email,
  }) async {
    return await apiClient.postData(
      ApiConstants.verifyOtp,
      {'email': email.trim()},
      requiresAuth: false,
    );
  }

  Future<Response> forgotPassword({
    required String email,
  }) async {
    return await apiClient.postData(
      ApiConstants.forgotPassword,
      {'email': email.trim()},
      requiresAuth: false,
    );
  }

  Future<Response> verifyForgotPasswordOtp({
    required String email,
    required String otp,
  }) async {
    return await apiClient.postData(
      ApiConstants.verifyForgotPasswordOtp,
      {
        'email': email.trim(),
        'otp': otp.trim(),
      },
      requiresAuth: false,
    );
  }

  Future<Response> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    return await apiClient.postData(
      ApiConstants.resetPassword,
      {
        'newPassword': newPassword,
      },
      extraHeaders: {
        'Authorization': 'Bearer $token',
      },
      requiresAuth: false,
    );
  }

  Future<Response> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    return await apiClient.postData(
      ApiConstants.changePassword,
      {
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      },
      requiresAuth: true,
    );
  }
}
