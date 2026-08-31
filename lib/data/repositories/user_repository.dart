import 'dart:io';
import 'package:dio/dio.dart';
import 'package:muslim_community/config/constants/api_constants.dart';
import 'package:muslim_community/core/services/api_client.dart';

class UserRepository {
  final ApiClient apiClient;

  UserRepository({required this.apiClient});

  Future<Response> getProfile() async {
    return await apiClient.getData(ApiConstants.profile);
  }

  Future<Response> updateProfile({
    required Map<String, dynamic> body,
    File? profileImage,
  }) async {
    if (profileImage != null) {
      return await apiClient.patchMultipartData(
        ApiConstants.profile,
        body,
        multipartBody: [MultipartBody('profileImage', profileImage)],
      );
    }
    return await apiClient.patchData(ApiConstants.profile, body);
  }

  Future<Response> updateLocation({
    required double latitude,
    required double longitude,
    required String country,
    required String city,
  }) async {
    final body = {
      'location[country]': country,
      'location[city]': city,
      'location[latitude]': latitude.toString(),
      'location[longitude]': longitude.toString(),
    };
    return await apiClient.patchData(ApiConstants.profile, body);
  }

  Future<Response> getProfiles({
    double? latitude,
    double? longitude,
    String? searchTerm,
    String? filter,
    String? role,
    int page = 1,
    int limit = 20,
  }) async {
    final query = <String, dynamic>{'page': page, 'limit': limit};
    if (latitude != null) query['latitude'] = latitude;
    if (longitude != null) query['longitude'] = longitude;
    if (searchTerm != null && searchTerm.isNotEmpty) {
      query['searchTerm'] = searchTerm;
    }
    if (filter != null && filter.isNotEmpty) query['filter'] = filter;
    if (role != null && role.isNotEmpty) query['role'] = role;

    return await apiClient.getData(ApiConstants.profiles, query: query);
  }

  Future<Response> getPublicProfile(String userId) async {
    return await apiClient.getData(ApiConstants.publicProfile(userId));
  }
}
