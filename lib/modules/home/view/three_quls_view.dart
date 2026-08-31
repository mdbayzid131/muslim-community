import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:muslim_community/config/themes/app_colors.dart';
import 'package:muslim_community/core/widgets/custom_app_bar.dart';

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

class ThreeQulsView extends StatefulWidget {
  final Color? themeColor;

  const ThreeQulsView({super.key, this.themeColor});

  @override
  State<ThreeQulsView> createState() => _ThreeQulsViewState();
}

class _ThreeQulsViewState extends State<ThreeQulsView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final AudioPlayer _audioPlayer = AudioPlayer();

  int? _activeVerseIndex;
  bool _isPlaying = false;
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
          "The Prophet ﷺ used to seek refuge against evil eye and witchcraft by reciting Al-Mu'awwidhatayn (Surah Al-Falaq and Surah An-Nas). (Sahih Al-Bukhari)",
      verses: [
        VerseModel(
          number: 1,
          arabic: "قُلْ أَعُوذُ بِرَبِّ الْفَلَقِ",
          transliteration: "Qul a'ūdhu bi-rabbi l-falaq",
          english: "Say, \"I seek refuge in the Lord of daybreak\"",
          audioUrl: "https://verses.quran.foundation/Alafasy/mp3/113001.mp3",
        ),
        VerseModel(
          number: 2,
          arabic: "مِن شَرِّ مَا خَلَقَ",
          transliteration: "Min sharri mā khalaq",
          english: "\"From the evil of that which He created\"",
          audioUrl: "https://verses.quran.foundation/Alafasy/mp3/113002.mp3",
        ),
        VerseModel(
          number: 3,
          arabic: "وَمِن شَرِّ غَاسِقٍ إِذَا وَقَبَ",
          transliteration: "Wa-min sharri ghāsiqin idhā waqab",
          english: "\"And from the evil of darkness when it settles\"",
          audioUrl: "https://verses.quran.foundation/Alafasy/mp3/113003.mp3",
        ),
        VerseModel(
          number: 4,
          arabic: "وَمِن شَرِّ النَّفَّاثَاتِ فِي الْعُقَدِ",
          transliteration: "Wa-min sharri n-naffāthāti fī l-'uqad",
          english: "\"And from the evil of the blowers in knots\"",
          audioUrl: "https://verses.quran.foundation/Alafasy/mp3/113004.mp3",
        ),
        VerseModel(
          number: 5,
          arabic: "وَمِن شَرِّ حَاسِدٍ إِذَا حَسَدَ",
          transliteration: "Wa-min sharri ḥāsidin idhā ḥasad",
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
          "Recite Surah Al-Ikhlas, Surah Al-Falaq, and Surah An-Nas three times in the morning and evening, and they will suffice you against everything. (Sunan Abu Dawood)",
      verses: [
        VerseModel(
          number: 1,
          arabic: "قُلْ أَعُوذُ بِرَبِّ النَّاسِ",
          transliteration: "Qul a'ūdhu bi-rabbi n-nās",
          english: "Say, \"I seek refuge in the Lord of mankind,\"",
          audioUrl: "https://verses.quran.foundation/Alafasy/mp3/114001.mp3",
        ),
        VerseModel(
          number: 2,
          arabic: "مَلِكِ النَّاسِ",
          transliteration: "Maliki n-nās",
          english: "\"The Sovereign of mankind,\"",
          audioUrl: "https://verses.quran.foundation/Alafasy/mp3/114002.mp3",
        ),
        VerseModel(
          number: 3,
          arabic: "إِلَٰهِ النَّاسِ",
          transliteration: "Ilāhi n-nās",
          english: "\"The God of mankind,\"",
          audioUrl: "https://verses.quran.foundation/Alafasy/mp3/114003.mp3",
        ),
        VerseModel(
          number: 4,
          arabic: "مِن شَرِّ الْوَسْوَاسِ الْخَنَّاسِ",
          transliteration: "Min sharri l-waswāsi l-khannās",
          english: "\"From the evil of the retreating whisperer -\"",
          audioUrl: "https://verses.quran.foundation/Alafasy/mp3/114004.mp3",
        ),
        VerseModel(
          number: 5,
          arabic: "الَّذِي يُوَسْوِسُ فِي صُدُورِ النَّاسِ",
          transliteration: "Alladhī yuwaswisu fī ṣudūri n-nās",
          english: "\"Who whispers [evil] into the breasts of mankind -\"",
          audioUrl: "https://verses.quran.foundation/Alafasy/mp3/114005.mp3",
        ),
        VerseModel(
          number: 6,
          arabic: "مِنَ الْجِنَّةِ وَالنَّاسِ",
          transliteration: "Mina l-jinnati wa-n-nās",
          english: "\"From among the jinn and mankind.\"",
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
      }
    });

    _audioPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        setState(() {
          _isPlaying = false;
          _activeVerseIndex = null;
          _currentlyPlayingUrl = '';
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

  Future<void> _playVerse(int verseIndex, String url) async {
    try {
      if (_isPlaying && _currentlyPlayingUrl == url) {
        await _audioPlayer.pause();
        setState(() {
          _isPlaying = false;
        });
        return;
      }

      setState(() {
        _activeVerseIndex = verseIndex;
        _currentlyPlayingUrl = url;
        _isPlaying = true;
      });

      await _audioPlayer.setUrl(url);
      await _audioPlayer.play();
    } catch (e) {
      setState(() {
        _isPlaying = false;
        _activeVerseIndex = null;
      });
    }
  }

  Future<void> _stopAudio() async {
    await _audioPlayer.stop();
    setState(() {
      _isPlaying = false;
      _activeVerseIndex = null;
      _currentlyPlayingUrl = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final activeColor = widget.themeColor ?? AppColors.maleColor;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppBar(
        title: "The Three Quls",
        actions: [
          if (_isPlaying)
            IconButton(
              icon: const Icon(Icons.stop_circle_outlined, color: Colors.red),
              onPressed: _stopAudio,
            ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              indicatorColor: activeColor,
              labelColor: activeColor,
              unselectedLabelColor: AppColors.bodyColor,
              labelStyle: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
              tabs: const [
                Tab(text: "Al-Ikhlas"),
                Tab(text: "Al-Falaq"),
                Tab(text: "An-Nas"),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: _surahs
                  .map((surah) => _buildSurahContent(surah, activeColor))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSurahContent(SurahModel surah, Color activeColor) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Card
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(18.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: activeColor.withValues(alpha: 0.2)),
            ),
            child: Column(
              children: [
                Text(
                  surah.arabicName,
                  style: GoogleFonts.amiri(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,
                    color: activeColor,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  surah.name,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 18.sp,
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
                SizedBox(height: 12.h),
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: activeColor.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    surah.benefits,
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      fontStyle: FontStyle.italic,
                      color: activeColor,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),

          // Verses
          ...surah.verses.asMap().entries.map((entry) {
            final idx = entry.key;
            final verse = entry.value;
            final isVersePlaying = _isPlaying && _activeVerseIndex == idx;

            return Container(
              margin: EdgeInsets.only(bottom: 14.h),
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: isVersePlaying
                    ? activeColor.withValues(alpha: 0.08)
                    : Colors.white,
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(
                  color: isVersePlaying
                      ? activeColor
                      : AppColors.borderGrey,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 28.w,
                        height: 28.w,
                        decoration: BoxDecoration(
                          color: activeColor.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            "${verse.number}",
                            style: GoogleFonts.inter(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                              color: activeColor,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          isVersePlaying
                              ? Icons.pause_circle_filled
                              : Icons.play_circle_fill,
                          color: activeColor,
                          size: 28.sp,
                        ),
                        onPressed: () => _playVerse(idx, verse.audioUrl),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    verse.arabic,
                    textAlign: TextAlign.right,
                    style: GoogleFonts.amiri(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.titleColor,
                      height: 1.8,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    verse.transliteration,
                    style: GoogleFonts.inter(
                      fontSize: 13.sp,
                      fontStyle: FontStyle.italic,
                      color: AppColors.goldColor,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    verse.english,
                    style: GoogleFonts.inter(
                      fontSize: 13.sp,
                      color: AppColors.bodyColor,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
