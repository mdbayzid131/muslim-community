import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';
import 'package:muslim_community/app_config.dart';
import 'package:muslim_community/jummarole/home/controller/jumma_now_playing_controller.dart';

class JummaNowPlayingUI extends StatefulWidget {
  const JummaNowPlayingUI({super.key});

  @override
  State<JummaNowPlayingUI> createState() => _JummaNowPlayingUIState();
}

class _JummaNowPlayingUIState extends State<JummaNowPlayingUI> {
  double _currentPosition = 0.0;
  double _currentVolume = 0.7;
  bool _isPlaying = false;
  late final JummaNowPlayingController _controller;

  VideoPlayerController? _audioController;
  bool _isAudioInitialized = false;
  String _currentTimeText = "0:00";
  String _totalDurationText = "0:00";

  @override
  void initState() {
    super.initState();
    _controller = Get.put(JummaNowPlayingController());

    final args = Get.arguments;
    if (args != null && args['khutbahId'] != null) {
      String khutbahId = args['khutbahId'];
      _controller.fetchKhutbahDetails(khutbahId).then((_) {
        if (_controller.khutbah.value != null) {
          _initAudio(_controller.khutbah.value!.audioUrl);
        }
      });
    }
  }

  String _resolveMediaUrl(String url) {
    if (url.isEmpty) return '';
    String serverBase = AppConfig.baseUrl.replaceAll('/api/v1', '');
    String resolvedUrl = url.trim();
    if (resolvedUrl.startsWith('/')) {
      resolvedUrl = "$serverBase$resolvedUrl";
    } else if (resolvedUrl.startsWith('uploads/')) {
      resolvedUrl = "$serverBase/$resolvedUrl";
    }
    return resolvedUrl;
  }

  void _initAudio(String url) async {
    final resolvedUrl = _resolveMediaUrl(url);
    if (resolvedUrl.isEmpty) return;

    _audioController = VideoPlayerController.networkUrl(Uri.parse(resolvedUrl));
    try {
      await _audioController!.initialize();
      setState(() {
        _isAudioInitialized = true;
        _totalDurationText = _formatDuration(_audioController!.value.duration);
      });

      _audioController!.addListener(() {
        if (mounted) {
          setState(() {
            _currentPosition =
                _audioController!.value.position.inMilliseconds /
                _audioController!.value.duration.inMilliseconds;
            _currentTimeText = _formatDuration(
              _audioController!.value.position,
            );
            _isPlaying = _audioController!.value.isPlaying;
          });
        }
      });
    } catch (e) {
      print("Error initializing audio: $e");
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  void dispose() {
    _audioController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color themeColor = Color(0xFF436E50);

    return Scaffold(
      backgroundColor: const Color(0xFFFDF8F1),
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
      body: Obx(() {
        if (_controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final khutbah = _controller.khutbah.value;
        if (khutbah == null) {
          return const Center(child: Text("Khutbah not found"));
        }

        return SingleChildScrollView(
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
                                  'assets/icons/sun.png',
                                  fit: BoxFit.cover,
                                ),
                          )
                        : Image.asset(
                            'assets/icons/sun.png',
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
              ),

              SizedBox(height: 40.h),

              // Title & Speaker
              Text(
                khutbah.title,
                textAlign: TextAlign.center,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2D3436),
                ),
              ),
              SizedBox(height: 10.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 12.r,
                    backgroundImage: const AssetImage(
                      'assets/icons/abubakr.png',
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

              SizedBox(height: 40.h),

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
                    // Progress Bar (Seeking Option)
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
                        thumbColor: const Color(0xFFA6864D),
                      ),
                      child: Slider(
                        value: _currentPosition,
                        onChanged: (v) {
                          if (_isAudioInitialized) {
                            final newPosition =
                                v *
                                _audioController!.value.duration.inMilliseconds;
                            _audioController!.seekTo(
                              Duration(milliseconds: newPosition.toInt()),
                            );
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _currentTimeText,
                            style: GoogleFonts.inter(
                              fontSize: 10.sp,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            _totalDurationText,
                            style: GoogleFonts.inter(
                              fontSize: 10.sp,
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
                            color: const Color(0xFFA6864D),
                            size: 20.sp,
                          ),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.replay_10,
                            color: const Color(0xFF2D3436),
                            size: 24.sp,
                          ),
                          onPressed: () {
                            if (_isAudioInitialized) {
                              final currentPos =
                                  _audioController!.value.position;
                              _audioController!.seekTo(
                                currentPos - const Duration(seconds: 10),
                              );
                            }
                          },
                        ),
                        GestureDetector(
                          onTap: () {
                            if (_isAudioInitialized) {
                              if (_isPlaying) {
                                _audioController!.pause();
                              } else {
                                _audioController!.play();
                              }
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
                            color: const Color(0xFF2D3436),
                            size: 24.sp,
                          ),
                          onPressed: () {
                            if (_isAudioInitialized) {
                              final currentPos =
                                  _audioController!.value.position;
                              _audioController!.seekTo(
                                currentPos + const Duration(seconds: 10),
                              );
                            }
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.repeat,
                            color: const Color(0xFFA6864D),
                            size: 20.sp,
                          ),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 30.h),

              // Volume Slider (Volume Option)
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
                        thumbColor: const Color(0xFFA6864D),
                      ),
                      child: Slider(
                        value: _currentVolume,
                        onChanged: (v) {
                          setState(() {
                            _currentVolume = v;
                            _audioController?.setVolume(v);
                          });
                        },
                      ),
                    ),
                  ),
                  Icon(Icons.volume_up, color: Colors.grey, size: 20.sp),
                ],
              ),

              SizedBox(height: 30.h),

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
              SizedBox(height: 40.h),
            ],
          ),
        );
      }),
    );
  }
}
