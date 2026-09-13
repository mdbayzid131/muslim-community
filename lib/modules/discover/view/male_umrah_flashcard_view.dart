import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class MaleUmrahFlashcardView extends StatefulWidget {
  final String title;

  const MaleUmrahFlashcardView({super.key, required this.title});

  @override
  State<MaleUmrahFlashcardView> createState() => _MaleUmrahFlashcardViewState();
}

class _MaleUmrahFlashcardViewState extends State<MaleUmrahFlashcardView> {
  static const Color themeColor = Color(0xFF3A5C78); // Blue deep
  static const Color blueLight = Color(0xFF5A7C98);
  static const Color bluePale = Color(0xFFEBF2F7);
  static const Color accentGold = Color(0xFFA67C2E);
  static const Color textDark = Color(0xFF2C2422);
  static const Color cardBgLight = Color(0xFFFEFAF4);
  static const Color textBody = Color(0xFF5C4A3A);
  static const Color textMuted = Color(0xFF9B8070);

  int _currentIndex = 0;
  final List<int> _history = [];

  late List<UmrahFlashcardModel> _cards;

  @override
  void initState() {
    super.initState();

    _cards = [
      // 1. COVER CARD
      UmrahFlashcardModel(
        cardType: UmrahCardType.cover,
        coverTitle: "A Guide to Umrah",
        coverSubtitle:
            "A step by step guide for brothers performing Umrah for the first time",
        coverArabic: "لَبَّيْكَ اللَّهُمَّ لَبَّيْكَ",
        coverTransliteration:
            "Labbayk Allahumma Labbayk Here I am O Allah, Here I am",
        coverEmoji: "🕋",
      ),

      // 2. KEYWORDS / WORDS YOU WILL HEAR
      UmrahFlashcardModel(
        cardType: UmrahCardType.info,
        infoTitle: "Words You Will Hear Simply Explained",
        infoItems: [
          UmrahInfoItem(
            emoji: "🤲",
            title: "Ihram",
            text:
                "A special state of purity you enter before Umrah begins. For brothers this means wearing two white sheets of unstitched cloth. Think of it as a sacred uniform that makes everyone equal before Allah.",
          ),
          UmrahInfoItem(
            emoji: "📍",
            title: "Miqat",
            text:
                "A boundary point around Makkah. Before you cross this line you must be in Ihram and have made your intention. Think of it as the starting gate of Umrah.",
          ),
          UmrahInfoItem(
            emoji: "🗣️",
            title: "Talbiyah",
            text:
                "A special prayer you repeat out loud during Umrah. \"Here I am O Allah, here I am.\" It is your way of answering Allah's invitation to visit His house.",
          ),
          UmrahInfoItem(
            emoji: "🕋",
            title: "Tawaf",
            text:
                "Walking in circles around the Kaaba 7 times. The Kaaba is the black cube in the centre of the Grand Mosque in Makkah the holiest place on earth.",
          ),
          UmrahInfoItem(
            emoji: "🚶",
            title: "Sa'i",
            text:
                "Walking back and forth 7 times between two small hills called Safa and Marwa. This remembers Hajar (AS) who searched for water for her baby son.",
          ),
          UmrahInfoItem(
            emoji: "✂️",
            title: "Halq or Taqsir",
            text:
                "Shaving the head completely (Halq) or cutting the hair short (Taqsir) at the end of Umrah. Shaving is better for brothers. This marks the end of Umrah.",
          ),
          UmrahInfoItem(
            emoji: "💧",
            title: "Zamzam",
            text:
                "A blessed spring of water inside the Grand Mosque in Makkah. It has been flowing for thousands of years. Drink as much as you like and make Dua as you drink.",
          ),
        ],
        infoFooterText:
            "No question is too small. Every revert starts from the beginning. 🤍",
      ),

      // 3. WHAT IS UMRAH?
      UmrahFlashcardModel(
        cardType: UmrahCardType.info,
        infoTitle: "What is Umrah?",
        infoItems: [
          UmrahInfoItem(
            emoji: "🕋",
            title: "The lesser pilgrimage",
            text:
                "Umrah is a voluntary pilgrimage to Makkah that can be performed at any time of year. Unlike Hajj it is not obligatory but carries enormous reward.",
          ),
          UmrahInfoItem(
            emoji: "🌙",
            title: "Why do Muslims perform Umrah?",
            text:
                "To draw closer to Allah, seek forgiveness, and experience the spiritual journey to the holiest place on earth. Standing where millions of Muslims have stood before you.",
          ),
          UmrahInfoItem(
            emoji: "🤍",
            title: "For reverts",
            text:
                "Your first Umrah as a revert is one of the most profound experiences of your life. You are not alone. Allah invited you here. Every step is an act of worship.",
          ),
          UmrahInfoItem(
            emoji: "✅",
            title: "The 4 steps of Umrah",
            text:
                "Ihram then Tawaf then Sa'i then Halq or Taqsir (shaving or cutting hair). Beautiful in its simplicity.",
          ),
        ],
        infoFooterText: "No question is too small. You are not alone. 🤍",
        infoFooterLogo: "SYA Brothers",
      ),

      // 4. STEP 1: ENTER IHRAM
      UmrahFlashcardModel(
        cardType: UmrahCardType.step,
        stepNumber: 1,
        stepLabel: "Step One",
        stepTitle: "Enter Ihram",
        stepEmoji: "🤍",
        stepInstruction:
            "Before reaching the Miqat perform Ghusl, trim your nails and put on your Ihram garments. For brothers Ihram is two white sheets of unstitched cloth. One wraps around your waist and the other over your shoulder. Your head must remain uncovered.",
        duaLabel: "Intention say in your heart then aloud",
        duaArabic: "لَبَّيْكَ اللَّهُمَّ عُمْرَةً",
        duaTransliteration: "Labbayk Allahumma Umratan",
        duaTranslation: "\"Here I am O Allah, for Umrah\"",
        tipEmoji: "🕌",
        tipText:
            "Once you enter Ihram certain things become prohibited. No cutting hair or nails, no perfume, no arguing or bad language. Stay in a state of worship and calm.",
        footerProgress: "Step 1 of 4",
      ),

      // 5. TALBIYAH
      UmrahFlashcardModel(
        cardType: UmrahCardType.talbiyah,
        infoTitle: "The Talbiyah Recite Continuously",
        duaArabic:
            "لَبَّيْكَ اللَّهُمَّ لَبَّيْكَ، لَبَّيْكَ لَا شَرِيكَ لَكَ لَبَّيْكَ، إِنَّ الْحَمْدَ وَالنِّعْمَةَ لَكَ وَالْمُلْكَ، لَا شَرِيكَ لَكَ",
        duaTransliteration:
            "Labbayk Allahumma labbayk, labbayka la sharika laka labbayk, innal hamda wan ni'mata laka wal mulk, la sharika lak",
        duaTranslation:
            "\"Here I am O Allah, here I am. Here I am, You have no partner, here I am. Verily all praise, grace and sovereignty belong to You. You have no partner.\"",
        infoItems: [
          UmrahInfoItem(
            emoji: "🗣️",
            title: "When to recite",
            text:
                "Recite the Talbiyah continuously from the moment you enter Ihram until you begin Tawaf. Brothers recite loudly and proudly.",
          ),
          UmrahInfoItem(
            emoji: "💫",
            title: "What it means",
            text:
                "You are answering Allah's call to come to His house. These are among the most powerful words you will ever say. Let them fill your heart completely.",
          ),
        ],
        infoFooterText: "Labbayk Here I am, O Allah. 🤍",
      ),

      // 6. STEP 2: TAWAF
      UmrahFlashcardModel(
        cardType: UmrahCardType.step,
        stepNumber: 2,
        stepLabel: "Step Two",
        stepTitle: "Tawaf Circle the Kaaba",
        stepEmoji: "🕋",
        stepInstruction:
            "Circle the Kaaba 7 times in an anticlockwise direction starting and ending at the Black Stone. Keep the Kaaba on your left side. Each circuit is one Shawt. You must be in Wudu for Tawaf. For the first three circuits brothers walk briskly. For the remaining four walk normally.",
        duaLabel: "Say at the start of each circuit",
        duaArabic: "بِسْمِ اللَّهِ وَاللَّهُ أَكْبَرُ",
        duaTransliteration: "Bismillahi Allahu Akbar",
        duaTranslation: "\"In the name of Allah, Allah is the Greatest\"",
        tipEmoji: "🕌",
        tipText:
            "You do not need to memorise specific Duas for each circuit. Make your own Duas in any language. Pour your heart out to Allah. This is your moment with Him.",
        footerProgress: "Step 2 of 4",
      ),

      // 7. TAWAF TIPS
      UmrahFlashcardModel(
        cardType: UmrahCardType.info,
        infoTitle: "Tawaf Things to Know",
        infoItems: [
          UmrahInfoItem(
            emoji: "⬛",
            title: "The Black Stone",
            text:
                "If possible kiss or touch the Black Stone at the start. If it is too crowded simply point towards it and say Allahu Akbar. This is perfectly valid and accepted.",
          ),
          UmrahInfoItem(
            emoji: "🟩",
            title: "The Green Light",
            text:
                "Look for the green light on the wall. This marks where you start and end each circuit at the Black Stone level.",
          ),
          UmrahInfoItem(
            emoji: "🤲",
            title: "Two Rakats after Tawaf",
            text:
                "After completing 7 circuits pray 2 Rakats near Maqam Ibrahim. Recite Surah Al-Kafirun in the first Rakat and Surah Al-Ikhlas in the second.",
          ),
          UmrahInfoItem(
            emoji: "💧",
            title: "Drink Zamzam water",
            text:
                "After the 2 Rakats drink Zamzam water and make a sincere Dua. The Prophet said Zamzam is for whatever it is drunk for so ask for everything.",
          ),
        ],
        infoFooterText: "Every step around the Kaaba is an act of worship. 🤍",
      ),

      // 8. STEP 3: SA'I
      UmrahFlashcardModel(
        cardType: UmrahCardType.step,
        stepNumber: 3,
        stepLabel: "Step Three",
        stepTitle: "Sa'i Safa and Marwa",
        stepEmoji: "🚶",
        stepInstruction:
            "Walk 7 times between the hills of Safa and Marwa. Start at Safa and end at Marwa. This remembers Hajar (AS) who ran between these hills searching for water for her baby son Ismail. Brothers run briskly between the green lights in the middle section.",
        duaLabel: "Say at Safa and Marwa",
        duaArabic: "إِنَّ الصَّفَا وَالْمَرْوَةَ مِنْ شَعَائِرِ اللَّهِ",
        duaTransliteration: "Innas-Safa wal-Marwata min sha'a'irillah",
        duaTranslation: "\"Indeed Safa and Marwa are among the signs of Allah\"",
        tipEmoji: "🕌",
        tipText:
            "Between the green lights brothers walk briskly as a Sunnah. Outside of the green lights walk at a normal pace and focus on your Duas.",
        footerProgress: "Step 3 of 4",
      ),

      // 9. STEP 4: HALQ OR TAQSIR
      UmrahFlashcardModel(
        cardType: UmrahCardType.step,
        stepNumber: 4,
        stepLabel: "Step Four",
        stepTitle: "Halq or Taqsir",
        stepEmoji: "✂️",
        stepInstruction:
            "After completing Sa'i shave your head completely (Halq) or cut your hair short (Taqsir). Shaving the head is better for brothers as it carries more reward. This marks the completion of your Umrah and releases you from the state of Ihram.",
        duaLabel: "Dua after completing Umrah",
        duaArabic: "اللَّهُمَّ إِنَّكَ عَفُوٌّ تُحِبُّ الْعَفْوَ فَاعْفُ عَنِّي",
        duaTransliteration: "Allahumma innaka 'afuwwun tuhibbul 'afwa fa'fu 'anni",
        duaTranslation:
            "\"O Allah You are Most Forgiving and You love forgiveness so forgive me\"",
        tipEmoji: "🕌",
        tipText:
            "Your Umrah is now complete. You are released from Ihram. All prohibitions are lifted. Alhamdulillah you did it. 🤍",
        footerProgress: "Step 4 of 4",
      ),

      // 10. WHAT TO PACK
      UmrahFlashcardModel(
        cardType: UmrahCardType.info,
        infoTitle: "What to Pack for Umrah",
        infoItems: [
          UmrahInfoItem(
            emoji: "🤍",
            title: "Ihram garments",
            text:
                "Two white unstitched sheets of cloth. Pack a spare set in case one gets dirty or damaged. They are widely available in Makkah too.",
          ),
          UmrahInfoItem(
            emoji: "👟",
            title: "Comfortable sandals",
            text:
                "You will walk a lot. Wear open sandals that are easy to slip off for prayer. Make sure they are very comfortable as you will be on your feet for hours.",
          ),
          UmrahInfoItem(
            emoji: "📿",
            title: "Tasbih beads",
            text:
                "For counting Tawaf circuits and making Dhikr throughout your journey.",
          ),
          UmrahInfoItem(
            emoji: "📖",
            title: "Small Dua book",
            text:
                "A pocket sized Dua guide so you always have something to recite. The Hisnul Muslim app on your phone is also excellent.",
          ),
          UmrahInfoItem(
            emoji: "💧",
            title: "Stay hydrated",
            text:
                "Makkah is very hot. Drink plenty of Zamzam water and stay hydrated throughout your Umrah.",
          ),
        ],
        infoFooterText: "Prepare your body. Prepare your heart. 🤍 SYA Brothers",
      ),

      // 11. TIPS FOR REVERTS
      UmrahFlashcardModel(
        cardType: UmrahCardType.info,
        infoTitle: "Tips for Reverts on First Umrah",
        infoItems: [
          UmrahInfoItem(
            emoji: "🤍",
            title: "You belong here",
            text:
                "You may feel like everyone else knows what they are doing and you do not. You belong here just as much as anyone. Allah called you here personally.",
          ),
          UmrahInfoItem(
            emoji: "😭",
            title: "It is okay to cry",
            text:
                "Most people cry the first time they see the Kaaba. It is completely natural and beautiful. Let yourself feel it fully.",
          ),
          UmrahInfoItem(
            emoji: "🗣️",
            title: "Ask for help",
            text:
                "There are always guides and volunteers in the Haram. Never be embarrassed to ask for help. People are there specifically to assist pilgrims like you.",
          ),
          UmrahInfoItem(
            emoji: "🌙",
            title: "Make the most of every moment",
            text:
                "Duas made in Makkah are especially powerful. Bring a list of everything you want to ask Allah for. This is your moment with Him alone.",
          ),
        ],
        infoFooterText:
            "\"Honouring those who stood alone so no revert ever has to.\" 🤍",
        infoFooterLogo: "SYA Brothers",
      ),
    ];
  }

