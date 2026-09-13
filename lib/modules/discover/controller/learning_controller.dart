import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:muslim_community/config/themes/app_colors.dart';
import 'package:muslim_community/core/services/auth_service.dart';
import 'package:muslim_community/core/services/socket_service.dart';
import 'package:muslim_community/core/utils/helpers.dart';
import 'package:muslim_community/data/models/learning_comment_model.dart';
import 'package:muslim_community/data/models/learning_content_model.dart';
import 'package:muslim_community/data/repositories/learning_repository.dart';

class LearningController extends GetxController {
  final LearningRepository learningRepository;

  LearningController({required this.learningRepository});

  final isLoading = true.obs;
  final isCommentsLoading = false.obs;
  final isSubmittingComment = false.obs;

  final learningContents = <LearningContentModel>[].obs;
  final comments = <LearningCommentModel>[].obs;
  final selectedContent = Rxn<LearningContentModel>();

  final selectedCategory = "All".obs;
  final searchQuery = "".obs;

  final categories = <String>[
    "All",
    "Fiqh",
    "Hadith",
    "Quran",
    "Seerah",
    "Aqidah",
    "General",
  ].obs;

  String get userRole => Get.find<AuthService>().userRole;
  Color get roleColor => AppColors.getRoleColor(userRole);

  @override
  void onInit() {
    super.onInit();
    fetchLearningContents();
    _setupSocketListeners();
  }

  @override
  void onClose() {
    _removeSocketListeners();
    super.onClose();
  }

  void _setupSocketListeners() {
    try {
      final socketService = Get.find<SocketService>();
      socketService.on('UPDATE_DISCOVERY', (data) {
        fetchLearningContents(isSilent: true);
      });
      socketService.on('NEW_LEARNING', (data) {
        fetchLearningContents(isSilent: true);
      });
    } catch (_) {}
  }

  void _removeSocketListeners() {
    try {
      final socketService = Get.find<SocketService>();
      socketService.off('UPDATE_DISCOVERY');
      socketService.off('NEW_LEARNING');
    } catch (_) {}
  }

  void setCategory(String category) {
    if (selectedCategory.value != category) {
      selectedCategory.value = category;
      fetchLearningContents();
    }
  }

  void search(String query) {
    searchQuery.value = query;
    fetchLearningContents();
  }

  Future<void> fetchLearningContents({bool isSilent = false}) async {
    if (!isSilent) isLoading.value = true;
    try {
      final response = await learningRepository.getLearningContents(
        category: selectedCategory.value,
        search: searchQuery.value,
        page: 1,
        limit: 50,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final dynamic resData = response.data;
        dynamic listData = resData;

        if (resData is Map) {
          if (resData['data'] is List) {
            listData = resData['data'];
          } else if (resData['data'] is Map && resData['data']['data'] is List) {
            listData = resData['data']['data'];
          } else if (resData['data'] is Map && resData['data']['result'] is List) {
            listData = resData['data']['result'];
          } else if (resData['result'] is List) {
            listData = resData['result'];
          }
        }

        if (listData is List) {
          learningContents.value = listData
              .map((e) => LearningContentModel.fromJson(Map<String, dynamic>.from(e)))
              .toList();
        }
      }
    } catch (e) {
      Helpers.error("Fetch learning contents error: $e");
    } finally {
      if (!isSilent) isLoading.value = false;
    }
  }

