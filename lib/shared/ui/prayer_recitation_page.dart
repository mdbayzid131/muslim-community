import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_community/appcolore.dart';
import 'package:muslim_community/shared/controller/prayer_guide_controller.dart';
import 'package:muslim_community/shared/model/prayer_guide_model.dart';
import 'package:muslim_community/shared/utils/rakat_info.dart';

class PrayerRecitationPage extends StatefulWidget {
  final String waqt;
  final Color themeColor;
  final bool isMale;

  const PrayerRecitationPage({
    super.key,
    required this.waqt,
    required this.themeColor,
    required this.isMale,
  });

  @override
  State<PrayerRecitationPage> createState() => _PrayerRecitationPageState();
}

class _PrayerRecitationPageState extends State<PrayerRecitationPage> {
  late final PrayerGuideController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.put(PrayerGuideController());
    _controller.fetchPrayerGuide(widget.waqt);
  }

  @override
  void dispose() {
    Get.delete<PrayerGuideController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.titleColor,
            size: 20.sp,
          ),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "${widget.waqt} Prayer Guide",
          style: GoogleFonts.playfairDisplay(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.titleColor,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (_controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF26A69A)),
          );
        }

        if (_controller.errorMessage.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _controller.errorMessage.value,
                  style: TextStyle(color: Colors.red, fontSize: 16.sp),
                ),
                SizedBox(height: 20.h),
                ElevatedButton(
                  onPressed: () => _controller.fetchPrayerGuide(widget.waqt),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.themeColor,
                  ),
                  child: const Text(
                    "Retry",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          );
        }

        final steps = _controller.prayerGuideSteps;

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.all(20.w),
          child: Column(
            children: [
              _buildPrayerHeader(),
              SizedBox(height: 25.h),
              ...steps.map(
                (step) => Padding(
                  padding: EdgeInsets.only(bottom: 20.h),
                  child: _buildDynamicStepCard(step),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildPrayerHeader() {
    final rakatInfo = RakatInfo.getRakatInfo(widget.waqt);
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: widget.themeColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: widget.themeColor.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: widget.themeColor.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.mosque_rounded,
              color: widget.themeColor,
              size: 24.sp,
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${widget.waqt} Prayer Guide",
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.titleColor,
                  ),
                ),
                SizedBox(height: 4.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: widget.themeColor,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(
                    "${rakatInfo.waqt}: ${rakatInfo.farzRakats} Rakat Farz (Total ${rakatInfo.totalRakats} Rakats)",
                    style: GoogleFonts.inter(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  "Breakdown: ${rakatInfo.rakatDetailsEn}",
                  style: GoogleFonts.inter(
                    fontSize: 10.sp,
                    color: AppColors.bodyColor.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDynamicStepCard(PrayerGuideStep step) {
    final imagePath = _getSalatPositionImage(step.stepKey);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Step Header
          Padding(
            padding: EdgeInsets.all(15.w),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18.r,
                  backgroundColor: const Color(0xFFE0F7F3),
                  child: Text(
                    step.order?.toString() ?? "-",
                    style: TextStyle(
                      color: const Color(0xFF26A69A),
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
                SizedBox(width: 15.w),
                Expanded(
                  child: Text(
                    step.stepName ?? "",
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.titleColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Salat Position Image
          if (imagePath != null) ...[
            Center(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 12.h, horizontal: 15.w),
                height: 160.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FBFB),
                  borderRadius: BorderRadius.circular(15.r),
                  border: Border.all(
                    color: const Color(0xFF26A69A).withValues(alpha: 0.08),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.r),
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Icon(
                          Icons.image_not_supported_outlined,
                          color: Colors.grey,
                          size: 30.sp,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            const Divider(height: 1),
          ],

          if (step.isPlaceholder == true &&
              step.rakats != null &&
              step.rakats!.isNotEmpty)
            ...step.rakats!.map((rakat) => _buildRakatContent(rakat))
          else if (step.verses != null && step.verses!.isNotEmpty)
            ...step.verses!.map(
              (verse) => _buildRecitationContent(
                title: "Verse ${verse.verseNumber}",
                arabic: verse.arabicText ?? "",
                translation: verse.translation ?? "",
                transliteration: verse.transliteration ?? "",
                audioUrl: verse.audioUrl,
              ),
            )
          else
            _buildRecitationContent(
              title: step.stepName ?? "",
              arabic: step.arabicText ?? "",
              translation: step.translation ?? "",
              transliteration: step.transliteration ?? "",
            ),

          SizedBox(height: 5.h),
        ],
      ),
    );
  }

  Widget _buildRecitationContent({
    required String title,
    required String arabic,
    required String translation,
    required String transliteration,
    String? audioUrl,
  }) {
    if (arabic.isEmpty && translation.isEmpty && transliteration.isEmpty) {
      return SizedBox.shrink();
    }

    return Padding(
      padding: EdgeInsets.all(15.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "RECITE:",
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
              letterSpacing: 1,
            ),
          ),
          SizedBox(height: 10.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: const Color(0xFFF0FDFB),
              borderRadius: BorderRadius.circular(15.r),
              border: Border.all(
                color: const Color(0xFF26A69A).withValues(alpha: 0.2),
              ),
            ),
            child: Column(
              children: [
                if (title.isNotEmpty)
                  Text(
                    title,
                    style: TextStyle(
                      color: const Color(0xFF26A69A),
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                    ),
                  ),
                SizedBox(height: 8.h),
                if (translation.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(bottom: 10.h),
                    child: Text(
                      translation,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.bodyColor,
                        fontSize: 12.sp,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                if (transliteration.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(bottom: 10.h),
                    child: Text(
                      transliteration,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.bodyColor,
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
                if (arabic.isNotEmpty)
                  Text(
                    arabic,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.amiri(
                      color: AppColors.titleColor,
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                if (audioUrl != null && audioUrl.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(top: 15.h),
                    child: Obx(() {
                      bool isPlaying =
                          _controller.currentlyPlayingUrl.value == audioUrl &&
                          _controller.isPlaying.value;
                      return IconButton(
                        icon: Icon(
                          isPlaying
                              ? Icons.pause_circle_filled
                              : Icons.play_circle_fill,
                        ),
                        iconSize: 40.sp,
                        color: const Color(0xFF26A69A),
                        onPressed: () => _controller.playAudio(audioUrl),
                      );
                    }),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRakatContent(Rakat rakat) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "RAKAT ${rakat.rakat} - ${rakat.surahName?.toUpperCase() ?? ''}",
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF26A69A),
              letterSpacing: 1,
            ),
          ),
          SizedBox(height: 10.h),

          if (rakat.verses != null && rakat.verses!.isNotEmpty)
            ...rakat.verses!.map(
              (verse) => _buildRecitationContent(
                title: "Verse ${verse.verseNumber}",
                arabic: verse.arabicText ?? "",
                translation: verse.translation ?? "",
                transliteration: verse.transliteration ?? "",
                audioUrl: verse.audioUrl,
              ),
            )
          else
            _buildRecitationContent(
              title: rakat.surahName ?? "",
              arabic: rakat.arabicText ?? "",
              translation: rakat.translation ?? "",
              transliteration: rakat.transliteration ?? "",
              audioUrl: rakat.audioUrl,
            ),
        ],
      ),
    );
  }

  String? _getSalatPositionImage(String? stepKey) {
    if (stepKey == null) return null;
    final isMale = widget.isMale;

    final genderPath = isMale ? 'male' : 'female';

    switch (stepKey.toLowerCase()) {
      case 'niyyah':
        return 'assets/image/salat position/$genderPath/niyyah.png';
      case 'takbir':
        return 'assets/image/salat position/$genderPath/takbir.png';
      case 'sana':
      case 'surah-al-fatihah':
      case 'additional-surah':
        return 'assets/image/salat position/$genderPath/qiyam.png';
      case 'ruku':
        return 'assets/image/salat position/$genderPath/ruku.png';
      case 'qaumah':
        return 'assets/image/salat position/$genderPath/niyyah.png';
      case 'first-sajdah':
      case 'second-sajdah':
        return 'assets/image/salat position/$genderPath/sajdah.png';
      case 'jalsah':
        return 'assets/image/salat position/$genderPath/jalsah.png';
      case 'tashahhud':
      case 'durood-ibrahim':
      case 'dua':
        return 'assets/image/salat position/$genderPath/jalsah.png';
      case 'salam':
        return 'assets/image/salat position/$genderPath/salam.png';
      default:
        return null;
    }
  }
}