  void _onSwipe(int newIndex) {
    setState(() {
      if (newIndex > _currentIndex) {
        _history.add(_currentIndex);
      } else if (_history.isNotEmpty && newIndex < _currentIndex) {
        _history.removeLast();
      }
      _currentIndex = newIndex;
    });
  }

  void _undo() {
    if (_history.isNotEmpty) {
      setState(() {
        _currentIndex = _history.removeLast();
      });
    }
  }

  void _reset() {
    setState(() {
      _currentIndex = 0;
      _history.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isCompleted = _currentIndex >= _cards.length;

    return Scaffold(
      backgroundColor: const Color(0xFFE0E8F0),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: themeColor),
          onPressed: () => Get.back(),
        ),
        title: Text(
          widget.title,
          style: GoogleFonts.cinzel(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: themeColor,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 4.h),
            Text(
              isCompleted
                  ? "Mabroor! Umrah Guide Finished"
                  : _cards[_currentIndex].cardType == UmrahCardType.cover
                      ? "Interactive Umrah Guide"
                      : _cards[_currentIndex].cardType == UmrahCardType.step
                          ? "Step ${_cards[_currentIndex].stepNumber} of 4"
                          : "Guide Overview",
              style: GoogleFonts.inter(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: themeColor,
                letterSpacing: 1.1,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              isCompleted
                  ? "May Allah accept your Umrah."
                  : "Swipe Left for next card, Swipe Right to go back.",
              style: GoogleFonts.inter(
                fontSize: 11.sp,
                color: textMuted,
              ),
            ),

            // Card Deck Area
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
                child: Center(
                  child: isCompleted
                      ? _buildCompletionCard()
                      : UmrahCardDeck(
                          cards: _cards,
                          currentIndex: _currentIndex,
                          onSwipe: _onSwipe,
                          cardBuilder: (card) {
                            switch (card.cardType) {
                              case UmrahCardType.cover:
                                return _buildCoverCard(card);
                              case UmrahCardType.step:
                                return _buildStepCard(card);
                              case UmrahCardType.talbiyah:
                                return _buildTalbiyahCard(card);
                              case UmrahCardType.info:
                                return _buildInfoCard(card);
                            }
                          },
                        ),
                ),
              ),
            ),

            // Controls Bottom Bar
            Padding(
              padding: EdgeInsets.only(bottom: 20.h, left: 30.w, right: 30.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Rewind / Undo Button
                  GestureDetector(
                    onTap: _history.isNotEmpty ? _undo : null,
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 200),
                      opacity: _history.isNotEmpty ? 1.0 : 0.2,
                      child: Container(
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: themeColor.withValues(alpha: 0.12),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                          border: Border.all(
                            color: themeColor.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Icon(
                          Icons.replay_rounded,
                          color: themeColor,
                          size: 20.sp,
                        ),
                      ),
                    ),
                  ),

                  // Progress Counter
                  Text(
                    isCompleted
                        ? "Completed"
                        : "Card ${_currentIndex + 1} of ${_cards.length}",
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: themeColor,
                    ),
                  ),

                  // Reset Button
                  GestureDetector(
                    onTap: _currentIndex > 0 ? _reset : null,
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 200),
                      opacity: _currentIndex > 0 ? 1.0 : 0.2,
                      child: Container(
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: themeColor.withValues(alpha: 0.12),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                          border: Border.all(
                            color: themeColor.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Icon(
                          Icons.refresh_rounded,
                          color: themeColor,
                          size: 20.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // COVER CARD
  Widget _buildCoverCard(UmrahFlashcardModel card) {
    return Container(
      width: 320.w,
      height: 520.h,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF3A5C78), Color(0xFF5A7C98), Color(0xFF7A9DC0)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3A5C78).withValues(alpha: 0.25),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 25.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Header SYA Brothers
            Column(
              children: [
                Container(
                  width: 60.w,
                  height: 2.h,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.white.withValues(alpha: 0.5),
                        Colors.transparent
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  "SYA",
                  style: GoogleFonts.cinzel(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 2.0,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  "BROTHERS",
                  style: GoogleFonts.inter(
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withValues(alpha: 0.8),
                    letterSpacing: 3.0,
                  ),
                ),
              ],
            ),

            // Middle Section
            Column(
              children: [
                Text(
                  card.coverEmoji ?? "🕋",
                  style: TextStyle(fontSize: 48.sp),
                ),
                SizedBox(height: 14.h),
                Text(
                  card.coverTitle ?? "A Guide to Umrah",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cinzel(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.8,
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  card.coverSubtitle ?? "",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 13.sp,
                    fontStyle: FontStyle.italic,
                    color: Colors.white.withValues(alpha: 0.85),
                    height: 1.4,
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  card.coverArabic ?? "لَبَّيْكَ اللَّهُمَّ لَبَّيْكَ",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.amiri(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white.withValues(alpha: 0.95),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  card.coverTransliteration ?? "",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 11.sp,
                    fontStyle: FontStyle.italic,
                    color: Colors.white.withValues(alpha: 0.75),
                  ),
                ),
              ],
            ),

            // Bottom Prompt
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.swipe_left_rounded,
                      color: Colors.white.withValues(alpha: 0.6),
                      size: 16.sp,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      "SWIPE LEFT TO START",
                      style: GoogleFonts.inter(
                        fontSize: 9.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white.withValues(alpha: 0.85),
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Container(
                  width: 60.w,
                  height: 2.h,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.white.withValues(alpha: 0.5),
                        Colors.transparent
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // STEP CARD
  Widget _buildStepCard(UmrahFlashcardModel card) {
    return Container(
      width: 320.w,
      height: 520.h,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: cardBgLight,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3A5C78).withValues(alpha: 0.12),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Gradient Accent Top Bar
          Container(
            height: 8.h,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF3A5C78), Color(0xFF5A7C98), Color(0xFF7A9DC0)],
              ),
            ),
          ),

          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
              child: Column(
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "SYA",
                        style: GoogleFonts.cinzel(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: accentGold,
                          letterSpacing: 1.0,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 3.h,
                        ),
                        decoration: BoxDecoration(
                          color: bluePale,
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(
                            color: const Color(0xFF5A7C98).withValues(alpha: 0.25),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Brothers",
                              style: GoogleFonts.inter(
                                fontSize: 9.sp,
                                fontWeight: FontWeight.w600,
                                color: themeColor,
                              ),
                            ),
                            SizedBox(width: 3.w),
                            Text("🕌", style: TextStyle(fontSize: 9.sp)),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 10.h),

                  // Scrollable Content to handle variable height smoothly
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Step Hero
                          Row(
                            children: [
                              Container(
                                width: 40.w,
                                height: 40.w,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFF3A5C78), Color(0xFF5A7C98)],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF5A7C98)
                                          .withValues(alpha: 0.35),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  "${card.stepNumber}",
                                  style: GoogleFonts.cinzel(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      card.stepLabel?.toUpperCase() ?? "",
                                      style: GoogleFonts.inter(
                                        fontSize: 9.sp,
                                        fontWeight: FontWeight.w700,
                                        color: blueLight,
                                        letterSpacing: 1.0,
                                      ),
                                    ),
                                    Text(
                                      card.stepTitle ?? "",
                                      style: GoogleFonts.cinzel(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.bold,
                                        color: textDark,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (card.stepEmoji != null)
                                Text(
                                  card.stepEmoji!,
                                  style: TextStyle(fontSize: 26.sp),
                                ),
                            ],
                          ),

                          SizedBox(height: 10.h),
                          Divider(
                            color: const Color(0xFF5A7C98).withValues(alpha: 0.15),
                            thickness: 1,
                          ),
                          SizedBox(height: 8.h),

                          // Instruction
                          Text(
                            card.stepInstruction ?? "",
                            style: GoogleFonts.dmSans(
                              fontSize: 12.sp,
                              color: textBody,
                              height: 1.5,
                            ),
                          ),

                          SizedBox(height: 12.h),

                          // Dua Block
                          if (card.duaArabic != null) ...[
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(12.w),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    const Color(0xFF5A7C98).withValues(alpha: 0.08),
                                    const Color(0xFFC9943A).withValues(alpha: 0.06),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(10.r),
                                border: Border.all(
                                  color: const Color(0xFF5A7C98)
                                      .withValues(alpha: 0.2),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (card.duaLabel != null)
                                    Text(
                                      card.duaLabel!.toUpperCase(),
                                      style: GoogleFonts.inter(
                                        fontSize: 8.sp,
                                        fontWeight: FontWeight.bold,
                                        color: blueLight,
                                        letterSpacing: 1.0,
                                      ),
                                    ),
                                  SizedBox(height: 6.h),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      card.duaArabic!,
                                      textAlign: TextAlign.right,
                                      style: GoogleFonts.amiri(
                                        fontSize: 16.sp,
                                        color: textDark,
                                        height: 1.7,
                                      ),
                                    ),
                                  ),
                                  if (card.duaTransliteration != null) ...[
                                    SizedBox(height: 4.h),
                                    Text(
                                      card.duaTransliteration!,
                                      style: GoogleFonts.playfairDisplay(
                                        fontSize: 11.sp,
                                        fontStyle: FontStyle.italic,
                                        color: accentGold,
                                      ),
                                    ),
                                  ],
                                  if (card.duaTranslation != null) ...[
                                    SizedBox(height: 3.h),
                                    Text(
                                      card.duaTranslation!,
                                      style: GoogleFonts.dmSans(
                                        fontSize: 10.sp,
                                        color: textMuted,
                                        height: 1.4,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            SizedBox(height: 10.h),
                          ],

                          // Tip Block
                          if (card.tipText != null) ...[
                            Container(
                              padding: EdgeInsets.all(10.w),
                              decoration: BoxDecoration(
                                color: const Color(0xFFC9943A)
                                    .withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    card.tipEmoji ?? "🕌",
                                    style: TextStyle(fontSize: 14.sp),
                                  ),
                                  SizedBox(width: 8.w),
                                  Expanded(
                                    child: Text(
                                      card.tipText!,
                                      style: GoogleFonts.dmSans(
                                        fontSize: 10.sp,
                                        color: textMuted,
                                        height: 1.4,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 8.h),

                  // Footer
                  Divider(
                    color: const Color(0xFF5A7C98).withValues(alpha: 0.1),
                    thickness: 1,
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "A Guide to Umrah",
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 10.sp,
                          fontStyle: FontStyle.italic,
                          color: blueLight,
                        ),
                      ),
                      Text(
                        card.footerProgress ?? "",
                        style: GoogleFonts.dmSans(
                          fontSize: 9.sp,
                          color: textMuted,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // TALBIYAH CARD
  Widget _buildTalbiyahCard(UmrahFlashcardModel card) {
    return Container(
      width: 320.w,
      height: 520.h,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFEBF2F7), Color(0xFFFEFAF4)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3A5C78).withValues(alpha: 0.12),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            height: 8.h,
            color: themeColor,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "SYA",
                        style: GoogleFonts.cinzel(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: accentGold,
                          letterSpacing: 1.0,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 3.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(
                            color: const Color(0xFF5A7C98).withValues(alpha: 0.25),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Brothers",
                              style: GoogleFonts.inter(
                                fontSize: 9.sp,
                                fontWeight: FontWeight.w600,
                                color: themeColor,
                              ),
                            ),
                            SizedBox(width: 3.w),
                            Text("🕌", style: TextStyle(fontSize: 9.sp)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    card.infoTitle ?? "",
                    style: GoogleFonts.cinzel(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: themeColor,
                    ),
                  ),
                  SizedBox(height: 10.h),

                  // Scrollable Body
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          // Big Dua Container
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(12.w),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  const Color(0xFF5A7C98).withValues(alpha: 0.08),
                                  const Color(0xFFC9943A).withValues(alpha: 0.06),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(10.r),
                              border: Border.all(
                                color: const Color(0xFF5A7C98)
                                    .withValues(alpha: 0.25),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    card.duaArabic ?? "",
                                    textAlign: TextAlign.right,
                                    style: GoogleFonts.amiri(
                                      fontSize: 16.sp,
                                      color: textDark,
                                      height: 1.8,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 6.h),
                                Text(
                                  card.duaTransliteration ?? "",
                                  style: GoogleFonts.playfairDisplay(
                                    fontSize: 10.sp,
                                    fontStyle: FontStyle.italic,
                                    color: accentGold,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  card.duaTranslation ?? "",
                                  style: GoogleFonts.dmSans(
                                    fontSize: 10.sp,
                                    color: textMuted,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10.h),

                          // Additional items
                          if (card.infoItems != null)
                            ...card.infoItems!.map((item) => _buildInfoItemRow(item)),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 8.h),
                  Center(
                    child: Text(
                      card.infoFooterText ?? "Labbayk Here I am, O Allah. 🤍",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 11.sp,
                        fontStyle: FontStyle.italic,
                        color: blueLight,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // INFO CARD (Keywords, What is Umrah, Packing, Revert Tips)
  Widget _buildInfoCard(UmrahFlashcardModel card) {
    return Container(
      width: 320.w,
      height: 520.h,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFEBF2F7), Color(0xFFFEFAF4)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3A5C78).withValues(alpha: 0.12),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            height: 8.h,
            color: themeColor,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "SYA",
                        style: GoogleFonts.cinzel(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: accentGold,
                          letterSpacing: 1.0,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 3.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(
                            color: const Color(0xFF5A7C98).withValues(alpha: 0.25),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Brothers",
                              style: GoogleFonts.inter(
                                fontSize: 9.sp,
                                fontWeight: FontWeight.w600,
                                color: themeColor,
                              ),
                            ),
                            SizedBox(width: 3.w),
                            Text("🕌", style: TextStyle(fontSize: 9.sp)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    card.infoTitle ?? "",
                    style: GoogleFonts.cinzel(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: themeColor,
                    ),
                  ),
                  SizedBox(height: 10.h),

                  // Scrollable Items list (guarantees no overflow)
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          if (card.infoItems != null)
                            ...card.infoItems!.map((item) => _buildInfoItemRow(item)),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 8.h),
                  if (card.infoFooterText != null) ...[
                    Center(
                      child: Text(
                        card.infoFooterText!,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 10.sp,
                          fontStyle: FontStyle.italic,
                          color: blueLight,
                        ),
                      ),
                    ),
                  ],
                  if (card.infoFooterLogo != null) ...[
                    SizedBox(height: 2.h),
                    Center(
                      child: Text(
                        card.infoFooterLogo!,
                        style: GoogleFonts.cinzel(
                          fontSize: 9.sp,
                          fontWeight: FontWeight.bold,
                          color: accentGold,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItemRow(UmrahInfoItem item) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: const Color(0xFF5A7C98).withValues(alpha: 0.15),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF5A7C98).withValues(alpha: 0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(item.emoji, style: TextStyle(fontSize: 16.sp)),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: GoogleFonts.dmSans(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.bold,
                    color: textDark,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  item.text,
                  style: GoogleFonts.dmSans(
                    fontSize: 10.sp,
                    color: textMuted,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // COMPLETION CARD
  Widget _buildCompletionCard() {
    return Container(
      width: 320.w,
      height: 480.h,
      padding: EdgeInsets.all(25.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: themeColor.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: bluePale,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.check_circle_rounded,
                color: themeColor, size: 55.sp),
          ),
          SizedBox(height: 20.h),
          Text(
            "Umrah Mabroor!",
            textAlign: TextAlign.center,
            style: GoogleFonts.cinzel(
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
              color: themeColor,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            "You have completed the full Umrah Flashcard Guide for Brothers. May Allah accept your worship and make your journey easy.",
            textAlign: TextAlign.center,
            style: GoogleFonts.dmSans(
              fontSize: 12.sp,
              color: textBody,
              height: 1.5,
            ),
          ),
          SizedBox(height: 25.h),
          ElevatedButton.icon(
            onPressed: _reset,
            icon: const Icon(Icons.replay_rounded, color: Colors.white),
            label: Text(
              "Review Guide Again",
              style: GoogleFonts.inter(
                fontSize: 13.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: themeColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.r),
              ),
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            ),
          ),
        ],
      ),
    );
  }
}

// -------------------------------------------------------------
// MODELS & DATA TYPES
// -------------------------------------------------------------

enum UmrahCardType { cover, step, talbiyah, info }

class UmrahFlashcardModel {
  final UmrahCardType cardType;
  final String? coverTitle;
  final String? coverSubtitle;
  final String? coverArabic;
  final String? coverTransliteration;
  final String? coverEmoji;

  final int? stepNumber;
  final String? stepLabel;
  final String? stepTitle;
  final String? stepEmoji;
  final String? stepInstruction;
  final String? footerProgress;

  final String? duaLabel;
  final String? duaArabic;
  final String? duaTransliteration;
  final String? duaTranslation;

  final String? tipEmoji;
  final String? tipText;

  final String? infoTitle;
  final List<UmrahInfoItem>? infoItems;
  final String? infoFooterText;
  final String? infoFooterLogo;

  UmrahFlashcardModel({
    required this.cardType,
    this.coverTitle,
    this.coverSubtitle,
    this.coverArabic,
    this.coverTransliteration,
    this.coverEmoji,
    this.stepNumber,
    this.stepLabel,
    this.stepTitle,
    this.stepEmoji,
    this.stepInstruction,
    this.footerProgress,
    this.duaLabel,
    this.duaArabic,
    this.duaTransliteration,
    this.duaTranslation,
    this.tipEmoji,
    this.tipText,
    this.infoTitle,
    this.infoItems,
    this.infoFooterText,
    this.infoFooterLogo,
  });
}

class UmrahInfoItem {
  final String emoji;
  final String title;
  final String text;

  UmrahInfoItem({
    required this.emoji,
    required this.title,
    required this.text,
  });
}

// -------------------------------------------------------------
// INTERACTIVE SWIPE DECK
// -------------------------------------------------------------

class UmrahCardDeck extends StatefulWidget {
  final List<UmrahFlashcardModel> cards;
  final int currentIndex;
  final Function(int) onSwipe;
  final Widget Function(UmrahFlashcardModel) cardBuilder;

  const UmrahCardDeck({
    super.key,
    required this.cards,
    required this.currentIndex,
    required this.onSwipe,
    required this.cardBuilder,
  });

  @override
  State<UmrahCardDeck> createState() => _UmrahCardDeckState();
}

class _UmrahCardDeckState extends State<UmrahCardDeck>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _swipeAnimation;
  Offset _dragOffset = Offset.zero;
  double _angle = 0.0;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.currentIndex >= widget.cards.length) {
      return const SizedBox.shrink();
    }

    final topCard = widget.cards[widget.currentIndex];
    final hasNextCard = widget.currentIndex + 1 < widget.cards.length;
    final nextCard = hasNextCard ? widget.cards[widget.currentIndex + 1] : null;

    final isDraggingLeft = _dragOffset.dx < 0;
    final dragProgress = isDraggingLeft
        ? (_dragOffset.dx.abs() / 150.0).clamp(0.0, 1.0)
        : 0.0;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Next Card (behind)
        if (nextCard != null)
          Positioned(
            top: 15.h * (1.0 - dragProgress),
            left: 0,
            right: 0,
            child: Opacity(
              opacity: 0.7 + (0.3 * dragProgress),
              child: Transform.scale(
                scale: 0.94 + (0.06 * dragProgress),
                alignment: Alignment.center,
                child: IgnorePointer(child: widget.cardBuilder(nextCard)),
              ),
            ),
          ),

        // Top Card (Draggable)
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: _isAnimating
              ? AnimatedBuilder(
                  animation: _swipeAnimation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: _swipeAnimation.value,
                      child: Transform.rotate(
                        angle: (_swipeAnimation.value.dx / 1000.0) *
                            (math.pi / 180) *
                            15,
                        child: widget.cardBuilder(topCard),
                      ),
                    );
                  },
                )
              : GestureDetector(
                  onPanStart: (_) {
                    if (_isAnimating) return;
                    setState(() {
                      _dragOffset = Offset.zero;
                      _angle = 0.0;
                    });
                  },
                  onPanUpdate: (details) {
                    if (_isAnimating) return;
                    setState(() {
                      _dragOffset += details.delta;
                      _angle = (_dragOffset.dx / 1000.0) * (math.pi / 180) * 15;
                    });
                  },
                  onPanEnd: (details) {
                    if (_isAnimating) return;

                    if (_dragOffset.dx < -120) {
                      _animateAndSwipeForward();
                    } else if (_dragOffset.dx > 120) {
                      _animateAndSwipeBackward();
                    } else {
                      _snapBack();
                    }
                  },
                  child: Transform.translate(
                    offset: _dragOffset,
                    child: Transform.rotate(
                      angle: _angle,
                      child: widget.cardBuilder(topCard),
                    ),
                  ),
                ),
        ),
      ],
    );
  }

  void _animateAndSwipeForward() {
    setState(() {
      _isAnimating = true;
    });

    const targetX = -550.0;
    _swipeAnimation = Tween<Offset>(
      begin: _dragOffset,
      end: const Offset(targetX, 0.0),
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.forward().then((_) {
      widget.onSwipe(widget.currentIndex + 1);
      _animationController.reset();
      setState(() {
        _dragOffset = Offset.zero;
        _angle = 0.0;
        _isAnimating = false;
      });
    });
  }

  void _animateAndSwipeBackward() {
    if (widget.currentIndex == 0) {
      _snapBack();
      return;
    }

    widget.onSwipe(widget.currentIndex - 1);

    setState(() {
      _isAnimating = true;
      _dragOffset = const Offset(-550.0, 0.0);
      _angle = -10 * (math.pi / 180);
    });

    _swipeAnimation = Tween<Offset>(
      begin: const Offset(-550.0, 0.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.forward().then((_) {
      _animationController.reset();
      setState(() {
        _dragOffset = Offset.zero;
        _angle = 0.0;
        _isAnimating = false;
      });
    });
  }

  void _snapBack() {
    setState(() {
      _isAnimating = true;
    });

    _swipeAnimation = Tween<Offset>(begin: _dragOffset, end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _animationController.forward().then((_) {
      _animationController.reset();
      setState(() {
        _dragOffset = Offset.zero;
        _angle = 0.0;
        _isAnimating = false;
      });
    });
  }
}
