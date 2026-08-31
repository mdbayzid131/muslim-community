import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:muslim_community/config/themes/app_colors.dart';
import 'package:muslim_community/core/services/auth_service.dart';
import 'package:muslim_community/core/utils/helpers.dart';
import 'package:muslim_community/data/models/group_comment_model.dart';
import 'package:muslim_community/data/models/group_model.dart';
import 'package:muslim_community/data/models/group_post_model.dart';
import 'package:muslim_community/data/repositories/group_repository.dart';

class GroupController extends GetxController {
  final GroupRepository groupRepository;

  GroupController({required this.groupRepository});

  final isLoading = false.obs;
  final isPostsLoading = false.obs;
  final isCommentsLoading = false.obs;
  final isSubmitting = false.obs;

  final groups = <GroupModel>[].obs;
  final currentGroup = Rxn<GroupModel>();
  final groupPosts = <GroupPostModel>[].obs;
  final postComments = <GroupCommentModel>[].obs;

  final postContentCtrl = TextEditingController();
  final commentContentCtrl = TextEditingController();
  final selectedImages = <File>[].obs;
  final ImagePicker _picker = ImagePicker();

  final replyingToCommentId = "".obs;
  final replyingToUserName = "".obs;

  String get userRole =>
      Get.isRegistered<AuthService>() ? Get.find<AuthService>().userRole : 'male';
  Color get roleColor => AppColors.getRoleColor(userRole);

  @override
  void onInit() {
    super.onInit();
    fetchGroups();
  }

  Future<void> fetchGroups({bool showLoader = true}) async {
    if (showLoader) isLoading.value = true;
    try {
      final response = await groupRepository.getAllGroups();
      if (response.statusCode == 200) {
        final dynamic raw = response.data['data'] ?? response.data;
        final List list = (raw is List) ? raw : [];
        final currentUserId = Get.isRegistered<AuthService>()
            ? Get.find<AuthService>().currentUser.value?.id
            : null;
        final targetUserType = userRole == 'female' ? "SISTER" : "BROTHER";

        final parsed = list
            .map((e) => GroupModel.fromJson(e, currentUserId: currentUserId))
            .where((g) =>
                g.userType.isEmpty ||
                g.userType.toUpperCase() == targetUserType)
            .toList();

        groups.value = parsed;

        final curId = currentGroup.value?.id;
        if (curId != null) {
          currentGroup.value =
              groups.firstWhereOrNull((g) => g.id == curId) ??
                  currentGroup.value;
        }
      }
    } catch (e) {
      Helpers.error("Fetch groups error: $e");
    } finally {
      if (showLoader) isLoading.value = false;
    }
  }

  String? _currentLoadingGroupId;

  void updateInitialGroup(GroupModel initialGroup) {
    final prevId = currentGroup.value?.id;
    currentGroup.value =
        groups.firstWhereOrNull((g) => g.id == initialGroup.id) ?? initialGroup;
    if (prevId != initialGroup.id ||
        (!isPostsLoading.value && groupPosts.isEmpty)) {
      fetchGroupPosts(initialGroup.id);
    }
  }

  void selectGroup(GroupModel group) {
    final prevId = currentGroup.value?.id;
    currentGroup.value =
        groups.firstWhereOrNull((g) => g.id == group.id) ?? group;
    if (prevId != group.id || (!isPostsLoading.value && groupPosts.isEmpty)) {
      fetchGroupPosts(group.id);
    }
  }

  Future<void> fetchGroupPosts(String groupId) async {
    if (isPostsLoading.value && _currentLoadingGroupId == groupId) return;
    _currentLoadingGroupId = groupId;
    isPostsLoading.value = true;
    try {
      final response = await groupRepository.getGroupPosts(groupId);
      if (response.statusCode == 200) {
        final dynamic raw = response.data['data'] ?? response.data;
        final List list = (raw is List) ? raw : [];
        groupPosts.value =
            list.map((e) => GroupPostModel.fromJson(e)).toList();
      }
    } catch (e) {
      Helpers.error("Fetch group posts error: $e");
    } finally {
      isPostsLoading.value = false;
      _currentLoadingGroupId = null;
    }
  }

