import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:muslim_community/config/themes/app_colors.dart';
import 'package:muslim_community/core/services/auth_service.dart';
import 'package:muslim_community/core/utils/helpers.dart';
import 'package:muslim_community/data/models/user_model.dart';
import 'package:muslim_community/data/repositories/connection_repository.dart';
import 'package:muslim_community/data/repositories/user_repository.dart';

enum DiscoverSubTab { nearMe, newReverts }

class DiscoverController extends GetxController {
  final UserRepository userRepository;
  final ConnectionRepository connectionRepository;

  DiscoverController({
    required this.userRepository,
    required this.connectionRepository,
  });

  final isLoading = false.obs;
  final isMoreLoading = false.obs;
  final members = <UserModel>[].obs;
  final searchTerm = "".obs;
  final selectedSubTab = DiscoverSubTab.nearMe.obs;
  final selectedCategory = "Members".obs;

  double? _cachedLat;
  double? _cachedLng;

  String get userRole => Get.find<AuthService>().userRole;
  Color get roleColor => AppColors.getRoleColor(userRole);

  List<String> get categories => [
        userRole == 'female' ? 'Sisters' : 'Brothers',
        'Learning',
        'Mosques',
        'Jumma',
        'Ask Imam',
      ];

  @override
  void onInit() {
    super.onInit();
    selectedCategory.value = categories.first;
    fetchMembers(isRefresh: true);
    debounce(
      searchTerm,
      (_) => fetchMembers(isRefresh: true),
      time: const Duration(milliseconds: 400),
    );
  }

  void changeCategory(String cat) {
    selectedCategory.value = cat;
  }

  void changeSubTab(DiscoverSubTab tab) {
    selectedSubTab.value = tab;
    fetchMembers(isRefresh: true);
  }

  void search(String query) {
    searchTerm.value = query;
  }

  Future<void> fetchMembers({bool isRefresh = false}) async {
    if (isRefresh) {
      isLoading.value = true;
    } else {
      isMoreLoading.value = true;
    }

    try {
      double lat = _cachedLat ?? 51.5074;
      double lng = _cachedLng ?? -0.1278;

      if (_cachedLat == null) {
        try {
          final pos = await Geolocator.getLastKnownPosition() ??
              await Geolocator.getCurrentPosition(
                desiredAccuracy: LocationAccuracy.low,
                timeLimit: const Duration(seconds: 3),
              );
          lat = pos.latitude;
          lng = pos.longitude;
          _cachedLat = lat;
          _cachedLng = lng;
        } catch (_) {}
      }

      final filterParam =
          selectedSubTab.value == DiscoverSubTab.nearMe ? '' : 'new-reverts';

      final response = await userRepository.getProfiles(
        latitude: lat,
        longitude: lng,
        searchTerm: searchTerm.value,
        filter: filterParam,
      );

      if (response.statusCode == 200) {
        final List list = response.data['data'] ?? response.data ?? [];
        final currentUserId = Get.find<AuthService>().currentUser.value?.id;

        final parsedMembers = list
            .map((e) => UserModel.fromJson(e, currentUserId: currentUserId))
            .where((m) => currentUserId == null || m.id != currentUserId)
            .toList();

        members.value = parsedMembers;
      }
    } catch (e) {
      Helpers.error("Fetch members error: $e");
    } finally {
      isLoading.value = false;
      isMoreLoading.value = false;
    }
  }

  Future<void> sendConnectionRequest(String userId) async {
    try {
      final response =
          await connectionRepository.sendConnectionRequest(userId);
      if (response.statusCode == 200 || response.statusCode == 201) {
        Helpers.showSuccess("Connection request sent");
        final data = response.data?['data'] ?? response.data;
        String? newConnId = data?['_id'] ??
            data?['id'] ??
            data?['connection']?['_id'] ??
            data?['connectionId'];

        updateMemberStatus(userId, 'Requested', connectionId: newConnId);
      } else {
        final msg = response.data?['message'] ?? 'Failed to send request';
        Helpers.showError(msg.toString());
      }
    } catch (e) {
      Helpers.error("Send request error: $e");
      Helpers.showError("Something went wrong");
    }
  }

  Future<void> cancelConnectionRequest(String userId, [String? connectionId]) async {
    try {
      if (connectionId == null || connectionId.isEmpty) {
        final member = members.firstWhereOrNull((m) => m.id == userId);
        connectionId = member?.connectionId;
      }

      final response = (connectionId != null && connectionId.isNotEmpty)
          ? await connectionRepository.cancelConnection(connectionId)
          : await connectionRepository.cancelConnectionRequest(receiverId: userId);

      if (response.statusCode == 200 || response.statusCode == 201) {
        Helpers.showSuccess("Request cancelled");
        updateMemberStatus(userId, 'Connect', connectionId: null);
      } else {
        final msg = response.data?['message'] ?? 'Failed to cancel request';
        Helpers.showError(msg.toString());
      }
    } catch (e) {
      Helpers.error("Cancel request error: $e");
    }
  }

  Future<void> acceptConnection(String userId, [String? connectionId]) async {
    try {
      if (connectionId == null || connectionId.isEmpty) {
        final member = members.firstWhereOrNull((m) => m.id == userId);
        connectionId = member?.connectionId;
      }

      final response = (connectionId != null && connectionId.isNotEmpty)
          ? await connectionRepository.acceptConnection(connectionId)
          : await connectionRepository.acceptConnectionRequest(senderId: userId);

      if (response.statusCode == 200 || response.statusCode == 201) {
        Helpers.showSuccess("Connection request accepted");
        updateMemberStatus(userId, 'Connected', connectionId: connectionId);
      } else {
        final msg = response.data?['message'] ?? 'Failed to accept request';
        Helpers.showError(msg.toString());
      }
    } catch (e) {
      Helpers.error("Accept request error: $e");
    }
  }

  void updateMemberStatus(String userId, String newStatus, {String? connectionId}) {
    final index = members.indexWhere((m) => m.id == userId);
    if (index != -1) {
      members[index] = members[index].copyWith(
        connectionStatus: newStatus,
        connectionId: connectionId ?? members[index].connectionId,
      );
      members.refresh();
    }
  }
}
