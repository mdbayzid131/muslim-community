import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import 'package:muslim_community/config/routes/app_routes.dart';
import 'package:muslim_community/core/services/storage_service.dart';
import 'package:muslim_community/core/utils/helpers.dart';

class ApiChecker {
  ApiChecker._();

  static void checkApi(Response response) {
    if (response.statusCode == 401) {
      StorageService.clearAll();
      Get.offAllNamed(AppRoutes.splash);
      Helpers.showError('Session expired. Please log in again.');
    } else {
      String errorMessage = response.statusMessage ?? 'Something went wrong';
      if (response.data is Map && response.data['message'] != null) {
        errorMessage = response.data['message'].toString();
      }
      Helpers.showError(errorMessage);
    }
  }
}
