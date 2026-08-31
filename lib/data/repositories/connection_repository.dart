import 'package:dio/dio.dart';
import 'package:muslim_community/config/constants/api_constants.dart';
import 'package:muslim_community/core/services/api_client.dart';

class ConnectionRepository {
  final ApiClient apiClient;

  ConnectionRepository({required this.apiClient});

  Future<Response> getPendingRequests() async {
    return await apiClient.getData(
      ApiConstants.pendingConnections,
      query: {'direction': 'received'},
    );
  }

  Future<Response> getSentRequests({String? nextCursor}) async {
    final query = <String, dynamic>{
      'direction': 'sent',
      'limit': 10,
      'sort': '-createdAt',
      'fields': 'status,createdAt',
    };
    if (nextCursor != null) query['nextCursor'] = nextCursor;

    return await apiClient.getData(
      ApiConstants.pendingConnections,
      query: query,
    );
  }

  Future<Response> sendConnectionRequest(String receiverId) async {
    return await apiClient.postData(
      ApiConstants.connections,
      {'receiverId': receiverId},
    );
  }

  Future<Response> acceptConnection(String connectionId) async {
    return await apiClient.postData(
      '${ApiConstants.connections}/$connectionId/accept',
      {},
    );
  }

  Future<Response> acceptConnectionRequest({
    required String senderId,
    String? connectionId,
  }) async {
    if (connectionId != null && connectionId.isNotEmpty) {
      return await acceptConnection(connectionId);
    }
    return await apiClient.postData(
      '${ApiConstants.connections}/accept',
      {'senderId': senderId},
    );
  }

  Future<Response> rejectConnection(String connectionId) async {
    return await apiClient.postData(
      '${ApiConstants.connections}/$connectionId/reject',
      {},
    );
  }

  Future<Response> rejectConnectionRequest({
    required String senderId,
    String? connectionId,
  }) async {
    if (connectionId != null && connectionId.isNotEmpty) {
      return await rejectConnection(connectionId);
    }
    return await apiClient.postData(
      '${ApiConstants.connections}/reject',
      {'senderId': senderId},
    );
  }

  Future<Response> cancelConnection(String connectionId) async {
    return await apiClient.postData(
      '${ApiConstants.connections}/$connectionId/cancel',
      {},
    );
  }

  Future<Response> cancelConnectionRequest({
    required String receiverId,
    String? connectionId,
  }) async {
    if (connectionId != null && connectionId.isNotEmpty) {
      return await cancelConnection(connectionId);
    }
    return await apiClient.postData(
      '${ApiConstants.connections}/cancel',
      {'receiverId': receiverId},
    );
  }

  Future<Response> getConnections({int page = 1, int limit = 20}) async {
    return await apiClient.getData(
      ApiConstants.connections,
      query: {'page': page, 'limit': limit},
    );
  }
}
