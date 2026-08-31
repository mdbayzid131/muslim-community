import 'package:dio/dio.dart';
import 'package:muslim_community/config/constants/api_constants.dart';
import 'package:muslim_community/core/services/api_client.dart';

class DuaRepository {
  final ApiClient apiClient;

  DuaRepository({required this.apiClient});

  Future<Response> getDuas() async {
    return await apiClient.getData(ApiConstants.duas);
  }
}
