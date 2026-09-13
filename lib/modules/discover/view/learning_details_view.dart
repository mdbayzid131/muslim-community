import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:muslim_community/config/themes/app_colors.dart';
import 'package:muslim_community/core/services/auth_service.dart';
import 'package:muslim_community/data/models/learning_comment_model.dart';
import 'package:muslim_community/data/models/learning_content_model.dart';
import 'package:muslim_community/modules/discover/controller/learning_controller.dart';
import 'package:video_player/video_player.dart';

class LearningDetailsView extends StatefulWidget {
  const LearningDetailsView({super.key});

  @override
  State<LearningDetailsView> createState() => _LearningDetailsViewState();
}

class _LearningDetailsViewState extends State<LearningDetailsView> {
  late final LearningController _controller;
  LearningContentModel? _content;

  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  bool _isVideoInitialized = false;
  bool _hasVideoError = false;

  final TextEditingController _commentTextCtrl = TextEditingController();
  final FocusNode _commentFocusNode = FocusNode();

  String? _replyToCommentId;
  String? _replyToUserName;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<LearningController>();

    final args = Get.arguments;
    if (args is Map && args['content'] is LearningContentModel) {
      _content = args['content'];
      _controller.selectedContent.value = _content;
      _initVideo(_content!.videoUrl);
      _controller.fetchComments(_content!.id);
    } else if (args is Map && args['contentId'] != null) {
      final id = args['contentId'].toString();
      _controller.fetchContentDetails(id).then((_) {
        if (_controller.selectedContent.value != null) {
          setState(() {
            _content = _controller.selectedContent.value;
          });
          _initVideo(_content!.videoUrl);
          _controller.fetchComments(_content!.id);
        }
      });
    }
  }

  void _initVideo(String url) async {
    if (url.trim().isEmpty) {
      setState(() => _hasVideoError = true);
      return;
    }

    try {
      final uri = Uri.parse(url);
      _videoPlayerController = VideoPlayerController.networkUrl(uri);
      await _videoPlayerController!.initialize();

      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController!,
        autoPlay: true,
        looping: false,
        aspectRatio: _videoPlayerController!.value.aspectRatio > 0
            ? _videoPlayerController!.value.aspectRatio
            : 16 / 9,
        materialProgressColors: ChewieProgressColors(
          playedColor: _controller.roleColor,
          handleColor: _controller.roleColor,
          backgroundColor: Colors.grey.shade300,
          bufferedColor: Colors.grey.shade200,
        ),
        placeholder: Container(
          color: Colors.black,
          child: const Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),
        ),
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, color: Colors.white70, size: 40.sp),
                SizedBox(height: 8.h),
                Text(
                  "Unable to load video",
                  style: GoogleFonts.inter(color: Colors.white70, fontSize: 13.sp),
                ),
              ],
            ),
          );
        },
      );

      if (mounted) {
        setState(() {
          _isVideoInitialized = true;
        });
      }
    } catch (e) {
      debugPrint("Video init error: $e");
      if (mounted) {
        setState(() {
          _hasVideoError = true;
        });
      }
    }
  }

  @override
  void dispose() {
    _chewieController?.dispose();
    _videoPlayerController?.dispose();
    _commentTextCtrl.dispose();
    _commentFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final content = _controller.selectedContent.value ?? _content;
      final roleColor = _controller.roleColor;

      if (content == null) {
        return Scaffold(
          backgroundColor: AppColors.backgroundColor,
          appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
          body: const Center(child: CircularProgressIndicator()),
        );
      }

      return Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new, color: AppColors.titleColor, size: 20.sp),
            onPressed: () => Get.back(),
          ),
          title: Text(
            'Islamic Lesson',
            style: GoogleFonts.playfairDisplay(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.titleColor,
            ),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            // Video Player Box
            Container(
              width: double.infinity,
              height: 220.h,
              color: Colors.black,
              child: _isVideoInitialized && _chewieController != null
                  ? Chewie(controller: _chewieController!)
                  : _hasVideoError
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.play_disabled_rounded, color: Colors.white54, size: 48.sp),
                              SizedBox(height: 8.h),
                              Text(
                                "Video unavailable",
                                style: GoogleFonts.inter(color: Colors.white70, fontSize: 14.sp),
                              ),
                            ],
                          ),
                        )
                      : const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        ),
            ),

            // Scrollable Details & Comments
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category & Date Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: roleColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Text(
                            content.category.toUpperCase(),
                            style: GoogleFonts.inter(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.bold,
                              color: roleColor,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Icon(Icons.calendar_today_rounded, size: 12.sp, color: AppColors.greyColor),
                            SizedBox(width: 4.w),
                            Text(
                              DateFormat('MMM dd, yyyy').format(content.createdAt),
                              style: GoogleFonts.inter(
                                fontSize: 12.sp,
                                color: AppColors.greyColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    SizedBox(height: 12.h),

                    // Title
                    Text(
                      content.title,
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.titleColor,
                        height: 1.3,
                      ),
                    ),

                    SizedBox(height: 12.h),

                    // Stats Bar (Like & Comments)
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => _controller.toggleLike(content.id),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                            decoration: BoxDecoration(
                              color: content.isLiked
                                  ? const Color(0xFFFF4757).withValues(alpha: 0.1)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(20.r),
                              border: Border.all(
                                color: content.isLiked
                                    ? const Color(0xFFFF4757)
                                    : Colors.grey.withValues(alpha: 0.2),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  content.isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                                  color: content.isLiked ? const Color(0xFFFF4757) : AppColors.bodyColor,
                                  size: 18.sp,
                                ),
                                SizedBox(width: 6.w),
                                Text(
                                  "${content.likesCount} Likes",
                                  style: GoogleFonts.inter(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w600,
                                    color: content.isLiked ? const Color(0xFFFF4757) : AppColors.bodyColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.chat_bubble_outline_rounded, size: 16.sp, color: AppColors.bodyColor),
                              SizedBox(width: 6.w),
                              Text(
                                "${content.commentsCount} Comments",
                                style: GoogleFonts.inter(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.bodyColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    if (content.description.isNotEmpty) ...[
                      SizedBox(height: 16.h),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.02),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "About this Lesson",
                              style: GoogleFonts.inter(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.bold,
                                color: roleColor,
                                letterSpacing: 0.5,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              content.description,
                              style: GoogleFonts.inter(
                                fontSize: 14.sp,
                                color: AppColors.bodyColor,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    SizedBox(height: 24.h),

                    // Comments Section Header
                    Row(
                      children: [
                        Text(
                          "Comments",
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.titleColor,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            color: roleColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Text(
                            "${_controller.comments.length}",
                            style: GoogleFonts.inter(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                              color: roleColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),

                    // Comments List
                    if (_controller.isCommentsLoading.value)
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.h),
                        child: Center(child: CircularProgressIndicator(color: roleColor)),
                      )
                    else if (_controller.comments.isEmpty)
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 30.h),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Column(
                          children: [
                            Icon(Icons.chat_bubble_outline_rounded, size: 40.sp, color: AppColors.greyColor),
                            SizedBox(height: 8.h),
                            Text(
                              "No comments yet",
                              style: GoogleFonts.inter(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.titleColor,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              "Be the first to share your thoughts!",
                              style: GoogleFonts.inter(
                                fontSize: 12.sp,
                                color: AppColors.greyColor,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _controller.comments.length,
                        separatorBuilder: (c, i) => SizedBox(height: 12.h),
                        itemBuilder: (context, index) {
                          final comment = _controller.comments[index];
                          return _buildCommentTile(comment, content.id, roleColor);
                        },
                      ),

                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),

            // Bottom Sticky Comment Input Bar
            _buildCommentInputBar(content.id, roleColor),
          ],
        ),
      );
    });
  }

  Widget _buildCommentTile(LearningCommentModel comment, String contentId, Color roleColor) {
    final currentUserId = Get.find<AuthService>().currentUser.value?.id ?? '';
    final isMyComment = comment.userId.isNotEmpty && (comment.userId == currentUserId);

    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18.r,
            backgroundColor: roleColor.withValues(alpha: 0.1),
            backgroundImage: comment.userImage.isNotEmpty
                ? NetworkImage(comment.userImage)
                : null,
            child: comment.userImage.isEmpty
                ? Text(
                    comment.userName.isNotEmpty ? comment.userName[0].toUpperCase() : 'U',
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: roleColor,
                    ),
                  )
                : null,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      comment.userName,
                      style: GoogleFonts.inter(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.titleColor,
                      ),
                    ),
                    Text(
                      DateFormat('MMM dd, hh:mm a').format(comment.createdAt),
                      style: GoogleFonts.inter(
                        fontSize: 11.sp,
                        color: AppColors.greyColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6.h),
                Text(
                  comment.content,
                  style: GoogleFonts.inter(
                    fontSize: 13.sp,
                    color: AppColors.bodyColor,
                    height: 1.4,
                  ),
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _replyToCommentId = comment.id;
                          _replyToUserName = comment.userName;
                        });
                        _commentFocusNode.requestFocus();
                      },
                      child: Text(
                        "Reply",
                        style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: roleColor,
                        ),
                      ),
                    ),
                    if (isMyComment) ...[
                      SizedBox(width: 16.w),
                      GestureDetector(
                        onTap: () async {
                          final confirm = await _showDeleteDialog();
                          if (confirm == true) {
                            await _controller.deleteComment(comment.id, contentId);
                          }
                        },
                        child: Text(
                          "Delete",
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.redAccent,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentInputBar(String contentId, Color roleColor) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_replyToCommentId != null)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                margin: EdgeInsets.only(bottom: 8.h),
                decoration: BoxDecoration(
                  color: roleColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Replying to @$_replyToUserName",
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: roleColor,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _replyToCommentId = null;
                          _replyToUserName = null;
                        });
                      },
                      child: Icon(Icons.close_rounded, size: 16.sp, color: roleColor),
                    ),
                  ],
                ),
              ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundColor,
                      borderRadius: BorderRadius.circular(25.r),
                      border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
                    ),
                    child: TextField(
                      controller: _commentTextCtrl,
                      focusNode: _commentFocusNode,
                      style: GoogleFonts.inter(fontSize: 14.sp, color: AppColors.titleColor),
                      decoration: InputDecoration(
                        hintText: _replyToCommentId != null
                            ? "Reply to $_replyToUserName..."
                            : "Add a comment...",
                        hintStyle: GoogleFonts.inter(
                          fontSize: 14.sp,
                          color: AppColors.greyColor,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Obx(() {
                  final isSending = _controller.isSubmittingComment.value;
                  return GestureDetector(
                    onTap: isSending
                        ? null
                        : () async {
                            final text = _commentTextCtrl.text.trim();
                            if (text.isNotEmpty) {
                              final parentId = _replyToCommentId;
                              _commentTextCtrl.clear();
                              setState(() {
                                _replyToCommentId = null;
                                _replyToUserName = null;
                              });
                              _commentFocusNode.unfocus();

                              await _controller.addComment(
                                contentId,
                                text,
                                parentCommentId: parentId,
                              );
                            }
                          },
                    child: Container(
                      width: 44.w,
                      height: 44.w,
                      decoration: BoxDecoration(
                        color: roleColor,
                        shape: BoxShape.circle,
                      ),
                      child: isSending
                          ? Center(
                              child: SizedBox(
                                width: 20.w,
                                height: 20.w,
                                child: const CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              ),
                            )
                          : Icon(
                              Icons.send_rounded,
                              color: Colors.white,
                              size: 20.sp,
                            ),
                    ),
                  );
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<bool?> _showDeleteDialog() {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        title: Text(
          'Delete Comment',
          style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16.sp),
        ),
        content: Text(
          'Are you sure you want to delete this comment?',
          style: GoogleFonts.inter(fontSize: 14.sp, color: AppColors.bodyColor),
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
              style: GoogleFonts.inter(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
