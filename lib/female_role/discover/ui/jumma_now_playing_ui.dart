import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';
import 'package:muslim_community/app_config.dart';
import 'package:muslim_community/appcolore.dart';
import 'package:muslim_community/shared/model/khutbah_model.dart';
import 'package:muslim_community/female_role/discover/controller/jummanowplayingcontroller.dart';

class FemaleJummaNowPlayingUI extends StatefulWidget {
  const FemaleJummaNowPlayingUI({super.key});

  @override
  State<FemaleJummaNowPlayingUI> createState() =>
      _FemaleJummaNowPlayingUIState();
}

class _FemaleJummaNowPlayingUIState extends State<FemaleJummaNowPlayingUI> {
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

    try {
      final args = Get.arguments;
      debugPrint(
        "FemaleJummaNowPlayingUI: Get.arguments received: $args (Type: ${args?.runtimeType})",
      );

      if (args is KhutbahModel) {
        _controller.khutbah.value = args;
        _initAudio(args.audioUrl);
      } else if (args is Map<String, dynamic>) {
        final model = KhutbahModel.fromJson(args);
        _controller.khutbah.value = model;
        _initAudio(model.audioUrl);
      } else if (args is Map) {
        final model = KhutbahModel.fromJson(Map<String, dynamic>.from(args));
        _controller.khutbah.value = model;
        _initAudio(model.audioUrl);
      } else if (args is String) {
        debugPrint("Received String ID argument, fetching details: '$args'");
        _controller.fetchKhutbahDetails(args).then((_) {
          if (_controller.khutbah.value != null) {
            _initAudio(_controller.khutbah.value!.audioUrl);
          } else {
            debugPrint("Failed to fetch khutbah details for ID: '$args'");
          }
        });
      } else if (args != null && args.toString().isNotEmpty) {
        debugPrint("Attempting to parse/fetch unknown argument format: $args");
        _controller.fetchKhutbahDetails(args.toString()).then((_) {
          if (_controller.khutbah.value != null) {
            _initAudio(_controller.khutbah.value!.audioUrl);
          }
        });
      } else {
        debugPrint("Warning: Get.arguments is null in FemaleJummaNowPlayingUI");
      }
    } catch (e, stack) {
      debugPrint(
        "Exception inside FemaleJummaNowPlayingUI initState: $e\n$stack",
      );
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

  Future<void> _initAudio(String rawAudioUrl) async {
    if (rawAudioUrl.isEmpty) {
      debugPrint(
        "Audio Playback: Received empty audio URL, skipping initialization.",
      );
      return;
    }

    final String cleanUrl = _resolveMediaUrl(rawAudioUrl);
    debugPrint("===== AUDIO PLAYBACK INITIALIZATION =====");
    debugPrint("Raw Audio URL from Server: '$rawAudioUrl'");
    debugPrint("Resolved Audio URL: '$cleanUrl'");
    debugPrint("Using AppConfig.baseUrl: '${AppConfig.baseUrl}'");

    try {
      if (_audioController != null) {
        debugPrint("Disposing previous AudioPlayerController...");
        _audioController!.removeListener(_audioListener);
        await _audioController!.dispose();
      }

      debugPrint("Instantiating VideoPlayerController for audio...");
      _audioController = VideoPlayerController.networkUrl(Uri.parse(cleanUrl));

      debugPrint("Starting Audio VideoPlayerController.initialize()...");
      await _audioController!.initialize();

      debugPrint("Audio VideoPlayerController initialization SUCCESSFUL");
      debugPrint("Audio Duration: ${_audioController!.value.duration}");

      _audioController!.setVolume(_currentVolume);
      _audioController!.addListener(_audioListener);

      setState(() {
        _isAudioInitialized = true;
        _totalDurationText = _formatDuration(_audioController!.value.duration);
      });
    } catch (e, stack) {
      debugPrint("CRITICAL EXCEPTION during Audio Player setup: $e");
      debugPrint("Stacktrace: $stack");
      setState(() {
        _isAudioInitialized = false;
      });
    }
    debugPrint("===== AUDIO PLAYBACK INITIALIZATION END =====");
  }

  void _audioListener() {
    if (!mounted || _audioController == null) return;

    final value = _audioController!.value;
    if (value.isInitialized) {
      setState(() {
        _isPlaying = value.isPlaying;

        final duration = value.duration;
        final position = value.position;

        if (duration.inMilliseconds > 0) {
          _currentPosition = position.inMilliseconds / duration.inMilliseconds;
        }

        _currentTimeText = _formatDuration(position);
        _totalDurationText = _formatDuration(duration);
      });

      if (value.hasError) {
        print("Audio Player Runtime Error: ${value.errorDescription}");
      }
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  void dispose() {
    if (_audioController != null) {
      _audioController!.removeListener(_audioListener);
      _audioController!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color themeColor = AppColors.femaleColor;

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
        if (_controller.isLoading.value && _controller.khutbah.value == null) {
          return const Center(
            child: CircularProgressIndicator(color: themeColor),
          );
        }

        final khutbah = _controller.khutbah.value;

        if (khutbah == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 48.sp, color: Colors.grey),
                SizedBox(height: 16.h),
                Text(
                  'No Khutbah selected',
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          );
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
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Icon(Icons.circle, size: 4.sp, color: Colors.grey.shade400),
                  SizedBox(width: 8.w),
                  Flexible(
                    child: Text(
                      khutbah.mosqueName,
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        color: Colors.grey.shade600,
                      ),
                      overflow: TextOverflow.ellipsis,
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
                        thumbColor: const Color(0xFFA6864D),
                      ),
                      child: Slider(
                        value: _currentPosition.clamp(0.0, 1.0),
                        onChanged: _isAudioInitialized
                            ? (v) {
                                setState(() {
                                  _currentPosition = v;
                                });
                              }
                            : null,
                        onChangeEnd: _isAudioInitialized
                            ? (v) {
                                if (_audioController != null) {
                                  final duration =
                                      _audioController!.value.duration;
                                  final target = duration * v;
                                  _audioController!.seekTo(target);
                                }
                              }
                            : null,
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
                          onPressed:
                              _isAudioInitialized && _audioController != null
                              ? () {
                                  final position =
                                      _audioController!.value.position;
                                  _audioController!.seekTo(
                                    position - const Duration(seconds: 10),
                                  );
                                }
                              : null,
                        ),
                        GestureDetector(
                          onTap: _isAudioInitialized && _audioController != null
                              ? () {
                                  if (_isPlaying) {
                                    _audioController!.pause();
                                    print("Audio playback PAUSED by user");
                                  } else {
                                    _audioController!.play();
                                    print("Audio playback STARTED by user");
                                  }
                                }
                              : null,
                          child: Container(
                            width: 65.w,
                            height: 65.w,
                            decoration: BoxDecoration(
                              color: _isAudioInitialized
                                  ? themeColor
                                  : Colors.grey.shade400,
                              shape: BoxShape.circle,
                              boxShadow: _isAudioInitialized
                                  ? [
                                      BoxShadow(
                                        color: themeColor.withValues(
                                          alpha: 0.3,
                                        ),
                                        blurRadius: 15,
                                        offset: const Offset(0, 8),
                                      ),
                                    ]
                                  : null,
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
                          onPressed:
                              _isAudioInitialized && _audioController != null
                              ? () {
                                  final position =
                                      _audioController!.value.position;
                                  _audioController!.seekTo(
                                    position + const Duration(seconds: 10),
                                  );
                                }
                              : null,
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
                        thumbColor: const Color(0xFFA6864D),
                      ),
                      child: Slider(
                        value: _currentVolume,
                        onChanged: (v) {
                          setState(() {
                            _currentVolume = v;
                          });
                          _audioController?.setVolume(v);
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
                      khutbah.description.isNotEmpty
                          ? khutbah.description
                          : 'In this khutbah, the Sheikh discusses the importance of mindfulness in Salah.',
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
