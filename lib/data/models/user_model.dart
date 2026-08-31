import 'package:muslim_community/config/constants/api_constants.dart';
import 'package:muslim_community/core/utils/date_formatter.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String? role;
  final String profileImage;
  final String? location;
  final String country;
  final String city;
  final double? latitude;
  final double? longitude;
  final String? ageGroup;
  final String bio;
  final String revertStory;
  final String revertDate;
  final String dateOfBirth;
  final bool isVerified;
  final String distance;
  final bool isOnline;
  final String connectionStatus; // 'Connect', 'Requested', 'Received', 'Connected'
  final String? connectionId;
  final List<String> interests;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.role,
    this.profileImage = '',
    this.location,
    this.country = '',
    this.city = '',
    this.latitude,
    this.longitude,
    this.ageGroup,
    this.bio = '',
    this.revertStory = '',
    this.revertDate = '',
    this.dateOfBirth = '',
    this.isVerified = false,
    this.distance = '',
    this.isOnline = false,
    this.connectionStatus = 'Connect',
    this.connectionId,
    this.interests = const [],
  });

  String get image => profileImage;
  String get aboutMe => bio;
  String get fullName => name;
  bool get isRevert => true;
  bool get isConnected =>
      connectionStatus.toLowerCase() == 'connected' ||
      connectionStatus.toLowerCase() == 'accepted';
  bool get isPending =>
      connectionStatus.toLowerCase() == 'pending' ||
      connectionStatus.toLowerCase() == 'requested' ||
      connectionStatus.toLowerCase() == 'sent';

  int get age {
    if (dateOfBirth.isEmpty) return 20;
    try {
      final dob = DateTime.parse(dateOfBirth);
      final now = DateTime.now();
      int calculated = now.year - dob.year;
      if (now.month < dob.month ||
          (now.month == dob.month && now.day < dob.day)) {
        calculated--;
      }
      return calculated > 0 ? calculated : 20;
    } catch (_) {
      return 20;
    }
  }

  String get revertDateFormatted =>
      DateFormatter.formatJoinedAgo(revertDate);

  factory UserModel.fromJson(Map<String, dynamic> json, {String? currentUserId}) {
    String img = json['profileImage']?.toString() ??
        json['image']?.toString() ??
        json['avatar']?.toString() ??
        json['profile_image']?.toString() ??
        '';
    if (img.isNotEmpty) {
      img = ApiConstants.getImageUrl(img);
    }

    final loc = json['location'];
    String? country;
    String? city;
    double? lat;
    double? lng;

    if (loc is Map) {
      country = loc['country']?.toString();
      city = loc['city']?.toString();
      lat = loc['latitude'] != null
          ? double.tryParse(loc['latitude'].toString())
          : null;
      lng = loc['longitude'] != null
          ? double.tryParse(loc['longitude'].toString())
          : null;
    } else if (loc is String) {
      country = loc;
    }

    final connection = json['connection'] ?? json['connectionData'];
    final String rawStatus = (json['connectionStatus'] ??
            json['status'] ??
            (connection is Map
                ? (connection['status'] ?? connection['connectionStatus'])
                : null) ??
            '')
        .toString()
        .toLowerCase();
    final String rawDirection =
        (connection is Map ? connection['direction'] : null)
                ?.toString()
                .toLowerCase() ??
            '';

    final senderId = connection != null
        ? (connection['sender'] is Map
                ? connection['sender']['_id'] ?? connection['sender']['id']
                : connection['sender']) ??
            (connection['requester'] is Map
                ? connection['requester']['_id'] ?? connection['requester']['id']
                : connection['requester'])
        : null;

    String mappedStatus = 'Connect';
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
          currentUserId != null &&
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

    final String? connId = (connection != null
            ? (connection['_id'] ?? connection['id'])
            : json['connectionId'] ?? json['connection_id'])
        ?.toString();

    String distStr = '1.0';
    if (json['distanceInKm'] != null) {
      final d = json['distanceInKm'];
      if (d is num) {
        distStr = d.toStringAsFixed(1);
      } else {
        distStr = d.toString();
      }
    } else if (json['distance'] != null) {
      distStr = json['distance'].toString();
    }

    List<String> parsedInterests = [];
    if (json['interests'] is List) {
      parsedInterests =
          (json['interests'] as List).map((e) => e.toString()).toList();
    }

    return UserModel(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      name: json['name']?.toString() ??
          json['fullName']?.toString() ??
          json['username']?.toString() ??
          'User',
      email: json['email']?.toString() ?? '',
      role: json['role']?.toString() ?? json['userRole']?.toString(),
      profileImage: img,
      location: loc is String ? loc : null,
      country: country ?? json['country']?.toString() ?? '',
      city: city ?? json['city']?.toString() ?? '',
      latitude: lat ??
          (json['latitude'] != null
              ? double.tryParse(json['latitude'].toString())
              : null),
      longitude: lng ??
          (json['longitude'] != null
              ? double.tryParse(json['longitude'].toString())
              : null),
      ageGroup: json['ageGroup']?.toString(),
      bio: json['aboutMe']?.toString() ?? json['bio']?.toString() ?? '',
      revertStory: json['revertStory']?.toString() ?? '',
      revertDate: json['revertDate']?.toString() ?? '',
      dateOfBirth: json['dateOfBirth']?.toString() ?? '',
      isVerified: json['isVerified'] == true || json['verified'] == true,
      distance: distStr,
      isOnline: json['isOnline'] == true || json['online'] == true,
      connectionStatus: mappedStatus,
      connectionId: connId,
      interests: parsedInterests,
    );
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? role,
    String? profileImage,
    String? location,
    String? country,
    String? city,
    double? latitude,
    double? longitude,
    String? ageGroup,
    String? bio,
    String? revertStory,
    String? revertDate,
    String? dateOfBirth,
    bool? isVerified,
    String? distance,
    bool? isOnline,
    String? connectionStatus,
    String? connectionId,
    List<String>? interests,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      profileImage: profileImage ?? this.profileImage,
      location: location ?? this.location,
      country: country ?? this.country,
      city: city ?? this.city,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      ageGroup: ageGroup ?? this.ageGroup,
      bio: bio ?? this.bio,
      revertStory: revertStory ?? this.revertStory,
      revertDate: revertDate ?? this.revertDate,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      isVerified: isVerified ?? this.isVerified,
      distance: distance ?? this.distance,
      isOnline: isOnline ?? this.isOnline,
      connectionStatus: connectionStatus ?? this.connectionStatus,
      connectionId: connectionId ?? this.connectionId,
      interests: interests ?? this.interests,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'profileImage': profileImage,
      'location': {
        'country': country,
        'city': city,
        'latitude': latitude,
        'longitude': longitude,
      },
      'ageGroup': ageGroup,
      'bio': bio,
      'revertStory': revertStory,
      'revertDate': revertDate,
      'dateOfBirth': dateOfBirth,
      'isVerified': isVerified,
      'distance': distance,
      'isOnline': isOnline,
      'connectionStatus': connectionStatus,
      'connectionId': connectionId,
      'interests': interests,
    };
  }
}
