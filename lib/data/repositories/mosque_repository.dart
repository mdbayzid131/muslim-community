import 'package:dio/dio.dart';
import 'package:muslim_community/config/constants/api_constants.dart';
import 'package:muslim_community/core/services/api_client.dart';
import 'package:muslim_community/core/utils/helpers.dart';
import 'package:muslim_community/data/models/mosque_model.dart';

class MosqueRepository {
  final ApiClient? apiClient;
  final Dio _dio = Dio();

  MosqueRepository({this.apiClient});

  /// Fetch nearby or searched mosques strictly using Google Places API (NO backend API)
  Future<List<MosqueModel>> getNearbyMosques({
    required double latitude,
    required double longitude,
    double radius = 5000,
    String? search,
  }) async {
    try {
      final bool isSearch = search != null && search.trim().isNotEmpty;
      final String endpoint = isSearch
          ? 'https://maps.googleapis.com/maps/api/place/textsearch/json'
          : 'https://maps.googleapis.com/maps/api/place/nearbysearch/json';

      final Map<String, dynamic> queryParams = {
        'location': '$latitude,$longitude',
        'radius': radius.toInt(),
        'key': ApiConstants.googlePlacesApiKey,
      };

      if (isSearch) {
        final query = search.trim();
        queryParams['query'] = query.toLowerCase().contains('mosque')
            ? query
            : '$query mosque';
      } else {
        queryParams['type'] = 'mosque';
        queryParams['keyword'] = 'mosque';
      }

      Helpers.debug('Fetching Google Places Mosques from: $endpoint with query: $queryParams');

      final response = await _dio.get(
        endpoint,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200 && response.data != null) {
        final status = response.data['status'];
        final errorMessage = response.data['error_message'];
        Helpers.debug('Google Places API status: $status ${errorMessage != null ? "- $errorMessage" : ""}');

        if (status == 'OK') {
          final List results = response.data['results'] ?? [];
          if (results.isNotEmpty) {
            return results.map((place) {
              return MosqueModel.fromGooglePlace(
                place,
                userLat: latitude,
                userLng: longitude,
              );
            }).toList();
          }
        }
      }
    } catch (e) {
      Helpers.error('Error fetching Google Places API for mosques: $e');
    }

    return [];
  }

  /// Fetch nearby or searched merchants strictly using Google Places API (NO backend API)
  Future<List<MosqueModel>> getNearbyMerchants({
    required double latitude,
    required double longitude,
    double radius = 5000,
    String? search,
  }) async {
    try {
      final bool isSearch = search != null && search.trim().isNotEmpty;
      final String endpoint = isSearch
          ? 'https://maps.googleapis.com/maps/api/place/textsearch/json'
          : 'https://maps.googleapis.com/maps/api/place/nearbysearch/json';

      final Map<String, dynamic> queryParams = {
        'location': '$latitude,$longitude',
        'radius': radius.toInt(),
        'key': ApiConstants.googlePlacesApiKey,
      };

      if (isSearch) {
        final query = search.trim();
        queryParams['query'] = query.toLowerCase().contains('halal') || query.toLowerCase().contains('store')
            ? query
            : '$query halal merchant';
      } else {
        queryParams['keyword'] = 'halal merchant market store';
      }

      Helpers.debug('Fetching Google Places Merchants from: $endpoint');

      final response = await _dio.get(
        endpoint,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200 && response.data != null) {
        final status = response.data['status'];
        final errorMessage = response.data['error_message'];
        Helpers.debug('Google Places Merchant API status: $status ${errorMessage != null ? "- $errorMessage" : ""}');

        if (status == 'OK') {
          final List results = response.data['results'] ?? [];
          if (results.isNotEmpty) {
            return results.map((place) {
              return MosqueModel.fromGooglePlace(
                place,
                userLat: latitude,
                userLng: longitude,
              );
            }).toList();
          }
        }
      }
    } catch (e) {
      Helpers.error('Error in Google Places API for merchants: $e');
    }

    return [];
  }
}
