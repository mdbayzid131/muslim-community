import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:muslim_community/config/themes/app_colors.dart';
import 'package:muslim_community/core/services/auth_service.dart';
import 'package:muslim_community/data/models/learning_content_model.dart';
import 'package:muslim_community/data/repositories/learning_repository.dart';
import 'package:muslim_community/modules/discover/controller/learning_controller.dart';
import 'package:muslim_community/modules/discover/view/learning_details_view.dart';
import 'package:muslim_community/modules/discover/view/umrah_flashcard_view.dart';
import 'package:muslim_community/modules/discover/view/wudu_ghusl_flashcard_view.dart';
import 'package:muslim_community/modules/dua/view/dua_list_view.dart';
import 'package:muslim_community/modules/home/view/three_quls_view.dart';
import 'package:muslim_community/modules/prayer_guide/view/prayer_rakat_guide_view.dart';

class LearningView extends StatelessWidget {
  const LearningView({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure controller is registered
    final controller = Get.isRegistered<LearningController>()
        ? Get.find<LearningController>()
        : Get.put(LearningController(learningRepository: Get.find<LearningRepository>()));

    final role = Get.isRegistered<AuthService>() ? Get.find<AuthService>().userRole : 'male';
    final themeColor = AppColors.getRoleColor(role);

    return Obx(() {
      final isLoading = controller.isLoading.value;
      final contents = controller.learningContents;
      final categories = controller.categories;
      final selectedCategory = controller.selectedCategory.value;

      return RefreshIndicator(
        onRefresh: () => controller.fetchLearningContents(),
        color: themeColor,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
          slivers: [
            // Search Bar
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(top: 10.h, bottom: 14.h),
                child: Container(
                  height: 44.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: TextField(
                    onChanged: (value) => controller.search(value),
                    style: GoogleFonts.inter(fontSize: 13.sp, color: AppColors.titleColor),
                    decoration: InputDecoration(
                      hintText: 'Search lessons, guides, topics...',
                      hintStyle: GoogleFonts.inter(
                        color: Colors.grey.withValues(alpha: 0.6),
                        fontSize: 13.sp,
                      ),
                      prefixIcon: Icon(
                        Icons.search_rounded,
                        color: themeColor.withValues(alpha: 0.6),
                        size: 20.sp,
                      ),
                      suffixIcon: controller.searchQuery.value.isNotEmpty
                          ? IconButton(
                              icon: Icon(Icons.clear_rounded, size: 18.sp, color: Colors.grey),
                              onPressed: () => controller.search(''),
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 10.h),
                    ),
                  ),
                ),
              ),
            ),

            // Interactive Flashcards & Guides Section (Header + Horizontal Scroll)
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Interactive Guides & Flashcards',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.titleColor,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                        decoration: BoxDecoration(
                          color: themeColor.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Text(
                          'Step-by-step',
                          style: GoogleFonts.inter(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600,
                            color: themeColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  SizedBox(
                    height: 130.h,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      children: [
                        _buildQuickGuideCard(
                          title: "Prayer Rakat",
                          subtitle: "Rakat count & rules",
                          icon: Icons.mosque_rounded,
                          themeColor: themeColor,
                          onTap: () {
                            Get.to(
                              () => PrayerRakatGuideView(
                                themeColor: themeColor,
                                isMale: role != 'female',
                              ),
                            );
                          },
                        ),
                        SizedBox(width: 12.w),
                        _buildQuickGuideCard(
                          title: "Umrah Guide",
                          subtitle: "Rituals & steps",
                          icon: Icons.explore_rounded,
                          themeColor: themeColor,
                          onTap: () {
                            Get.to(() => const UmrahFlashcardView(title: "A Guide to Umrah"));
                          },
                        ),
                        SizedBox(width: 12.w),
                        _buildQuickGuideCard(
                          title: "Wudu Guide",
                          subtitle: "Ablution step-by-step",
                          icon: Icons.clean_hands_rounded,
                          themeColor: themeColor,
                          onTap: () {
                            Get.to(() => const WuduGhuslFlashcardView(title: "How to Make Wudu"));
                          },
                        ),
                        SizedBox(width: 12.w),
                        _buildQuickGuideCard(
                          title: "Ghusl Guide",
                          subtitle: "Purification bath",
                          icon: Icons.shower_rounded,
                          themeColor: themeColor,
                          onTap: () {
                            Get.to(() => const WuduGhuslFlashcardView(title: "How to Perform Ghusl"));
                          },
                        ),
                        SizedBox(width: 12.w),
                        _buildQuickGuideCard(
                          title: "3 Quls",
                          subtitle: "Recitation & audio",
                          icon: Icons.menu_book_rounded,
                          themeColor: themeColor,
                          onTap: () {
                            Get.to(() => ThreeQulsView(themeColor: themeColor));
                          },
                        ),
                        SizedBox(width: 12.w),
                        _buildQuickGuideCard(
                          title: "Daily Duas",
                          subtitle: "Waqt & authentic duas",
                          icon: Icons.favorite_rounded,
                          themeColor: themeColor,
                          onTap: () {
                            Get.to(() => const DuaListView());
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),

            // Video Lessons Section Header & Categories Filter
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Islamic Video Lessons',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.titleColor,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      children: categories.map((cat) {
                        final isSelected = selectedCategory.toLowerCase() == cat.toLowerCase();
                        return GestureDetector(
                          onTap: () => controller.setCategory(cat),
                          child: Container(
                            margin: EdgeInsets.only(right: 8.w),
                            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 7.h),
                            decoration: BoxDecoration(
                              color: isSelected ? themeColor : Colors.white,
                              borderRadius: BorderRadius.circular(20.r),
                              border: Border.all(
                                color: isSelected
                                    ? themeColor
                                    : Colors.grey.withValues(alpha: 0.2),
                              ),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: themeColor.withValues(alpha: 0.25),
                                        blurRadius: 8,
                                        offset: const Offset(0, 3),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Text(
                              cat,
                              style: GoogleFonts.inter(
                                fontSize: 12.sp,
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                color: isSelected ? Colors.white : AppColors.bodyColor,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(height: 14.h),
                ],
              ),
            ),

            // Video Contents List / Shimmer / Empty State
            if (isLoading && contents.isEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 40.h),
                  child: Center(
                    child: CircularProgressIndicator(color: themeColor),
                  ),
                ),
              )
            else if (contents.isEmpty)
              SliverToBoxAdapter(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 40.h, horizontal: 20.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.video_library_outlined,
                        size: 48.sp,
                        color: Colors.grey.shade400,
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        'No Lessons Found',
                        style: GoogleFonts.inter(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.titleColor,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'No content available in this category currently.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          color: AppColors.greyColor,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final item = contents[index];
                    return Padding(
                      padding: EdgeInsets.only(bottom: 16.h),
                      child: _buildVideoContentCard(item, themeColor, controller),
                    );
                  },
                  childCount: contents.length,
                ),
              ),

            SliverToBoxAdapter(
              child: SizedBox(height: 20.h),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildQuickGuideCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color themeColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 140.w,
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: themeColor.withValues(alpha: 0.12),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: themeColor.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(icon, color: themeColor, size: 20.sp),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.titleColor,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 10.sp,
                    color: AppColors.bodyColor.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(
                  Icons.arrow_forward_rounded,
                  color: themeColor.withValues(alpha: 0.6),
                  size: 14.sp,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoContentCard(
    LearningContentModel item,
    Color themeColor,
    LearningController controller,
  ) {
    return GestureDetector(
      onTap: () {
        Get.to(
          () => const LearningDetailsView(),
          arguments: {'content': item},
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail Area with Duration & Play Button
            Stack(
              children: [
                Container(
                  height: 155.h,
                  width: double.infinity,
                  color: Colors.black12,
                  child: item.thumbnailUrl.isNotEmpty
                      ? Image.network(
                          item.thumbnailUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              _buildFallbackThumbnail(themeColor),
                        )
                      : _buildFallbackThumbnail(themeColor),
                ),
                // Gradient Overlay
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.45),
                        ],
                      ),
                    ),
                  ),
                ),
                // Play Icon Center
                Positioned.fill(
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.all(10.w),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.55),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white70, width: 1.5),
                      ),
                      child: Icon(
                        Icons.play_arrow_rounded,
                        color: Colors.white,
                        size: 26.sp,
                      ),
                    ),
                  ),
                ),
                // Category Pill Top Left
                Positioned(
                  top: 10.h,
                  left: 10.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: themeColor.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Text(
                      item.category.toUpperCase(),
                      style: GoogleFonts.inter(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
                // Duration Pill Bottom Right
                if (item.durationText.isNotEmpty)
                  Positioned(
                    bottom: 10.h,
                    right: 10.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.75),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.access_time_rounded, color: Colors.white70, size: 10.sp),
                          SizedBox(width: 3.w),
                          Text(
                            item.durationText,
                            style: GoogleFonts.inter(
                              fontSize: 10.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),

            // Card Body (Title, Description snippet, Engagement Bar)
            Padding(
              padding: EdgeInsets.all(14.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.titleColor,
                      height: 1.3,
                    ),
                  ),
                  if (item.description.isNotEmpty) ...[
                    SizedBox(height: 6.h),
                    Text(
                      item.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        color: AppColors.bodyColor.withValues(alpha: 0.8),
                        height: 1.4,
                      ),
                    ),
                  ],
                  SizedBox(height: 12.h),
                  Divider(height: 1, color: Colors.grey.withValues(alpha: 0.1)),
                  SizedBox(height: 10.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Date
                      Text(
                        DateFormat('MMM dd, yyyy').format(item.createdAt),
                        style: GoogleFonts.inter(
                          fontSize: 11.sp,
                          color: AppColors.greyColor,
                        ),
                      ),
                      // Action Buttons (Like & Comments)
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => controller.toggleLike(item.id),
                            child: Row(
                              children: [
                                Icon(
                                  item.isLiked
                                      ? Icons.favorite_rounded
                                      : Icons.favorite_border_rounded,
                                  size: 16.sp,
                                  color: item.isLiked
                                      ? const Color(0xFFFF4757)
                                      : AppColors.greyColor,
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  '${item.likesCount}',
                                  style: GoogleFonts.inter(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                    color: item.isLiked
                                        ? const Color(0xFFFF4757)
                                        : AppColors.greyColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 14.w),
                          Row(
                            children: [
                              Icon(
                                Icons.chat_bubble_outline_rounded,
                                size: 14.sp,
                                color: AppColors.greyColor,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                '${item.commentsCount}',
                                style: GoogleFonts.inter(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.greyColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFallbackThumbnail(Color themeColor) {
    return Container(
      color: themeColor.withValues(alpha: 0.15),
      child: Center(
        child: Icon(
          Icons.menu_book_rounded,
          size: 40.sp,
          color: themeColor.withValues(alpha: 0.6),
        ),
      ),
    );
  }
}
