import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'dart:async';
import 'package:muslim_community/female_role/discover/model/sister_model.dart';
import 'package:muslim_community/female_role/discover/service/sistergetservice.dart';
import 'package:muslim_community/female_role/home/controller/userdatacontroller.dart';
import 'package:muslim_community/services/socket_service.dart';
import 'package:muslim_community/app_config.dart';

class SisterGetController extends GetxController {
  final SisterGetService _service = SisterGetService();
  final FemaleUserDataController _userCtrl =
      Get.find<FemaleUserDataController>();
  final SocketService _socketService = SocketService();

  var isLoading = false.obs;
  var sisters = <SisterModel>[].obs;
  var searchTerm = "".obs;
  var filter = "nearby-me".obs;
  var cursor = "".obs;
  var hasMore = true.obs;
  var isFetchingMore = false.obs;

  // Pre-fetch location to have it ready
  double? _cachedLat;
  double? _cachedLng;

  Future<void> _preFetchLocation() async {
    try {
      Position? position;
      try {
        position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low,
          timeLimit: const Duration(seconds: 3),
        );
      } catch (e) {
        position = await Geolocator.getLastKnownPosition();
      }
      if (position != null) {
        _cachedLat = position.latitude;
        _cachedLng = position.longitude;
      }
    } catch (e) {
      print("Pre-fetch location failed: $e");
    }
  }

  Future<void> fetchSisters({
    bool isRefresh = false,
    bool isSilent = false,
  }) async {
    if (isRefresh) {
      cursor.value = "";
      hasMore.value = true;
      if (!isSilent) isLoading.value = true;
    } else {
      if (!hasMore.value || isFetchingMore.value) return;
      isFetchingMore.value = true;
    }

    try {
      double latitude = _cachedLat ?? 23.779999;
      double longitude = _cachedLng ?? 90.406693;

      // Only fetch if we don't have cached data or it's a refresh
      if (_cachedLat == null || isRefresh) {
        try {
          print("Fetching current position...");
          Position? position;
          try {
            position = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.low,
              timeLimit: const Duration(seconds: 3),
            );
          } catch (e) {
            position = await Geolocator.getLastKnownPosition();
          }
          if (position != null) {
            latitude = position.latitude;
            longitude = position.longitude;
            _cachedLat = latitude;
            _cachedLng = longitude;
            print("Position fetched: $latitude, $longitude");
          }
        } catch (e) {
          print(
            "Geolocator failed in discover, using fallback/cached coordinates: $e",
          );
        }
      }

      print(
        "Calling getProfiles with: lat=$latitude, lon=$longitude, search=${searchTerm.value}, filter=${filter.value}, cursor=${cursor.value}",
      );

      final response = await _service.getProfiles(
        latitude: latitude,
        longitude: longitude,
        searchTerm: searchTerm.value,
        filter: filter.value == 'nearby-me'
            ? ''
            : filter.value, // Reverted to empty for 'nearby-me'
        cursor: cursor.value,
        limit: 20, // Increased limit
      );

      print("DEBUG: Sister API Response Code: ${response.statusCode}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final List<dynamic> profilesData = responseData['data'] ?? [];
        final Map<String, dynamic>? meta = responseData['meta'];

        if (meta != null) {
          cursor.value = (meta['nextCursor'] ?? "").toString();
          hasMore.value = meta['hasNext'] ?? false;
        } else {
          hasMore.value = false;
        }

        print(
          "DEBUG: Received ${profilesData.length} sister profiles from API",
        );

        final currentUserId = _userCtrl.userId.value;

        if (profilesData.isEmpty) {
          hasMore.value = false;
          if (isRefresh) {
            sisters.clear();
          }
        } else {
          final List<SisterModel> fetchedSisters = [];

          for (var json in profilesData) {
            final id = (json['id'] ?? json['_id'] ?? '').toString();

            // Exclude self from discovery
            if (id == currentUserId) continue;

            final int age = json['age'] ?? 30;
            String joinedAgo = 'New Revert';
            if (json['revertDate'] != null) {
              try {
                final DateTime revertDate = DateTime.parse(json['revertDate']);
                final int differenceInDays = DateTime.now()
                    .difference(revertDate)
                    .inDays;
                if (differenceInDays > 365) {
                  joinedAgo = '${(differenceInDays / 365).floor()} years ago';
                } else if (differenceInDays > 30) {
                  joinedAgo = '${(differenceInDays / 30).floor()} months ago';
                } else {
                  joinedAgo = '$differenceInDays days ago';
                }
              } catch (e) {
                joinedAgo = 'New Revert';
              }
            }

            String mappedStatus = 'Connect';

            final connection = json['connection'] ?? json['connectionData'];
            final String rawStatus =
                (json['connectionStatus'] ??
                        json['status'] ??
                        (connection is Map
                            ? (connection['status'] ??
                                  connection['connectionStatus'])
                            : null) ??
                        '')
                    .toString()
                    .toLowerCase();
            final String rawDirection =
                (connection is Map ? connection['direction'] : null)
                    ?.toString()
                    .toLowerCase() ??
                '';

            // SENDER ID extraction: check for nested sender object or requester field
            final senderId = connection != null
                ? (connection['sender'] is Map
                          ? connection['sender']['_id'] ??
                                connection['sender']['id']
                          : connection['sender']) ??
                      (connection['requester'] is Map
                          ? connection['requester']['_id'] ??
                                connection['requester']['id']
                          : connection['requester'])
                : null;

            if (rawStatus == 'received' || rawStatus == 'incoming') {
              mappedStatus = 'Received';
            } else if (rawStatus == 'pending' ||
                rawStatus == 'requested' ||
                rawStatus == 'sent') {
              if (rawDirection == 'incoming') {
                mappedStatus = 'Received';
              } else if (rawDirection == 'outgoing') {
                mappedStatus = 'Requested';
              } else if (senderId != null &&
                  currentUserId.isNotEmpty &&
                  senderId.toString() != currentUserId.toString()) {
                mappedStatus = 'Received';
              } else {
                mappedStatus = 'Requested';
              }
            } else if (rawStatus == 'accepted' ||
                rawStatus == 'connected' ||
                rawStatus == 'friends') {
              mappedStatus = 'Connected';
            } else if (rawStatus == 'rejected' ||
                rawStatus == 'rejected_by_receiver' ||
                rawStatus == 'rejected_by_sender') {
              mappedStatus = 'Connect';
            }

            final rawImg = json['profileImage'] ?? '';
            String resolvedImageUrl = '';
            if (rawImg.isNotEmpty) {
              if (rawImg.startsWith('http')) {
                resolvedImageUrl = rawImg;
              } else {
                final baseDomain = AppConfig.baseUrl.replaceAll('/api/v1', '');
                resolvedImageUrl = "$baseDomain$rawImg";
              }
            }

            fetchedSisters.add(
              SisterModel(
                id: id,
                connectionId:
                    (connection != null
                            ? (connection['_id'] ?? connection['id'])
                            : json['connectionId'])
                        ?.toString(),
                name: json['name'] ?? 'Unknown',
                age: age,
                joinedAgo: joinedAgo,
                distance: json['distanceInKm'] != null
                    ? double.parse(
                        (json['distanceInKm'] as double).toStringAsFixed(1),
                      )
                    : 0.0,
                status: mappedStatus,
                isVerified: json['isVerified'] ?? false,
                isOnline: false,
                isNewRevert: filter.value == 'new-reverts',
                imageUrl: resolvedImageUrl,
                about: json['about'] ?? 'No information provided yet.',
                revertHistory:
                    json['revertHistory'] ?? 'No revert history provided yet.',
                interests: json['interests'] != null
                    ? List<String>.from(json['interests'])
                    : [],
              ),
            );
          }

          if (isRefresh) {
            sisters.assignAll(fetchedSisters);
          } else {
            // Prevent duplicates when loading more
            for (var newSister in fetchedSisters) {
              if (!sisters.any((s) => s.id == newSister.id)) {
                sisters.add(newSister);
              }
            }
          }
        }
      } else {
        print("Failed to fetch sisters. Code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching sisters in controller: $e");
    } finally {
      if (!isSilent) isLoading.value = false;
      isFetchingMore.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    _preFetchLocation();

    if (_userCtrl.userId.value.isEmpty) {
      _userCtrl.getUserData().then((_) => fetchSisters(isRefresh: true));
    } else {
      fetchSisters(isRefresh: true);
    }
    _setupSocketListeners();
    debounce(
      searchTerm,
      (_) => fetchSisters(isRefresh: true),
      time: const Duration(milliseconds: 500),
    );
  }

  @override
  void onClose() {
    _removeSocketListeners();
    super.onClose();
  }

  void _setupSocketListeners() async {
    try {
      if (!_socketService.isConnected) {
        await _socketService.connect();
      }
      _socketService.on('UPDATE_DISCOVERY', (data) {
        print("SOCKET_DEBUG: Discovery update received for sisters");
        if (!isLoading.value &&
            !isFetchingMore.value &&
            searchTerm.value.isEmpty) {
          fetchSisters(isRefresh: true, isSilent: true);
        }
      });
      _socketService.on('NEW_SISTER', (data) {
        print("SOCKET_DEBUG: New sister added, refreshing list");
        if (!isLoading.value &&
            !isFetchingMore.value &&
            searchTerm.value.isEmpty) {
          fetchSisters(isRefresh: true, isSilent: true);
        }
      });
    } catch (e) {
      print("Error setting up socket listeners for sisters: $e");
    }
  }

  void _removeSocketListeners() {
    _socketService.off('UPDATE_DISCOVERY');
    _socketService.off('NEW_SISTER');
  }

  void searchSisters(String query) {
    searchTerm.value = query;
  }

  void changeFilter(String newFilter) {
    filter.value = newFilter;
    fetchSisters(isRefresh: true);
  }

  void updateStatus(String id, String newStatus, {String? connectionId}) {
    int index = sisters.indexWhere((s) => s.id == id);
    if (index != -1) {
      sisters[index] = sisters[index].copyWith(
        status: newStatus,
        connectionId: connectionId ?? sisters[index].connectionId,
      );
      sisters.refresh(); // Force UI update
    }
  }
}
