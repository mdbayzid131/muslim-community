import 'package:flutter/material.dart';

class GroupModel {
  final String id;
  final String name;
  final String category;
  final int memberCount;
  final String description;
  final bool isJoined;
  final String userType;
  final String coverImage;
  final IconData icon;

  GroupModel({
    required this.id,
    required this.name,
    required this.category,
    required this.memberCount,
    required this.description,
    this.isJoined = false,
    this.userType = "",
    this.coverImage = "",
    this.icon = Icons.group_outlined,
  });

  int get totalMembers => memberCount;
  String get groupImage => coverImage;

  factory GroupModel.fromJson(Map<String, dynamic> json, {String? currentUserId}) {
    bool isJoined = json['isJoined'] == true ||
        json['isMember'] == true ||
        json['joined'] == true ||
        json['is_member'] == true ||
        json['is_joined'] == true ||
        json['isJoined']?.toString().toLowerCase() == 'true' ||
        json['isMember']?.toString().toLowerCase() == 'true' ||
        json['joined']?.toString().toLowerCase() == 'true' ||
        json['userId']?.toString() == currentUserId ||
        json['creator']?.toString() == currentUserId ||
        json['creatorId']?.toString() == currentUserId;

    if (!isJoined &&
        json['members'] != null &&
        currentUserId != null &&
        currentUserId.isNotEmpty) {
      final membersList = json['members'];
      if (membersList is List) {
        isJoined = membersList.any((member) {
          if (member == null) return false;
          if (member is String) return member == currentUserId;
          if (member is Map) {
            final memberId = member['id']?.toString() ??
                member['_id']?.toString() ??
                member['userId']?.toString() ??
                member['user']?.toString() ??
                member['member']?.toString() ??
                '';
            return memberId == currentUserId;
          }
          return false;
        });
      }
    }

    return GroupModel(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      memberCount: json['memberCount'] is int
          ? json['memberCount']
          : int.tryParse(json['memberCount']?.toString() ?? '0') ?? 0,
      description: json['description']?.toString() ?? '',
      userType: json['userType']?.toString() ?? '',
      coverImage: json['coverImage']?.toString() ?? json['image']?.toString() ?? '',
      isJoined: isJoined,
      icon: _getIconForCategory(json['category']?.toString() ?? ''),
    );
  }

  static IconData _getIconForCategory(String category) {
    final cat = category.toLowerCase();
    if (cat.contains('education') || cat.contains('lessi')) {
      return Icons.school_outlined;
    } else if (cat.contains('local')) {
      return Icons.location_on_outlined;
    } else if (cat.contains('learning')) {
      return Icons.menu_book_outlined;
    } else if (cat.contains('support')) {
      return Icons.favorite_border_outlined;
    } else if (cat.contains('community')) {
      return Icons.people_outline;
    }
    return Icons.group_outlined;
  }
}
