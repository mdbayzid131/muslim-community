import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_community/config/themes/app_colors.dart';
import 'package:muslim_community/data/repositories/dua_repository.dart';
import 'package:muslim_community/modules/dua/controller/dua_controller.dart';
import 'package:muslim_community/modules/dua/view/dua_details_view.dart';
import 'package:muslim_community/modules/dua/view/dua_list_view.dart';

class DailyDuaCard extends StatelessWidget {
  final Color roleColor;

  const DailyDuaCard({super.key, required this.roleColor});

  @override
  Widget build(BuildContext context) {
    final duaController = Get.isRegistered<DuaController>()
        ? Get.find<DuaController>()
        : Get.put(DuaController(duaRepository: Get.find<DuaRepository>()));

    return Obx(() {
      final dailyDua = duaController.dailyDua.value;
      if (dailyDua == null) {
        return const SizedBox.shrink();
      }

      final isPlaying =
          duaController.currentlyPlayingDuaId.value == dailyDua.id &&
              duaController.isPlaying.value;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Daily & Waqt Dua",
                style: GoogleFonts.playfairDisplay(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.titleColor,
                ),
              ),
              GestureDetector(
                onTap: () => Get.to(() => const DuaListView()),
                child: Text(
                  "View All >",
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: roleColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          GestureDetector(
            onTap: () {
              Get.to(
                () => const DuaDetailsView(),
                arguments: {'dua': dailyDua},
              );
            },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24.r),
                border: Border.all(
                  color: roleColor.withValues(alpha: 0.15),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: roleColor.withValues(alpha: 0.05),
                    blurRadius: 15,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Waqt Pill & Audio button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: roleColor.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          dailyDua.waqt.isNotEmpty
                              ? "${dailyDua.waqt.toUpperCase()} DUA"
                              : "RECOMMENDED DUA",
                          style: GoogleFonts.inter(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                            color: roleColor,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      if (dailyDua.audioUrl.isNotEmpty)
                        GestureDetector(
                          onTap: () => duaController.toggleAudio(dailyDua),
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
                              size: 24.sp,
                            ),
                          ),
                        ),
                    ],
                  ),

                  SizedBox(height: 12.h),

                  // Dua Title
                  Text(
                    dailyDua.title,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.titleColor,
                    ),
                  ),

                  if (dailyDua.arabic.isNotEmpty) ...[
                    SizedBox(height: 10.h),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        dailyDua.arabic,
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

                  if (dailyDua.translation.isNotEmpty || dailyDua.details.isNotEmpty) ...[
                    SizedBox(height: 8.h),
                    Text(
                      dailyDua.translation.isNotEmpty
                          ? dailyDua.translation
                          : dailyDua.details,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        color: AppColors.bodyColor.withValues(alpha: 0.8),
                        height: 1.4,
                      ),
                    ),
                  ],

                  SizedBox(height: 14.h),

                  Divider(height: 1, color: Colors.grey.withValues(alpha: 0.1)),
                  SizedBox(height: 10.h),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Tap to read translation & details",
                        style: GoogleFonts.inter(
                          fontSize: 11.sp,
                          color: AppColors.greyColor,
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_rounded,
                        size: 14.sp,
                        color: roleColor,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }
}
