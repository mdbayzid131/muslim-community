import 'package:dio/dio.dart';
import 'package:muslim_community/core/services/api_client.dart';

class MosqueRepository {
  final ApiClient apiClient;

  MosqueRepository({required this.apiClient});

  Future<Response> getNearbyMosques({
    required double latitude,
    required double longitude,
    double radius = 5000,
    String? search,
  }) async {
    final query = <String, dynamic>{
      'latitude': latitude,
      'longitude': longitude,
      'radius': radius,
    };
    if (search != null && search.trim().isNotEmpty) {
      query['search'] = search.trim();
      query['searchTerm'] = search.trim();
    }

    // Try /mosques/nearby first
    final response = await apiClient.getData('/mosques/nearby', query: query);

    if (response.statusCode == 200) {
      return response;
    }

    // Fallback to /mosques if backend routing error occurs
    return await apiClient.getData('/mosques', query: query);
  }
}
