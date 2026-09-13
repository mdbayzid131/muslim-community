import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_community/config/themes/app_colors.dart';
import 'package:muslim_community/data/models/dua_model.dart';
import 'package:muslim_community/data/repositories/dua_repository.dart';
import 'package:muslim_community/modules/dua/controller/dua_controller.dart';
import 'package:muslim_community/modules/dua/view/dua_details_view.dart';

class DuaListView extends StatelessWidget {
  const DuaListView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<DuaController>()
        ? Get.find<DuaController>()
        : Get.put(DuaController(duaRepository: Get.find<DuaRepository>()));

    return Obx(() {
      final roleColor = controller.roleColor;
      final isLoading = controller.isLoading.value;
      final duas = controller.duas;
      final waqtFilters = controller.waqtFilters;
      final selectedWaqt = controller.selectedWaqt.value;

      return Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new, color: AppColors.titleColor, size: 20.sp),
            onPressed: () => Get.back(),
          ),
          title: Text(
            'Daily & Prayer Duas',
            style: GoogleFonts.playfairDisplay(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.titleColor,
            ),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            // Search Bar & Filter Header
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
              color: Colors.white,
              child: Column(
                children: [
                  // Search TextField
                  Container(
                    height: 42.h,
                    decoration: BoxDecoration(
                      color: AppColors.backgroundColor,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
                    ),
                    child: TextField(
                      onChanged: (value) => controller.search(value),
                      style: GoogleFonts.inter(fontSize: 13.sp, color: AppColors.titleColor),
                      decoration: InputDecoration(
                        hintText: 'Search Duas by name, meaning...',
                        hintStyle: GoogleFonts.inter(
                          color: Colors.grey.withValues(alpha: 0.6),
                          fontSize: 13.sp,
                        ),
                        prefixIcon: Icon(
                          Icons.search_rounded,
                          color: roleColor.withValues(alpha: 0.6),
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

                  SizedBox(height: 12.h),

                  // Waqt Filter Chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      children: waqtFilters.map((w) {
                        final isSelected = selectedWaqt.toLowerCase() == w.toLowerCase();
                        return GestureDetector(
                          onTap: () => controller.setWaqt(w),
                          child: Container(
                            margin: EdgeInsets.only(right: 8.w),
                            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
                            decoration: BoxDecoration(
                              color: isSelected ? roleColor : Colors.white,
                              borderRadius: BorderRadius.circular(20.r),
                              border: Border.all(
                                color: isSelected
                                    ? roleColor
                                    : Colors.grey.withValues(alpha: 0.25),
                              ),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: roleColor.withValues(alpha: 0.25),
                                        blurRadius: 6,
                                        offset: const Offset(0, 2),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Text(
                              w,
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
                ],
              ),
            ),

            // Dua List Content
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => controller.fetchDuas(),
                color: roleColor,
                child: isLoading && duas.isEmpty
                    ? Center(child: CircularProgressIndicator(color: roleColor))
                    : duas.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.menu_book_rounded,
                                  size: 50.sp,
                                  color: Colors.grey.shade400,
                                ),
                                SizedBox(height: 12.h),
                                Text(
                                  'No Duas Found',
                                  style: GoogleFonts.inter(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.titleColor,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  'Try another category or search keyword',
                                  style: GoogleFonts.inter(
                                    fontSize: 12.sp,
                                    color: AppColors.greyColor,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.separated(
                            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                            physics: const AlwaysScrollableScrollPhysics(
                              parent: BouncingScrollPhysics(),
                            ),
                            itemCount: duas.length,
                            separatorBuilder: (c, i) => SizedBox(height: 14.h),
                            itemBuilder: (context, index) {
                              final dua = duas[index];
                              return _buildDuaCard(dua, roleColor, controller);
                            },
                          ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildDuaCard(DuaModel dua, Color roleColor, DuaController controller) {
    final isPlaying =
        controller.currentlyPlayingDuaId.value == dua.id && controller.isPlaying.value;

    return GestureDetector(
      onTap: () {
        Get.to(
          () => const DuaDetailsView(),
          arguments: {'dua': dua},
        );
      },
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isPlaying
                ? roleColor.withValues(alpha: 0.5)
                : Colors.grey.withValues(alpha: 0.12),
            width: isPlaying ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row: Waqt Tag + Actions (Audio & Copy)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (dua.waqt.isNotEmpty)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: roleColor.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      dua.waqt.toUpperCase(),
                      style: GoogleFonts.inter(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold,
                        color: roleColor,
                        letterSpacing: 0.5,
                      ),
                    ),
                  )
                else
                  Text(
                    dua.category,
                    style: GoogleFonts.inter(
                      fontSize: 11.sp,
                      color: AppColors.greyColor,
                    ),
                  ),
                Row(
                  children: [
                    if (dua.audioUrl.isNotEmpty)
                      GestureDetector(
                        onTap: () => controller.toggleAudio(dua),
                        child: Container(
                          padding: EdgeInsets.all(6.w),
                          decoration: BoxDecoration(
                            color: isPlaying
                                ? roleColor.withValues(alpha: 0.15)
                                : Colors.grey.withValues(alpha: 0.08),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isPlaying
                                ? Icons.pause_circle_filled_rounded
                                : Icons.play_circle_fill_rounded,
                            color: roleColor,
                            size: 22.sp,
                          ),
                        ),
                      ),
                    SizedBox(width: 8.w),
                    GestureDetector(
                      onTap: () => controller.copyDuaText(dua),
                      child: Container(
                        padding: EdgeInsets.all(6.w),
                        decoration: BoxDecoration(
                          color: Colors.grey.withValues(alpha: 0.08),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.copy_rounded,
                          size: 16.sp,
                          color: AppColors.bodyColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: 10.h),

            // Title
            Text(
              dua.title,
              style: GoogleFonts.playfairDisplay(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.titleColor,
              ),
            ),

            if (dua.arabic.isNotEmpty) ...[
              SizedBox(height: 10.h),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  dua.arabic,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textDirection: TextDirection.rtl,
                  style: GoogleFonts.amiri(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.titleColor,
                    height: 1.8,
                  ),
                ),
              ),
            ],

            if (dua.translation.isNotEmpty || dua.details.isNotEmpty) ...[
              SizedBox(height: 8.h),
              Text(
                dua.translation.isNotEmpty ? dua.translation : dua.details,
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

            // Bottom Arrow Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (dua.reference.isNotEmpty)
                  Text(
                    dua.reference,
                    style: GoogleFonts.inter(
                      fontSize: 10.sp,
                      color: AppColors.greyColor,
                    ),
                  )
                else
                  const SizedBox.shrink(),
                Row(
                  children: [
                    Text(
                      "Read Full",
                      style: GoogleFonts.inter(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.bold,
                        color: roleColor,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 10.sp,
                      color: roleColor,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
