import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_community/config/themes/app_colors.dart';
import 'package:muslim_community/data/models/dua_model.dart';
import 'package:muslim_community/modules/dua/controller/dua_controller.dart';

class DuaDetailsView extends StatefulWidget {
  const DuaDetailsView({super.key});

  @override
  State<DuaDetailsView> createState() => _DuaDetailsViewState();
}

class _DuaDetailsViewState extends State<DuaDetailsView> {
  late final DuaController _controller;
  DuaModel? _dua;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<DuaController>();

    final args = Get.arguments;
    if (args is Map && args['dua'] is DuaModel) {
      _dua = args['dua'];
      _controller.selectedDua.value = _dua;
    } else if (args is Map && args['duaId'] != null) {
      final id = args['duaId'].toString();
      _controller.fetchDuaDetails(id).then((_) {
        setState(() {
          _dua = _controller.selectedDua.value;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final dua = _controller.selectedDua.value ?? _dua;
      final roleColor = _controller.roleColor;

      if (_controller.isDetailLoading.value && dua == null) {
        return Scaffold(
          backgroundColor: AppColors.backgroundColor,
          appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
          body: Center(child: CircularProgressIndicator(color: roleColor)),
        );
      }

      if (dua == null) {
        return Scaffold(
          backgroundColor: AppColors.backgroundColor,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_new, color: AppColors.titleColor, size: 20.sp),
              onPressed: () => Get.back(),
            ),
          ),
          body: const Center(child: Text("Dua not found")),
        );
      }

      final isCurrentlyPlaying =
          _controller.currentlyPlayingDuaId.value == dua.id && _controller.isPlaying.value;

      return Scaffold(
        backgroundColor: const Color(0xFFFAF8F5),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new, color: AppColors.titleColor, size: 20.sp),
            onPressed: () => Get.back(),
          ),
          title: Text(
            dua.title.isNotEmpty ? dua.title : "Daily Dua",
            style: GoogleFonts.playfairDisplay(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.titleColor,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.copy_rounded, color: roleColor, size: 20.sp),
              onPressed: () => _controller.copyDuaText(dua),
              tooltip: "Copy Dua",
            ),
          ],
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Waqt Badge & Category
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (dua.waqt.isNotEmpty)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
                      decoration: BoxDecoration(
                        color: roleColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: roleColor.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.access_time_filled_rounded, size: 12.sp, color: roleColor),
                          SizedBox(width: 5.w),
                          Text(
                            dua.waqt.toUpperCase(),
                            style: GoogleFonts.inter(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.bold,
                              color: roleColor,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    const SizedBox.shrink(),
                  if (dua.category.isNotEmpty)
                    Text(
                      dua.category,
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.greyColor,
                      ),
                    ),
                ],
              ),

              SizedBox(height: 16.h),

              // Arabic Card
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(22.w),
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
                  children: [
                    if (dua.arabic.isNotEmpty)
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          dua.arabic,
                          textAlign: TextAlign.center,
                          textDirection: TextDirection.rtl,
                          style: GoogleFonts.amiri(
                            fontSize: 26.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.titleColor,
                            height: 2.0,
                          ),
                        ),
                      )
                    else
                      Text(
                        dua.title,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.titleColor,
                        ),
                      ),
                  ],
                ),
              ),

              SizedBox(height: 20.h),

              // Audio Player Bar (if audioUrl exists)
              if (dua.audioUrl.isNotEmpty) ...[
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: roleColor.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: roleColor.withValues(alpha: 0.2)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => _controller.toggleAudio(dua),
                            child: Container(
                              padding: EdgeInsets.all(12.w),
                              decoration: BoxDecoration(
                                color: roleColor,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                isCurrentlyPlaying
                                    ? Icons.pause_rounded
                                    : Icons.play_arrow_rounded,
                                color: Colors.white,
                                size: 26.sp,
                              ),
                            ),
                          ),
                          SizedBox(width: 14.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  isCurrentlyPlaying
                                      ? "Playing Dua Recitation..."
                                      : "Listen to Dua Recitation",
                                  style: GoogleFonts.inter(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.titleColor,
                                  ),
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  "Audio Recitation",
                                  style: GoogleFonts.inter(
                                    fontSize: 11.sp,
                                    color: AppColors.bodyColor.withValues(alpha: 0.7),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (_controller.currentlyPlayingDuaId.value == dua.id)
                            IconButton(
                              icon: const Icon(Icons.stop_circle_rounded, color: Colors.redAccent),
                              onPressed: () => _controller.stopAudio(),
                            ),
                        ],
                      ),
                      if (_controller.currentlyPlayingDuaId.value == dua.id) ...[
                        SizedBox(height: 12.h),
                        ProgressBar(
                          progress: _controller.audioPosition.value,
                          total: _controller.audioDuration.value,
                          progressBarColor: roleColor,
                          baseBarColor: roleColor.withValues(alpha: 0.2),
                          thumbColor: roleColor,
                          timeLabelTextStyle: GoogleFonts.inter(
                            fontSize: 11.sp,
                            color: AppColors.bodyColor,
                          ),
                          onSeek: (duration) {
                            _controller.audioPlayer.seek(duration);
                          },
                        ),
                      ],
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
              ],

              // Pronunciation / Transliteration Box
              if (dua.transliteration.isNotEmpty) ...[
                _buildInfoSection(
                  title: "Pronunciation & Transliteration",
                  content: dua.transliteration,
                  icon: Icons.record_voice_over_rounded,
                  roleColor: roleColor,
                  isItalic: true,
                ),
                SizedBox(height: 16.h),
              ],

              // Meaning & Translation Box
              if (dua.translation.isNotEmpty || dua.details.isNotEmpty) ...[
                _buildInfoSection(
                  title: "Meaning & Translation",
                  content: dua.translation.isNotEmpty ? dua.translation : dua.details,
                  icon: Icons.translate_rounded,
                  roleColor: roleColor,
                ),
                SizedBox(height: 16.h),
              ],

              // Reference / Source Box
              if (dua.reference.isNotEmpty) ...[
                _buildInfoSection(
                  title: "Reference & Source",
                  content: dua.reference,
                  icon: Icons.menu_book_rounded,
                  roleColor: roleColor,
                  bgColor: const Color(0xFFF0FDFB).withValues(alpha: 0.6),
                ),
                SizedBox(height: 20.h),
              ],
            ],
          ),
        ),
      );
    });
  }

  Widget _buildInfoSection({
    required String title,
    required String content,
    required IconData icon,
    required Color roleColor,
    bool isItalic = false,
    Color? bgColor,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: bgColor ?? Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16.sp, color: roleColor),
              SizedBox(width: 8.w),
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                  color: roleColor,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Text(
            content,
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              color: AppColors.bodyColor,
              height: 1.5,
              fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
            ),
          ),
        ],
      ),
    );
  }
}