  Future<void> pickPostImages() async {
    try {
      final picked = await _picker.pickMultiImage(imageQuality: 80);
      if (picked.isNotEmpty) {
        selectedImages.addAll(picked.map((e) => File(e.path)));
      }
    } catch (e) {
      Helpers.error("Pick images error: $e");
    }
  }

  void removeImage(int index) {
    selectedImages.removeAt(index);
  }

  Future<void> createPost(String groupId) async {
    final text = postContentCtrl.text.trim();
    if (text.isEmpty && selectedImages.isEmpty) {
      Helpers.showError("Please write something or attach an image");
      return;
    }

    isSubmitting.value = true;
    try {
      final response = await groupRepository.createPost(
        groupId: groupId,
        content: text,
        attachments: selectedImages.toList(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        postContentCtrl.clear();
        selectedImages.clear();
        Helpers.showSuccess("Post created successfully");
        await fetchGroupPosts(groupId);
      } else {
        final msg = response.data?['message'] ?? "Failed to create post";
        Helpers.showError(msg.toString());
      }
    } catch (e) {
      Helpers.error("Create post error: $e");
      Helpers.showError("An error occurred");
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<void> deletePost(String groupId, String postId) async {
    try {
      final response = await groupRepository.deletePost(postId);
      if (response.statusCode == 200 || response.statusCode == 204) {
        groupPosts.removeWhere((p) => p.id == postId);
        Helpers.showSuccess("Post deleted successfully");
      } else {
        final msg = response.data?['message'] ?? "Failed to delete post";
        Helpers.showError(msg.toString());
      }
    } catch (e) {
      Helpers.error("Delete post error: $e");
    }
  }

  Future<void> likePost(String postId) async {
    final index = groupPosts.indexWhere((p) => p.id == postId);
    if (index == -1) return;

    final p = groupPosts[index];
    final wasLiked = p.isLiked;

    try {
      // Optimistic UI update
      groupPosts[index] = p.copyWith(
        isLiked: !wasLiked,
        likesCount: wasLiked ? p.likesCount - 1 : p.likesCount + 1,
      );
      groupPosts.refresh();

      final response = wasLiked
          ? await groupRepository.unlikePost(postId)
          : await groupRepository.likePost(postId);

      if (response.statusCode != 200 && response.statusCode != 201) {
        // Rollback
        groupPosts[index] = p;
        groupPosts.refresh();
      }
    } catch (e) {
      groupPosts[index] = p;
      groupPosts.refresh();
      Helpers.error("Like post error: $e");
    }
  }

  Future<void> toggleLike(String postId) => likePost(postId);

  Future<void> fetchPostComments(String postId) async {
    isCommentsLoading.value = true;
    try {
      final response = await groupRepository.getPostComments(postId);
      if (response.statusCode == 200) {
        final dynamic raw = response.data['data'] ?? response.data;
        final List list = (raw is List) ? raw : [];
        postComments.value =
            list.map((e) => GroupCommentModel.fromJson(e)).toList();
      }
    } catch (e) {
      Helpers.error("Fetch comments error: $e");
    } finally {
      isCommentsLoading.value = false;
    }
  }

  Future<void> addComment(String postId) async {
    final text = commentContentCtrl.text.trim();
    if (text.isEmpty) return;

    try {
      final response = await groupRepository.addComment(
        postId: postId,
        comment: text,
        parentCommentId: replyingToCommentId.value.isEmpty
            ? null
            : replyingToCommentId.value,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        commentContentCtrl.clear();
        replyingToCommentId.value = "";
        replyingToUserName.value = "";
        await fetchPostComments(postId);

        final postIndex = groupPosts.indexWhere((p) => p.id == postId);
        if (postIndex != -1) {
          final post = groupPosts[postIndex];
          groupPosts[postIndex] =
              post.copyWith(commentsCount: post.commentsCount + 1);
          groupPosts.refresh();
        }
        Helpers.showSuccess("Comment added successfully");
      }
    } catch (e) {
      Helpers.error("Add comment error: $e");
    }
  }

  Future<void> deleteComment(String postId, String commentId) async {
    try {
      final response = await groupRepository.deleteComment(commentId);
      if (response.statusCode == 200) {
        postComments.removeWhere((c) => c.id == commentId);
        final postIndex = groupPosts.indexWhere((p) => p.id == postId);
        if (postIndex != -1) {
          final post = groupPosts[postIndex];
          groupPosts[postIndex] = post.copyWith(
            commentsCount: (post.commentsCount - 1).clamp(0, 99999),
          );
          groupPosts.refresh();
        }
        Helpers.showSuccess("Comment deleted successfully");
      }
    } catch (e) {
      Helpers.error("Delete comment error: $e");
    }
  }

  Future<void> toggleJoin(String groupId) async {
    final index = groups.indexWhere((g) => g.id == groupId);
    if (index == -1) return;

    final g = groups[index];
    final wasJoined = g.isJoined;
    final desiredAfter = !wasJoined;

    isLoading.value = true;
    try {
      final response = wasJoined
          ? await groupRepository.leaveGroup(groupId)
          : await groupRepository.joinGroup(groupId);

      final Map<String, dynamic> responseData =
          response.data is Map ? response.data : {};
      final message =
          (responseData['message'] ?? "").toString().toLowerCase();

      bool success = response.statusCode == 200 || response.statusCode == 201;

      bool? serverIsMember;
      final dataVal = responseData['data'];
      if (dataVal is Map) {
        final v = dataVal['isMember'] ??
            dataVal['isJoined'] ??
            dataVal['joined'] ??
            dataVal['is_member'] ??
            dataVal['is_joined'];
        if (v != null) {
          serverIsMember = v == true || v.toString().toLowerCase() == 'true';
        }
      }

      bool isMemberAfter = serverIsMember ?? desiredAfter;
      if (message.contains('already') && message.contains('member')) {
        isMemberAfter = true;
        success = true;
      }
      if (message.contains('not') && message.contains('member')) {
        isMemberAfter = false;
        success = true;
      }

      if (success) {
        final memberCountAfter = isMemberAfter == wasJoined
            ? g.memberCount
            : isMemberAfter
                ? g.memberCount + 1
                : (g.memberCount - 1).clamp(0, 1 << 30).toInt();

        groups[index] = GroupModel(
          id: g.id,
          name: g.name,
          category: g.category,
          memberCount: memberCountAfter,
          description: g.description,
          isJoined: isMemberAfter,
          userType: g.userType,
          coverImage: g.coverImage,
          icon: g.icon,
        );
        if (currentGroup.value?.id == groupId) {
          currentGroup.value = groups[index];
        }
        groups.refresh();

        String snackMsg;
        if (!wasJoined && isMemberAfter) {
          snackMsg = message.contains("already")
              ? "You are already a member"
              : "Joined group";
        } else if (wasJoined && !isMemberAfter) {
          snackMsg =
              message.contains("not") ? "You were not a member" : "Left group";
        } else {
          snackMsg = isMemberAfter ? "Joined group" : "Left group";
        }
        Helpers.showSuccess(snackMsg);

        await fetchGroups(showLoader: false);
      } else {
        final msg = responseData['message'] ?? "Failed to update group status";
        Helpers.showError(msg.toString());
      }
    } catch (e) {
      Helpers.error("Toggle join error: $e");
      Helpers.showError("An error occurred");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> joinGroup(String groupId) => toggleJoin(groupId);
  Future<void> leaveGroup(String groupId) => toggleJoin(groupId);

  void setReply(String commentId, String userName) {
    replyingToCommentId.value = commentId;
    replyingToUserName.value = userName;
  }

  void cancelReply() {
    replyingToCommentId.value = "";
    replyingToUserName.value = "";
  }

  @override
  void onClose() {
    postContentCtrl.dispose();
    commentContentCtrl.dispose();
    super.onClose();
  }
}
