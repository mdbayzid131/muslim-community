import 'package:dio/dio.dart';
import 'package:muslim_community/core/services/api_client.dart';

class MosqueRepository {
  final ApiClient apiClient;

  MosqueRepository({required this.apiClient});

  Future<Response> getNearbyMosques({
    required double latitude,
    required double longitude,
  }) async {
    return await apiClient.getData(
      '/mosques',
      query: {
        'latitude': latitude,
        'longitude': longitude,
      },
    );
  }
}
