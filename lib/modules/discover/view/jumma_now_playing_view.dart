import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:muslim_community/config/constants/api_constants.dart';
import 'package:muslim_community/config/constants/image_paths.dart';
import 'package:muslim_community/config/themes/app_colors.dart';
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
  double _currentVolume = 0.7;

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
        await _player.setVolume(_currentVolume);
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
    const Color themeColor = AppColors.jummaColor;
    final khutbah = _khutbah;
    if (khutbah == null) {
      return const Scaffold(body: Center(child: Text("Khutbah not found")));
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: EdgeInsets.all(8.w),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new,
                color: themeColor,
                size: 18.sp,
              ),
              onPressed: () => Get.back(),
            ),
          ),
        ),
        title: Text(
          'NOW PLAYING',
          style: GoogleFonts.inter(
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
            color: themeColor,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 30.w),
        child: Column(
          children: [
            SizedBox(height: 20.h),
            // Khutbah Image
            Center(
              child: Container(
                width: 280.w,
                height: 280.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 30,
                      offset: const Offset(0, 15),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30.r),
                  child: khutbah.thumbnailUrl.isNotEmpty
                      ? Image.network(
                          khutbah.thumbnailUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Image.asset(
                            ImagePaths.sun,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Image.asset(
                          ImagePaths.sun,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
            ),

            SizedBox(height: 35.h),

            // Title & Speaker
            Text(
              khutbah.title,
              textAlign: TextAlign.center,
              style: GoogleFonts.playfairDisplay(
                fontSize: 26.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.titleColor,
              ),
            ),
            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 12.r,
                  backgroundImage: const AssetImage(
                    ImagePaths.abubakr,
                  ),
                ),
                SizedBox(width: 8.w),
                Flexible(
                  child: Text(
                    khutbah.imam,
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: Icon(
                    Icons.circle,
                    size: 4.sp,
                    color: Colors.grey.shade400,
                  ),
                ),
                Flexible(
                  child: Text(
                    khutbah.mosqueName,
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      color: Colors.grey.shade600,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),

            SizedBox(height: 35.h),

            // Player Controls Card
            Container(
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Progress Bar
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 4.h,
                      thumbShape: RoundSliderThumbShape(
                        enabledThumbRadius: 6.r,
                      ),
                      overlayShape: RoundSliderOverlayShape(
                        overlayRadius: 14.r,
                      ),
                      activeTrackColor: themeColor,
                      inactiveTrackColor: Colors.grey.shade200,
                      thumbColor: AppColors.goldColor,
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
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _formatDuration(_position),
                          style: GoogleFonts.inter(
                            fontSize: 11.sp,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          _formatDuration(_duration),
                          style: GoogleFonts.inter(
                            fontSize: 11.sp,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
                  // Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.shuffle,
                          color: AppColors.goldColor,
                          size: 20.sp,
                        ),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.replay_10,
                          color: AppColors.titleColor,
                          size: 24.sp,
                        ),
                        onPressed: () {
                          final newPos =
                              _position - const Duration(seconds: 10);
                          _player.seek(
                              newPos < Duration.zero ? Duration.zero : newPos);
                        },
                      ),
                      GestureDetector(
                        onTap: () {
                          if (_isPlaying) {
                            _player.pause();
                          } else {
                            _player.play();
                          }
                        },
                        child: Container(
                          width: 65.w,
                          height: 65.w,
                          decoration: BoxDecoration(
                            color: themeColor,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: themeColor.withValues(alpha: 0.3),
                                blurRadius: 15,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Icon(
                            _isPlaying ? Icons.pause : Icons.play_arrow,
                            color: Colors.white,
                            size: 30.sp,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.forward_10,
                          color: AppColors.titleColor,
                          size: 24.sp,
                        ),
                        onPressed: () {
                          final newPos =
                              _position + const Duration(seconds: 10);
                          _player.seek(newPos > _duration ? _duration : newPos);
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.repeat,
                          color: AppColors.goldColor,
                          size: 20.sp,
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 25.h),

            // Volume Slider
            Row(
              children: [
                Icon(Icons.volume_down, color: Colors.grey, size: 20.sp),
                Expanded(
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 2.h,
                      thumbShape: RoundSliderThumbShape(
                        enabledThumbRadius: 4.r,
                      ),
                      activeTrackColor: themeColor,
                      inactiveTrackColor: Colors.grey.shade200,
                      thumbColor: AppColors.goldColor,
                    ),
                    child: Slider(
                      value: _currentVolume,
                      onChanged: (v) {
                        setState(() {
                          _currentVolume = v;
                          _player.setVolume(v);
                        });
                      },
                    ),
                  ),
                ),
                Icon(Icons.volume_up, color: Colors.grey, size: 20.sp),
              ],
            ),

            if (khutbah.description.isNotEmpty) ...[
              SizedBox(height: 25.h),
              // About Section
              Container(
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.menu_book,
                              color: themeColor,
                              size: 18.sp,
                            ),
                            SizedBox(width: 10.w),
                            Text(
                              'ABOUT THIS KHUTBAH',
                              style: GoogleFonts.inter(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.bold,
                                color: themeColor,
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.grey,
                          size: 20.sp,
                        ),
                      ],
                    ),
                    SizedBox(height: 15.h),
                    Text(
                      khutbah.description,
                      style: GoogleFonts.inter(
                        fontSize: 13.sp,
                        color: Colors.grey.shade700,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }
}
