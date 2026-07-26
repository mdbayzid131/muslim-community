import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:muslim_community/appcolore.dart';

class VerseModel {
  final int number;
  final String arabic;
  final String transliteration;
  final String english;
  final String audioUrl;

  const VerseModel({
    required this.number,
    required this.arabic,
    required this.transliteration,
    required this.english,
    required this.audioUrl,
  });
}

class SurahModel {
  final String name;
  final String arabicName;
  final String description;
  final String benefits;
  final List<VerseModel> verses;

  const SurahModel({
    required this.name,
    required this.arabicName,
    required this.description,
    required this.benefits,
    required this.verses,
  });
}

class ThreeQulsUI extends StatefulWidget {
  final Color themeColor;

  const ThreeQulsUI({super.key, required this.themeColor});

  @override
  State<ThreeQulsUI> createState() => _ThreeQulsUIState();
}

class _ThreeQulsUIState extends State<ThreeQulsUI>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final AudioPlayer _audioPlayer = AudioPlayer();

  // Playback state
  int _activeSurahIndex = 0;
  int? _activeVerseIndex;
  bool _isPlaying = false;
  bool _isFullSurahPlaying = false;
  String _currentlyPlayingUrl = '';

  final List<SurahModel> _surahs = const [
    SurahModel(
      name: "Surah Al-Ikhlas",
      arabicName: "سورة الإخلاص",
      description: "Sincerity / Purity of Faith (Surah 112)",
      benefits:
          "Prophet Muhammad ﷺ said: \"Is one of you unable to recite a third of the Quran in one night? ... Say: He is Allah, One (Surah Al-Ikhlas) is equal to a third of the Quran.\" (Sahih Muslim)",
      verses: [
        VerseModel(
          number: 1,
          arabic: "قُلْ هُوَ اللَّهُ أَحَدٌ",
          transliteration: "Qul huwa Llahu aḥad",
          english: "Say, \"He is Allah, [who is] One,\"",
          audioUrl: "https://verses.quran.foundation/Alafasy/mp3/112001.mp3",
        ),
        VerseModel(
          number: 2,
          arabic: "اللَّهُ الصَّمَدُ",
          transliteration: "Allahu ṣ-ṣamad",
          english: "\"Allah, the Eternal Refuge.\"",
          audioUrl: "https://verses.quran.foundation/Alafasy/mp3/112002.mp3",
        ),
        VerseModel(
          number: 3,
          arabic: "لَمْ يَلِدْ وَلَمْ يُولَدْ",
          transliteration: "Lam yalid wa-lam yūlad",
          english: "\"He neither begets nor is born,\"",
          audioUrl: "https://verses.quran.foundation/Alafasy/mp3/112003.mp3",
        ),
        VerseModel(
          number: 4,
          arabic: "وَلَمْ يَكُن لَّهُ كُفُوًا أَحَدٌ",
          transliteration: "Wa-lam yakun lahū kufuwan aḥad",
          english: "\"Nor is there to Him any equivalent.\"",
          audioUrl: "https://verses.quran.foundation/Alafasy/mp3/112004.mp3",
        ),
      ],
    ),
    SurahModel(
      name: "Surah Al-Falaq",
      arabicName: "سورة الفلق",
      description: "The Daybreak (Surah 113)",
      benefits:
          "Recited for protection from evil creations, darkness, witchcraft, and the jealousy of enviers. The Prophet ﷺ used to recite the 3 Quls every night before sleeping.",
      verses: [
        VerseModel(
          number: 1,
          arabic: "قُلْ أَعُوذُ بِرَبِّ الْفَلَقِ",
          transliteration: "Qul a‘ūdhu birabbil-falaq",
          english: "Say, \"I seek refuge in the Lord of daybreak,\"",
          audioUrl: "https://verses.quran.foundation/Alafasy/mp3/113001.mp3",
        ),
        VerseModel(
          number: 2,
          arabic: "مِن شَرِّ مَا خَلَقَ",
          transliteration: "Min sharri mā khalaq",
          english: "\"From the evil of what He created,\"",
          audioUrl: "https://verses.quran.foundation/Alafasy/mp3/113002.mp3",
        ),
        VerseModel(
          number: 3,
          arabic: "وَمِن شَرِّ غَاسِقٍ إِذَا وَقَبَ",
          transliteration: "Wa min sharri ghāsiqin idhā waqab",
          english: "\"And from the evil of darkness when it spreads,\"",
          audioUrl: "https://verses.quran.foundation/Alafasy/mp3/113003.mp3",
        ),
        VerseModel(
          number: 4,
          arabic: "وَمِن شَرِّ النَّفَّاثَاتِ فِي الْعُقَدِ",
          transliteration: "Wa min sharrin-naffāthāti fil-‘uqad",
          english:
              "\"And from the evil of those who blow on knots (practicing witchcraft),\"",
          audioUrl: "https://verses.quran.foundation/Alafasy/mp3/113004.mp3",
        ),
        VerseModel(
          number: 5,
          arabic: "وَمِن شَرِّ حَاسِدٍ إِذَا حَسَدَ",
          transliteration: "Wa min sharri ḥāsidin idhā ḥasad",
          english: "\"And from the evil of an envier when he envies.\"",
          audioUrl: "https://verses.quran.foundation/Alafasy/mp3/113005.mp3",
        ),
      ],
    ),
    SurahModel(
      name: "Surah An-Nas",
      arabicName: "سورة الناس",
      description: "Mankind (Surah 114)",
      benefits:
          "Recited to seek shelter from the internal whispers of Shaytan and all evil whisperers among both jinn and mankind. Completes the set of protective surahs.",
      verses: [
        VerseModel(
          number: 1,
          arabic: "قُلْ أَعُوذُ بِرَبِّ النَّاسِ",
          transliteration: "Qul a‘ūdhu birabbin-nās",
          english: "Say, \"I seek refuge in the Lord of mankind,\"",
          audioUrl: "https://verses.quran.foundation/Alafasy/mp3/114001.mp3",
        ),
        VerseModel(
          number: 2,
          arabic: "مَلِكِ النَّاسِ",
          transliteration: "Malikin-nās",
          english: "\"The King of mankind,\"",
          audioUrl: "https://verses.quran.foundation/Alafasy/mp3/114002.mp3",
        ),
        VerseModel(
          number: 3,
          arabic: "إِلَٰهِ النَّاسِ",
          transliteration: "Ilāhin-nās",
          english: "\"The God of mankind,\"",
          audioUrl: "https://verses.quran.foundation/Alafasy/mp3/114003.mp3",
        ),
        VerseModel(
          number: 4,
          arabic: "مِن شَرِّ الْوَسْوَاسِ الْخَنَّاسِ",
          transliteration: "Min sharril-waswāsil-khannās",
          english: "\"From the evil of the whisperer who withdraws,\"",
          audioUrl: "https://verses.quran.foundation/Alafasy/mp3/114004.mp3",
        ),
        VerseModel(
          number: 5,
          arabic: "الَّذِي يُوَسْوِسُ فِي صُدُورِ النَّاسِ",
          transliteration: "Alladhī yuwaswisu fī ṣudūrin-nās",
          english: "\"Who whispers into the hearts of mankind,\"",
          audioUrl: "https://verses.quran.foundation/Alafasy/mp3/114005.mp3",
        ),
        VerseModel(
          number: 6,
          arabic: "مِنَ الْجِنَّةِ وَالنَّاسِ",
          transliteration: "Minal-jinnati wan-nās",
          english: "\"From among jinn and mankind.\"",
          audioUrl: "https://verses.quran.foundation/Alafasy/mp3/114006.mp3",
        ),
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _surahs.length, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        _stopAudio();
        setState(() {
          _activeSurahIndex = _tabController.index;
        });
      }
    });

    // Listen to player state
    _audioPlayer.playerStateStream.listen((state) {
      if (mounted) {
        setState(() {
          _isPlaying = state.playing;
        });
        if (state.processingState == ProcessingState.completed) {
          _stopAudio();
        }
      }
    });

    // Listen to index changes in playlist to highlight active verse
    _audioPlayer.currentIndexStream.listen((index) {
      if (mounted && _isFullSurahPlaying) {
        setState(() {
          _activeVerseIndex = index;
        });
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _stopAudio() async {
    await _audioPlayer.stop();
    if (mounted) {
      setState(() {
        _isPlaying = false;
        _isFullSurahPlaying = false;
        _activeVerseIndex = null;
        _currentlyPlayingUrl = '';
      });
    }
  }

  Future<void> _playVerse(String url, int index) async {
    try {
      if (_currentlyPlayingUrl == url && _isPlaying) {
        await _audioPlayer.pause();
        return;
      }

      await _stopAudio();

      setState(() {
        _currentlyPlayingUrl = url;
        _activeVerseIndex = index;
        _isPlaying = true;
      });

      await _audioPlayer.setUrl(
        url,
        headers: {
          'User-Agent':
              'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
        },
      );
      await _audioPlayer.play();
    } catch (e) {
      debugPrint("Error playing verse audio: $e");
      _stopAudio();
    }
  }

  Future<void> _playFullSurah() async {
    try {
      if (_isFullSurahPlaying && _isPlaying) {
        await _audioPlayer.pause();
        return;
      } else if (_isFullSurahPlaying && !_isPlaying) {
        await _audioPlayer.play();
        return;
      }

      await _stopAudio();

      setState(() {
        _isFullSurahPlaying = true;
        _isPlaying = true;
        _activeVerseIndex = 0;
      });

      final playlist = ConcatenatingAudioSource(
        children: _surahs[_activeSurahIndex].verses
            .map(
              (v) => AudioSource.uri(
                Uri.parse(v.audioUrl),
                headers: {
                  'User-Agent':
                      'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
                },
              ),
            )
            .toList(),
      );

      await _audioPlayer.setAudioSource(playlist);
      await _audioPlayer.play();
    } catch (e) {
      debugPrint("Error playing full Surah: $e");
      _stopAudio();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF8F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: widget.themeColor,
            size: 20.sp,
          ),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "The 3 Quls",
          style: GoogleFonts.playfairDisplay(
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.titleColor,
          ),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: widget.themeColor,
          labelColor: widget.themeColor,
          unselectedLabelColor: Colors.grey,
          labelStyle: GoogleFonts.inter(
            fontSize: 13.sp,
            fontWeight: FontWeight.bold,
          ),
          tabs: const [
            Tab(text: "Al-Ikhlas"),
            Tab(text: "Al-Falaq"),
            Tab(text: "An-Nas"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _surahs.map((surah) => _buildSurahView(surah)).toList(),
      ),
    );
  }

  Widget _buildSurahView(SurahModel surah) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Card with Arabic Name and Description
          _buildSurahHeaderCard(surah),
          SizedBox(height: 15.h),

          // Benefits Accordion
          _buildBenefitsCard(surah),
          SizedBox(height: 20.h),

          // Full Play Control Bar
          _buildPlaybackControlBar(surah),
          SizedBox(height: 20.h),

          // Verses Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "VERSES",
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.bodyColor.withValues(alpha: 0.8),
                  letterSpacing: 1.2,
                ),
              ),
              Text(
                "${surah.verses.length} Verses",
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  color: AppColors.bodyColor.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),

          // List of Verses
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: surah.verses.length,
            itemBuilder: (context, index) {
              final verse = surah.verses[index];
              final isVerseActive = _activeVerseIndex == index;
              return _buildVerseCard(verse, index, isVerseActive);
            },
          ),
          SizedBox(height: 30.h),
        ],
      ),
    );
  }

  Widget _buildSurahHeaderCard(SurahModel surah) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: widget.themeColor.withValues(alpha: 0.12),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: widget.themeColor.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            surah.arabicName,
            style: GoogleFonts.amiri(
              fontSize: 34.sp,
              fontWeight: FontWeight.bold,
              color: widget.themeColor,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            surah.name,
            style: GoogleFonts.playfairDisplay(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.titleColor,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            surah.description,
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              color: AppColors.bodyColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitsCard(SurahModel surah) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDFB).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: const Color(0xFF26A69A).withValues(alpha: 0.15),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline_rounded,
            color: const Color(0xFF26A69A),
            size: 20.sp,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Benefits & Virtue",
                  style: GoogleFonts.inter(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0F766E),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  surah.benefits,
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    color: AppColors.bodyColor,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaybackControlBar(SurahModel surah) {
    final isPlayingFull = _isFullSurahPlaying;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: widget.themeColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: widget.themeColor.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: _playFullSurah,
            child: Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: widget.themeColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                isPlayingFull && _isPlaying
                    ? Icons.pause_rounded
                    : Icons.play_arrow_rounded,
                color: Colors.white,
                size: 24.sp,
              ),
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isPlayingFull && _isPlaying
                      ? "Playing Full Surah..."
                      : "Listen to Full Recitation",
                  style: GoogleFonts.inter(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.titleColor,
                  ),
                ),
                Text(
                  "Reciter: Mishary Rashid Alafasy",
                  style: GoogleFonts.inter(
                    fontSize: 11.sp,
                    color: AppColors.bodyColor.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
          if (isPlayingFull)
            IconButton(
              icon: Icon(
                Icons.stop_circle_rounded,
                color: Colors.redAccent,
                size: 24.sp,
              ),
              onPressed: _stopAudio,
            ),
        ],
      ),
    );
  }

  Widget _buildVerseCard(VerseModel verse, int index, bool isActive) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      width: double.infinity,
      decoration: BoxDecoration(
        color: isActive
            ? widget.themeColor.withValues(alpha: 0.03)
            : Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: isActive
              ? widget.themeColor.withValues(alpha: 0.5)
              : Colors.black.withValues(alpha: 0.04),
          width: isActive ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Verse Header: Number and Audio Control
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: isActive
                        ? widget.themeColor.withValues(alpha: 0.1)
                        : const Color(0xFFF3F3F5),
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                  child: Text(
                    "Verse ${verse.number}",
                    style: GoogleFonts.inter(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.bold,
                      color: isActive ? widget.themeColor : AppColors.bodyColor,
                    ),
                  ),
                ),
                // Verse-specific Play Button
                GestureDetector(
                  onTap: () => _playVerse(verse.audioUrl, index),
                  child: Container(
                    padding: EdgeInsets.all(6.w),
                    decoration: BoxDecoration(
                      color:
                          isActive &&
                              _currentlyPlayingUrl == verse.audioUrl &&
                              _isPlaying
                          ? widget.themeColor.withValues(alpha: 0.1)
                          : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _currentlyPlayingUrl == verse.audioUrl && _isPlaying
                          ? Icons.pause_circle_filled_rounded
                          : Icons.play_circle_fill_rounded,
                      color: widget.themeColor,
                      size: 28.sp,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),

            // Arabic Text
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                verse.arabic,
                textDirection: TextDirection.rtl,
                style: GoogleFonts.amiri(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.titleColor,
                  height: 1.8,
                ),
              ),
            ),
            SizedBox(height: 12.h),

            // Transliteration
            Text(
              verse.transliteration,
              style: GoogleFonts.inter(
                fontSize: 12.sp,
                color: widget.themeColor,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.italic,
              ),
            ),
            SizedBox(height: 6.h),

            // English Translation
            Text(
              verse.english,
              style: GoogleFonts.inter(
                fontSize: 12.sp,
                color: AppColors.bodyColor,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
