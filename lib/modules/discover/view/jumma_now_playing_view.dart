import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:muslim_community/config/constants/api_constants.dart';
import 'package:muslim_community/config/themes/app_colors.dart';
import 'package:muslim_community/core/widgets/custom_app_bar.dart';
import 'package:muslim_community/data/models/khutbah_model.dart';

class JummaNowPlayingView extends StatefulWidget {
  const JummaNowPlayingView({super.key});

  @override
  State<JummaNowPlayingView> createState() => _JummaNowPlayingViewState();
}

class _JummaNowPlayingViewState extends State<JummaNowPlayingView> {
  final AudioPlayer _player = AudioPlayer();
  KhutbahModel? _khutbah;
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    if (args is Map && args['khutbah'] is KhutbahModel) {
      _khutbah = args['khutbah'];
      _initAudio(_khutbah!.audioUrl);
    }

    _player.playerStateStream.listen((state) {
      if (mounted) {
        setState(() {
          _isPlaying = state.playing;
        });
      }
    });

    _player.durationStream.listen((d) {
      if (mounted && d != null) {
        setState(() {
          _duration = d;
        });
      }
    });

    _player.positionStream.listen((p) {
      if (mounted) {
        setState(() {
          _position = p;
        });
      }
    });
  }

  void _initAudio(String url) async {
    final fullUrl = ApiConstants.getImageUrl(url);
    if (fullUrl.isNotEmpty) {
      try {
        await _player.setUrl(fullUrl);
        await _player.play();
      } catch (e) {
        debugPrint("Audio play error: $e");
      }
    }
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final m = twoDigits(d.inMinutes.remainder(60));
    final s = twoDigits(d.inSeconds.remainder(60));
    return "$m:$s";
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final khutbah = _khutbah;
    if (khutbah == null) {
      return const Scaffold(body: Center(child: Text("Khutbah not found")));
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: const CustomAppBar(title: "Now Playing"),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
          child: Column(
            children: [
              const Spacer(),
              // Thumbnail
              Container(
                width: 260.w,
                height: 260.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28.r),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.jummaColor.withValues(alpha: 0.2),
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(28.r),
                  child: Image.network(
                    khutbah.thumbnailUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (c, e, s) => Container(
                      color: AppColors.jummaColor.withValues(alpha: 0.2),
                      child: Icon(
                        Icons.mic_none_rounded,
                        color: AppColors.jummaColor,
                        size: 70.sp,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 36.h),

              // Title and speaker
              Text(
                khutbah.title,
                textAlign: TextAlign.center,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.titleColor,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                khutbah.speaker,
                style: GoogleFonts.inter(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.jummaColor,
                ),
              ),
              SizedBox(height: 30.h),

              // Progress Bar
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: AppColors.jummaColor,
                  inactiveTrackColor:
                      AppColors.jummaColor.withValues(alpha: 0.15),
                  thumbColor: AppColors.jummaColor,
                  trackHeight: 4.h,
                  thumbShape:
                      RoundSliderThumbShape(enabledThumbRadius: 7.r),
                ),
                child: Slider(
                  value: _duration.inMilliseconds > 0
                      ? (_position.inMilliseconds /
                              _duration.inMilliseconds)
                          .clamp(0.0, 1.0)
                      : 0.0,
                  onChanged: (val) {
                    final target = _duration * val;
                    _player.seek(target);
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatDuration(_position),
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        color: AppColors.greyColor,
                      ),
                    ),
                    Text(
                      _formatDuration(_duration),
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        color: AppColors.greyColor,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),

              // Play / Pause Controls
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.replay_10_rounded,
                        size: 32.sp, color: AppColors.titleColor),
                    onPressed: () {
                      final newPos = _position - const Duration(seconds: 10);
                      _player.seek(
                          newPos < Duration.zero ? Duration.zero : newPos);
                    },
                  ),
                  SizedBox(width: 20.w),
                  GestureDetector(
                    onTap: () {
                      if (_isPlaying) {
                        _player.pause();
                      } else {
                        _player.play();
                      }
                    },
                    child: Container(
                      width: 68.w,
                      height: 68.w,
                      decoration: const BoxDecoration(
                        color: AppColors.jummaColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _isPlaying
                            ? Icons.pause_rounded
                            : Icons.play_arrow_rounded,
                        color: Colors.white,
                        size: 36.sp,
                      ),
                    ),
                  ),
                  SizedBox(width: 20.w),
                  IconButton(
                    icon: Icon(Icons.forward_10_rounded,
                        size: 32.sp, color: AppColors.titleColor),
                    onPressed: () {
                      final newPos = _position + const Duration(seconds: 10);
                      _player.seek(
                          newPos > _duration ? _duration : newPos);
                    },
                  ),
                ],
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
