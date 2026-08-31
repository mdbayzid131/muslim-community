import 'package:dio/dio.dart';
import 'package:muslim_community/config/constants/api_constants.dart';
import 'package:muslim_community/core/services/api_client.dart';

class PrayerRepository {
  final ApiClient apiClient;

  PrayerRepository({required this.apiClient});

  Future<Response> getPrayerTimes({
    required double latitude,
    required double longitude,
  }) async {
    return await apiClient.getData(
      ApiConstants.prayerTimes,
      query: {
        'latitude': latitude,
        'longitude': longitude,
      },
    );
  }

  Future<Response> getNamazGuide(String salahType) async {
    return await apiClient.getData(
      ApiConstants.namazGuide(salahType.toLowerCase()),
    );
  }
}