  Future<void> fetchContentDetails(String contentId) async {
    try {
      final response = await learningRepository.getContentDetails(contentId);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data['data'] ?? response.data;
        if (data is Map) {
          selectedContent.value = LearningContentModel.fromJson(Map<String, dynamic>.from(data));
        }
      }
    } catch (e) {
      Helpers.error("Fetch content details error: $e");
    }
  }

  Future<void> toggleLike(String contentId) async {
    try {
      final int index = learningContents.indexWhere((c) => c.id == contentId);
      if (index != -1) {
        final content = learningContents[index];
        final newIsLiked = !content.isLiked;
        final newLikesCount = newIsLiked ? content.likesCount + 1 : (content.likesCount - 1).clamp(0, 999999);

        learningContents[index] = content.copyWith(
          isLiked: newIsLiked,
          likesCount: newLikesCount,
        );

        if (selectedContent.value?.id == contentId) {
          selectedContent.value = selectedContent.value!.copyWith(
            isLiked: newIsLiked,
            likesCount: newLikesCount,
          );
        }
      }

      final response = await learningRepository.likeContent(contentId);
      if (response.statusCode != 200 && response.statusCode != 201) {
        // Revert on failure
        fetchLearningContents(isSilent: true);
      }
    } catch (e) {
      Helpers.error("Toggle like error: $e");
      fetchLearningContents(isSilent: true);
    }
  }

  Future<void> fetchComments(String contentId) async {
    isCommentsLoading.value = true;
    comments.clear();
    try {
      final response = await learningRepository.getComments(contentId);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final dynamic resData = response.data;
        dynamic listData = resData;

        if (resData is Map) {
          if (resData['data'] is List) {
            listData = resData['data'];
          } else if (resData['data'] is Map && resData['data']['data'] is List) {
            listData = resData['data']['data'];
          } else if (resData['result'] is List) {
            listData = resData['result'];
          }
        }

        if (listData is List) {
          comments.value = listData
              .map((e) => LearningCommentModel.fromJson(Map<String, dynamic>.from(e)))
              .toList();
        }
      }
    } catch (e) {
      Helpers.error("Fetch comments error: $e");
    } finally {
      isCommentsLoading.value = false;
    }
  }

  Future<bool> addComment(
    String contentId,
    String commentText, {
    String? parentCommentId,
  }) async {
    if (commentText.trim().isEmpty) return false;
    isSubmittingComment.value = true;

    try {
      final response = await learningRepository.addComment(
        contentId,
        commentText.trim(),
        parentCommentId: parentCommentId,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final dynamic resData = response.data;
        final dynamic commentJson = resData is Map ? resData['data'] : null;

        if (commentJson != null && commentJson is Map) {
          final newComment = LearningCommentModel.fromJson(Map<String, dynamic>.from(commentJson));
          comments.insert(0, newComment);
        } else {
          final auth = Get.find<AuthService>();
          final newComment = LearningCommentModel(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            content: commentText.trim(),
            userName: auth.currentUser.value?.name ?? 'User',
            userImage: auth.currentUser.value?.profileImage ?? '',
            parentCommentId: parentCommentId,
            createdAt: DateTime.now(),
            userId: auth.currentUser.value?.id ?? '',
          );
          comments.insert(0, newComment);
        }

        // Update comment count in local list
        final index = learningContents.indexWhere((c) => c.id == contentId);
        if (index != -1) {
          final content = learningContents[index];
          learningContents[index] = content.copyWith(
            commentsCount: content.commentsCount + 1,
          );
        }
        if (selectedContent.value?.id == contentId) {
          selectedContent.value = selectedContent.value!.copyWith(
            commentsCount: selectedContent.value!.commentsCount + 1,
          );
        }

        return true;
      }
    } catch (e) {
      Helpers.error("Add comment error: $e");
    } finally {
      isSubmittingComment.value = false;
    }
    return false;
  }

  Future<bool> deleteComment(String commentId, String contentId) async {
    try {
      final response = await learningRepository.deleteComment(commentId);
      if (response.statusCode == 200 || response.statusCode == 204) {
        comments.removeWhere((c) => c.id == commentId || c.parentCommentId == commentId);

        final index = learningContents.indexWhere((c) => c.id == contentId);
        if (index != -1) {
          final content = learningContents[index];
          learningContents[index] = content.copyWith(
            commentsCount: (content.commentsCount - 1).clamp(0, 999999),
          );
        }
        if (selectedContent.value?.id == contentId) {
          selectedContent.value = selectedContent.value!.copyWith(
            commentsCount: (selectedContent.value!.commentsCount - 1).clamp(0, 999999),
          );
        }
        return true;
      }
    } catch (e) {
      Helpers.error("Delete comment error: $e");
    }
    return false;
  }
}
