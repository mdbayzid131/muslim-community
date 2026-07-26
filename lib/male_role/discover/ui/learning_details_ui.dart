import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_community/app_config.dart';
import 'package:muslim_community/appcolore.dart';
import 'package:video_player/video_player.dart';
import 'package:muslim_community/male_role/discover/controller/learningcontroller.dart';
import 'package:muslim_community/male_role/home/controller/userdatacontroller.dart';

class MaleLearningDetailsUI extends StatefulWidget {
  const MaleLearningDetailsUI({super.key});

  @override
  State<MaleLearningDetailsUI> createState() => _MaleLearningDetailsUIState();
}

class _MaleLearningDetailsUIState extends State<MaleLearningDetailsUI> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool _initialized = false;

  String? _contentId;
  bool _isLiked = false;
  int _likesCount = 0;
  final TextEditingController _commentController = TextEditingController();
  String? _replyToCommentId;
  String? _replyToUserName;

  @override
  void initState() {
    super.initState();
    try {
      final args = Get.arguments;
      debugPrint(
        "MaleLearningDetailsUI: Get.arguments received: $args (Type: ${args?.runtimeType})",
      );
      if (args is Map) {
        _contentId = args['id'];
        _isLiked = args['isLiked'] ?? false;
        _likesCount = args['likesCount'] ?? 0;
      }
    } catch (e, stack) {
      debugPrint("Error reading arguments in initState: $e\n$stack");
    }

    _initializePlayer();

    if (_contentId != null) {
      Get.find<MaleLearningController>().fetchComments(_contentId!);
    }
  }

  String _resolveMediaUrl(String url) {
    if (url.isEmpty) return '';

    // Extract server base URL without /api/v1 (e.g., http://10.10.7.47:5002)
    String serverBase = AppConfig.baseUrl.replaceAll('/api/v1', '');
    String resolvedUrl = url.trim();

    // If it's a relative path, prepend server base
    if (resolvedUrl.startsWith('/')) {
      resolvedUrl = "$serverBase$resolvedUrl";
    } else if (resolvedUrl.startsWith('uploads/')) {
      resolvedUrl = "$serverBase/$resolvedUrl";
    }

    // Replace localhost or 127.0.0.1 with correct server IP from AppConfig
    if (resolvedUrl.contains('localhost') ||
        resolvedUrl.contains('127.0.0.1')) {
      try {
        final uri = Uri.parse(AppConfig.baseUrl);
        final actualHost = "${uri.scheme}://${uri.host}:${uri.port}";
        resolvedUrl = resolvedUrl
            .replaceAll(RegExp(r'https?://localhost:\d+'), actualHost)
            .replaceAll(RegExp(r'https?://127\.0\.0\.1:\d+'), actualHost)
            .replaceAll('localhost', uri.host)
            .replaceAll('127.0.0.1', uri.host);
      } catch (e) {
        debugPrint("Error parsing base URL for resolution: $e");
      }
    }

    return resolvedUrl;
  }

  Future<void> _initializePlayer() async {
    try {
      final args = Get.arguments;
      String? videoUrl;
      if (args is Map) {
        videoUrl = args['videoUrl'];
      }

      debugPrint("===== VIDEO PLAYBACK INITIALIZATION =====");
      debugPrint("Raw Video URL Argument: '$videoUrl'");

      if (videoUrl != null && videoUrl.isNotEmpty) {
        final cleanUrl = _resolveMediaUrl(videoUrl);
        debugPrint("Resolved Video URL for Player: '$cleanUrl'");
        debugPrint("Using AppConfig.baseUrl: '${AppConfig.baseUrl}'");

        debugPrint("Instantiating VideoPlayerController...");
        _videoPlayerController = VideoPlayerController.networkUrl(
          Uri.parse(cleanUrl),
        );

        debugPrint("Starting VideoPlayerController.initialize()...");
        await _videoPlayerController.initialize();

        debugPrint("VideoPlayerController initialization SUCCESSFUL");
        debugPrint(
          "Video Dimensions: ${_videoPlayerController.value.size.width}x${_videoPlayerController.value.size.height}",
        );
        debugPrint("Video Duration: ${_videoPlayerController.value.duration}");

        _chewieController = ChewieController(
          videoPlayerController: _videoPlayerController,
          autoPlay: true,
          looping: false,
          aspectRatio: _videoPlayerController.value.aspectRatio,
          allowFullScreen: true,
          allowPlaybackSpeedChanging: true,
          placeholder: Container(
            color: Colors.black,
            child: const Center(
              child: CircularProgressIndicator(color: AppColors.maleColor),
            ),
          ),
          errorBuilder: (context, errorMessage) {
            debugPrint("Chewie Video Player runtime error: $errorMessage");
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, color: Colors.white, size: 42),
                  const SizedBox(height: 10),
                  Text(
                    "Playback Error:\n$errorMessage",
                    style: const TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          },
        );

        setState(() {
          _initialized = true;
        });
      } else {
        debugPrint("Warning: videoUrl is empty or null");
      }
    } catch (e, stack) {
      debugPrint("CRITICAL EXCEPTION during Video Player setup: $e");
      debugPrint("Stacktrace: $stack");
      setState(() {
        _initialized = false;
      });
    }
    debugPrint("===== VIDEO PLAYBACK INITIALIZATION END =====");
  }

  @override
  void dispose() {
    if (_initialized) {
      _videoPlayerController.dispose();
    }
    _chewieController?.dispose();
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args =
        Get.arguments ??
        {
          'category': 'SALAH',
          'title': 'How to Pray Salah for Beginners',
          'description': 'No description provided.',
        };
    final String category = args['category'] ?? 'General';
    final String title = args['title'] ?? 'Learning Material';
    final String description =
        args['description'] ?? 'No description provided.';

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Column(
        children: [
          // --- VIDEO PLAYER ---
          Stack(
            children: [
              Container(
                width: double.infinity,
                height: 250.h,
                color: Colors.black,
                child: _initialized && _chewieController != null
                    ? Chewie(controller: _chewieController!)
                    : const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.maleColor,
                        ),
                      ),
              ),
              Positioned(
                top: 40.h,
                left: 20.w,
                child: CircleAvatar(
                  backgroundColor: Colors.white.withValues(alpha: 0.8),
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios_new,
                      color: AppColors.maleColor,
                      size: 18.sp,
                    ),
                    onPressed: () => Get.back(),
                  ),
                ),
              ),
            ],
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category,
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.maleColor,
                      letterSpacing: 1,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    title,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.titleColor,
                    ),
                  ),
                  SizedBox(height: 15.h),
                  Text(
                    description,
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      color: AppColors.bodyColor,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (_contentId != null) {
                            setState(() {
                              _isLiked = !_isLiked;
                              if (_isLiked) {
                                _likesCount++;
                              } else {
                                _likesCount--;
                              }
                            });
                            try {
                              final MaleLearningController controller =
                                  Get.find<MaleLearningController>();
                              controller.toggleLike(_contentId!);
                            } catch (e) {
                              print(
                                "Could not find MaleLearningController: $e",
                              );
                            }
                          }
                        },
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(10.w),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: _isLiked
                                      ? AppColors.maleColor.withValues(
                                          alpha: 0.3,
                                        )
                                      : AppColors.bodyColor.withValues(
                                          alpha: 0.1,
                                        ),
                                ),
                                boxShadow: _isLiked
                                    ? [
                                        BoxShadow(
                                          color: AppColors.maleColor.withValues(
                                            alpha: 0.2,
                                          ),
                                          blurRadius: 8,
                                          offset: const Offset(0, 3),
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Icon(
                                _isLiked
                                    ? Icons.thumb_up
                                    : Icons.thumb_up_alt_outlined,
                                size: 20.sp,
                                color: _isLiked
                                    ? AppColors.maleColor
                                    : AppColors.bodyColor,
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Text(
                              '$_likesCount',
                              style: GoogleFonts.inter(
                                fontSize: 14.sp,
                                color: _isLiked
                                    ? AppColors.maleColor
                                    : AppColors.bodyColor,
                                fontWeight: _isLiked
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 25.w),
                      Obx(() {
                        final controller = Get.find<MaleLearningController>();
                        int idx = controller.learningContents.indexWhere(
                          (c) => c.id == _contentId,
                        );
                        int count = idx != -1
                            ? controller.learningContents[idx].commentsCount
                            : (int.tryParse(
                                    args['commentsCount']?.toString() ?? '0',
                                  ) ??
                                  0);
                        return _buildStatItem(
                          Icons.chat_bubble_outline,
                          count.toString(),
                        );
                      }),
                    ],
                  ),
                  SizedBox(height: 25.h),
                  Divider(color: AppColors.bodyColor.withValues(alpha: 0.1)),
                  SizedBox(height: 25.h),
                  Text(
                    'Comments',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.titleColor,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Obx(() {
                    final controller = Get.find<MaleLearningController>();
                    if (controller.isCommentsLoading.value) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.maleColor,
                        ),
                      );
                    }
                    if (controller.comments.isEmpty) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.h),
                        child: Text(
                          'No comments yet. Be the first to comment!',
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            color: AppColors.bodyColor.withValues(alpha: 0.6),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      );
                    }

                    final topLevelComments = controller.comments
                        .where(
                          (c) =>
                              c.parentCommentId == null ||
                              c.parentCommentId!.isEmpty,
                        )
                        .toList();

                    return ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: topLevelComments.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 20.h),
                      itemBuilder: (context, index) {
                        final comment = topLevelComments[index];
                        String timeStr =
                            '${comment.createdAt.hour}:${comment.createdAt.minute.toString().padLeft(2, '0')}';
                        if (DateTime.now()
                                .difference(comment.createdAt)
                                .inDays >
                            0) {
                          timeStr =
                              '${comment.createdAt.day}/${comment.createdAt.month}/${comment.createdAt.year}';
                        } else {
                          final diff = DateTime.now().difference(
                            comment.createdAt,
                          );
                          if (diff.inHours > 0) {
                            timeStr = '${diff.inHours}h ago';
                          } else if (diff.inMinutes > 0) {
                            timeStr = '${diff.inMinutes}m ago';
                          } else {
                            timeStr = 'Just now';
                          }
                        }

                        final replies = controller.comments
                            .where((c) => c.parentCommentId == comment.id)
                            .toList();

                        String currentUserId = '';
                        try {
                          currentUserId =
                              Get.find<MaleUserDataController>().userId.value;
                        } catch (_) {}

                        final bool canDeleteComment =
                            comment.userId == currentUserId;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildCommentItem(
                              comment.userName,
                              comment.content,
                              timeStr,
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                left: 55.w,
                                top: 4.h,
                                bottom: 4.h,
                              ),
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _replyToCommentId = comment.id;
                                        _replyToUserName = comment.userName;
                                      });
                                    },
                                    child: Text(
                                      'Reply',
                                      style: GoogleFonts.inter(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.maleColor,
                                      ),
                                    ),
                                  ),
                                  if (canDeleteComment) ...[
                                    SizedBox(width: 15.w),
                                    GestureDetector(
                                      onTap: () async {
                                        final confirm =
                                            await _showDeleteConfirmation(
                                              context,
                                            );
                                        if (confirm == true) {
                                          await controller.deleteComment(
                                            comment.id,
                                            _contentId ?? '',
                                          );
                                        }
                                      },
                                      child: Text(
                                        'Delete',
                                        style: GoogleFonts.inter(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red[300],
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            if (replies.isNotEmpty) ...[
                              Padding(
                                padding: EdgeInsets.only(left: 30.w, top: 8.h),
                                child: Column(
                                  children: replies.map((reply) {
                                    String rTimeStr =
                                        '${reply.createdAt.hour}:${reply.createdAt.minute.toString().padLeft(2, '0')}';
                                    if (DateTime.now()
                                            .difference(reply.createdAt)
                                            .inDays >
                                        0) {
                                      rTimeStr =
                                          '${reply.createdAt.day}/${reply.createdAt.month}/${reply.createdAt.year}';
                                    } else {
                                      final diff = DateTime.now().difference(
                                        reply.createdAt,
                                      );
                                      if (diff.inHours > 0) {
                                        rTimeStr = '${diff.inHours}h ago';
                                      } else if (diff.inMinutes > 0) {
                                        rTimeStr = '${diff.inMinutes}m ago';
                                      } else {
                                        rTimeStr = 'Just now';
                                      }
                                    }

                                    final bool canDeleteReply =
                                        reply.userId == currentUserId ||
                                        comment.userId == currentUserId;

                                    return Padding(
                                      padding: EdgeInsets.only(bottom: 12.h),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          _buildCommentItem(
                                            reply.userName,
                                            reply.content,
                                            rTimeStr,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                              left: 55.w,
                                              top: 4.h,
                                            ),
                                            child: Row(
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      _replyToCommentId =
                                                          comment.id;
                                                      _replyToUserName =
                                                          reply.userName;
                                                      _commentController.text =
                                                          '@${reply.userName} ';
                                                    });
                                                  },
                                                  child: Text(
                                                    'Reply',
                                                    style: GoogleFonts.inter(
                                                      fontSize: 12.sp,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color:
                                                          AppColors.maleColor,
                                                    ),
                                                  ),
                                                ),
                                                if (canDeleteReply) ...[
                                                  SizedBox(width: 15.w),
                                                  GestureDetector(
                                                    onTap: () async {
                                                      final confirm =
                                                          await _showDeleteConfirmation(
                                                            context,
                                                          );
                                                      if (confirm == true) {
                                                        await controller
                                                            .deleteComment(
                                                              reply.id,
                                                              _contentId ?? '',
                                                            );
                                                      }
                                                    },
                                                    child: Text(
                                                      'Delete',
                                                      style: GoogleFonts.inter(
                                                        fontSize: 12.sp,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.red[300],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ],
                        );
                      },
                    );
                  }),
                ],
              ),
            ),
          ),

          // --- ADD COMMENT BAR ---
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.r),
                topRight: Radius.circular(30.r),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_replyToCommentId != null) ...[
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: 10.h,
                        left: 10.w,
                        right: 10.w,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.reply,
                                size: 16.sp,
                                color: AppColors.maleColor,
                              ),
                              SizedBox(width: 5.w),
                              RichText(
                                text: TextSpan(
                                  style: GoogleFonts.inter(
                                    fontSize: 12.sp,
                                    color: AppColors.bodyColor,
                                  ),
                                  children: [
                                    const TextSpan(text: 'Replying to '),
                                    TextSpan(
                                      text: _replyToUserName ?? 'User',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _replyToCommentId = null;
                                _replyToUserName = null;
                              });
                            },
                            child: Icon(
                              Icons.close,
                              size: 16.sp,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 10.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.backgroundColor,
                            borderRadius: BorderRadius.circular(25.r),
                            border: Border.all(
                              color: const Color(
                                0xFFE57373,
                              ).withValues(alpha: 0.2),
                            ),
                          ),
                          child: TextField(
                            controller: _commentController,
                            decoration: InputDecoration(
                              hintText: _replyToCommentId != null
                                  ? 'Reply to $_replyToUserName...'
                                  : 'Add a comment...',
                              hintStyle: GoogleFonts.inter(
                                fontSize: 14.sp,
                                color: AppColors.bodyColor.withValues(
                                  alpha: 0.6,
                                ),
                              ),
                              border: InputBorder.none,
                              isDense: true,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Container(
                        decoration: const BoxDecoration(
                          color: AppColors.maleColor,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.send_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                          onPressed: () async {
                            final text = _commentController.text.trim();
                            if (text.isNotEmpty && _contentId != null) {
                              final parentId = _replyToCommentId;
                              _commentController.clear();
                              setState(() {
                                _replyToCommentId = null;
                                _replyToUserName = null;
                              });
                              FocusScope.of(context).unfocus();
                              final success =
                                  await Get.find<MaleLearningController>()
                                      .addComment(
                                        _contentId!,
                                        text,
                                        parentCommentId: parentId,
                                      );
                              if (!success) {
                                Get.snackbar(
                                  'Error',
                                  'Failed to post comment. Please try again.',
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: Colors.redAccent.withValues(
                                    alpha: 0.8,
                                  ),
                                  colorText: Colors.white,
                                );
                              }
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool?> _showDeleteConfirmation(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          'Delete Comment',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        content: Text(
          'Are you sure you want to delete this comment?',
          style: GoogleFonts.inter(color: Colors.black87),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel', style: GoogleFonts.inter(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              'Delete',
              style: GoogleFonts.inter(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.bodyColor.withValues(alpha: 0.1),
            ),
          ),
          child: Icon(icon, size: 20.sp, color: AppColors.bodyColor),
        ),
        SizedBox(width: 10.w),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            color: AppColors.bodyColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildCommentItem(String name, String comment, String time) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(radius: 20.r, backgroundColor: Colors.grey.shade200),
        SizedBox(width: 15.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(15.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.r),
                  border: Border.all(
                    color: AppColors.bodyColor.withValues(alpha: 0.1),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.titleColor,
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      comment,
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        color: AppColors.bodyColor,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8.h),
              Padding(
                padding: EdgeInsets.only(left: 10.w),
                child: Text(
                  time,
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    color: AppColors.bodyColor.withValues(alpha: 0.5),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
