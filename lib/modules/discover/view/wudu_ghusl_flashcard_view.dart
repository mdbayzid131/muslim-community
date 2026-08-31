import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_community/config/themes/app_colors.dart';

class WuduGhuslFlashcardView extends StatefulWidget {
  final String title;

  const WuduGhuslFlashcardView({super.key, required this.title});

  @override
  State<WuduGhuslFlashcardView> createState() => _WuduGhuslFlashcardViewState();
}

class _WuduGhuslFlashcardViewState extends State<WuduGhuslFlashcardView> {
  static const Color themeColor = Color(0xFF3A5C78);
  static const Color accentGold = Color(0xFFA6864D);
  static const Color textDark = Color(0xFF1A2530);
  static const Color cardBgLight = Color(0xFFFAF8F5);

  int _currentIndex = 0;
  final List<int> _history = []; // History stack to support Rewind/Undo

  // Data for "How to Make Wudu"
  late List<FlashcardModel> _wuduCards;

  // Data for "How to Perform Ghusl"
  late List<FlashcardModel> _ghuslCards;

  @override
  void initState() {
    super.initState();

    // Wudu Deck (First 3 Cards exactly matching the screenshots)
    _wuduCards = [
      // Card 1: Intro Card
      FlashcardModel(
        isIntro: true,
        introTitle: "HOW TO MAKE\nWUDU",
        introSubtitle: "A step by step guide for\nbrothers new to Islam",
        introEmoji: "🤲",
      ),
      // Card 2: Step 1
      FlashcardModel(
        isIntro: false,
        stepNumberText: "STEP ONE",
        stepNumber: 1,
        totalSteps: 8,
        stepTitle: "MAKE YOUR INTENTION",
        stepEmoji: "🫀",
        stepDescription:
            "In your heart, make the intention that you are performing Wudu for the purpose of worship and to purify yourself for prayer. You do not need to say this out loud — the intention is in your heart.",
        notes: [
          FlashcardNote(
            emoji: "💡",
            text:
                "The intention does not need to be spoken aloud. Allah knows what is in your heart.",
            isDotted: true,
          ),
          FlashcardNote(
            emoji: "🕌",
            text:
                "This is called 'Niyyah' in Arabic. It simply means sincerely intending to purify yourself for Allah.",
            isDotted: false,
          ),
        ],
      ),
      // Card 3: Step 2
      FlashcardModel(
        isIntro: false,
        stepNumberText: "STEP TWO",
        stepNumber: 2,
        totalSteps: 8,
        stepTitle: "SAY BISMILLAH",
        stepEmoji: "🗣️",
        stepDescription:
            "Before you begin washing, say Bismillah — \"In the name of Allah.\" This begins your Wudu with the remembrance of Allah.",
        sayThis: FlashcardSayThis(
          arabic: "بِسْمِ اللَّهِ",
          transliteration: "Bismillah",
          translation: "In the name of Allah",
        ),
        notes: [
          FlashcardNote(
            emoji: "🕌",
            text:
                "If you forget to say Bismillah at the start, say it as soon as you remember.",
            isDotted: false,
          ),
        ],
      ),
      // Card 4: Step 3
      FlashcardModel(
        isIntro: false,
        stepNumberText: "STEP THREE",
        stepNumber: 3,
        totalSteps: 8,
        stepTitle: "WASH YOUR HANDS",
        stepEmoji: "🙌",
        stepDescription:
            "Wash both hands up to and including the wrists three times. Make sure to wash between your fingers and remove any rings to ensure water reaches all areas.",
        notes: [
          FlashcardNote(
            emoji: "💡",
            text:
                "No specific Dua for this step — focus on washing thoroughly.",
            isDotted: true,
          ),
          FlashcardNote(
            emoji: "🕌",
            text:
                "Start with your right hand, then your left. Always right before left throughout Wudu.",
            isDotted: false,
          ),
        ],
      ),
      // Card 5: Step 4
      FlashcardModel(
        isIntro: false,
        stepNumberText: "STEP FOUR",
        stepNumber: 4,
        totalSteps: 8,
        stepTitle: "RINSE MOUTH & NOSE",
        stepEmoji: "💧",
        stepDescription:
            "Take water into your mouth and swirl it around three times, then spit it out. Then sniff water into your nostrils three times and blow it out gently. This is done together.",
        notes: [
          FlashcardNote(
            emoji: "💡",
            text: "No specific Dua — rinse mouth and nose three times each.",
            isDotted: true,
          ),
          FlashcardNote(
            emoji: "🕌",
            text:
                "If you are fasting, be gentle so water does not accidentally go down your throat.",
            isDotted: false,
          ),
        ],
      ),
      // Card 6: Step 5
      FlashcardModel(
        isIntro: false,
        stepNumberText: "STEP FIVE",
        stepNumber: 5,
        totalSteps: 8,
        stepTitle: "WASH YOUR FACE",
        stepEmoji: "🫧",
        stepDescription:
            "Wash your entire face three times — from your hairline to your chin, and from ear to ear. If you have a beard, run wet fingers through it to ensure water reaches the skin beneath.",
        notes: [
          FlashcardNote(
            emoji: "💡",
            text:
                "If you have a beard, use your fingers to run water through it.",
            isDotted: true,
          ),
          FlashcardNote(
            emoji: "🕌",
            text:
                "Make sure every part of your face is covered with water including eyebrows and the beard area.",
            isDotted: false,
          ),
        ],
      ),
      // Card 7: Step 6
      FlashcardModel(
        isIntro: false,
        stepNumberText: "STEP SIX",
        stepNumber: 6,
        totalSteps: 8,
        stepTitle: "WASH YOUR ARMS",
        stepEmoji: "💪",
        stepDescription:
            "Wash your right arm from fingertips up to and including the elbow three times. Then wash your left arm the same way three times. Make sure water covers every part including between fingers.",
        notes: [
          FlashcardNote(
            emoji: "💡",
            text: "Right arm first, then left — three times each.",
            isDotted: true,
          ),
          FlashcardNote(
            emoji: "🕌",
            text:
                "Always right before left. Make sure water reaches all the way up to and including the elbow.",
            isDotted: false,
          ),
        ],
      ),
      // Card 8: Step 7
      FlashcardModel(
        isIntro: false,
        stepNumberText: "STEP SEVEN",
        stepNumber: 7,
        totalSteps: 8,
        stepTitle: "WIPE HEAD & EARS",
        stepEmoji: "👋",
        stepDescription:
            "With wet hands, wipe over your head once — from your forehead to the back of your head and back again. Then use your index fingers to wipe inside your ears and thumbs behind your ears.",
        notes: [
          FlashcardNote(
            emoji: "💡",
            text: "This is done once only — not three times like washing.",
            isDotted: true,
          ),
          FlashcardNote(
            emoji: "🕌",
            text:
                "Use both hands together sweeping from front to back then back to front in one motion.",
            isDotted: false,
          ),
        ],
      ),
      // Card 9: Step 8
      FlashcardModel(
        isIntro: false,
        stepNumberText: "STEP EIGHT",
        stepNumber: 8,
        totalSteps: 8,
        stepTitle: "WASH YOUR FEET",
        stepEmoji: "🦶",
        stepDescription:
            "Wash your right foot including the ankle three times — making sure to wash between your toes. Then wash your left foot the same way three times. Your Wudu is now complete.",
        sayThis: FlashcardSayThis(
          arabic:
              "أَشْهَدُ أَنْ لَا إِلٰهَ إِلَّا اللهُ وَأَشْهَدُ أَنَّ مُحَمَّدًا عَبْدُهُ وَرَسُولُهُ",
          transliteration:
              "Ash-hadu an la ilaha illallah wa ash-hadu anna Muhammadan abduhu wa rasuluh",
          translation:
              "I bear witness that there is no god but Allah and that Muhammad is His servant and messenger",
          title: "DUA AFTER COMPLETING WUDU",
        ),
      ),
      // Card 10: Things That Break Wudu Info Card
      FlashcardModel(
        isIntro: false,
        isInfoCard: true,
        infoTitle: "THINGS THAT BREAK WUDU",
        infoEmoji: "💡",
        infoBottomText: "No question is too small. You are not alone. 💜",
        infoFooterText: "SYA BROTHERS",
        infoItems: [
          FlashcardItem(
            emoji: "💨",
            title: "Passing wind",
            description:
                "Any gas passed from the back passage breaks Wudu. You must repeat Wudu before praying.",
          ),
          FlashcardItem(
            emoji: "🛌",
            title: "Sleeping",
            description:
                "Deep sleep breaks Wudu. A light doze while sitting does not.",
          ),
          FlashcardItem(
            emoji: "🩸",
            title: "Blood or discharge",
            description: "Bleeding from wounds or any discharge breaks Wudu.",
          ),
          FlashcardItem(
            emoji: "🚽",
            title: "Using the toilet",
            description:
                "Going to the toilet always breaks Wudu. Always make Wudu after.",
          ),
        ],
      ),
    ];

    // Ghusl Deck (Placeholder)
    _ghuslCards = [
      FlashcardModel(
        isIntro: true,
        introTitle: "HOW TO PERFORM\nGHUSL",
        introSubtitle:
            "Full purification — a gentle guide\nfor brothers new to Islam",
        introEmoji: "🚿",
      ),
      // Card 2: When is Ghusl required info card
      FlashcardModel(
        isIntro: false,
        isInfoCard: true,
        infoTitle: "WHEN IS GHUSL REQUIRED?",
        showBrothersBadge: true,
        infoThemeColor: themeColor,
        infoFooterLeft: "How to Perform Ghusl",
        infoFooterRight: "When required",
        infoNote: FlashcardNote(
          emoji: "💡",
          text:
              "No question is too small — every new Muslim has these questions. You are not alone. 💜",
          isDotted: false,
        ),
        infoItems: [
          FlashcardItem(
            emoji: "🌙",
            title: "After becoming Muslim",
            description:
                "When you take your Shahada, performing Ghusl is recommended as a beautiful new beginning in Islam.",
          ),
          FlashcardItem(
            emoji: "🤍",
            title: "After intimacy",
            description:
                "Ghusl is required after marital intimacy before performing prayer or touching the Quran.",
          ),
          FlashcardItem(
            emoji: "💤",
            title: "After a nocturnal emission",
            description:
                "If you wake and find that a nocturnal emission has occurred, Ghusl is required before prayer.",
          ),
          FlashcardItem(
            emoji: "🕌",
            title: "Recommended for Jummah",
            description:
                "It is highly recommended to perform Ghusl before the Friday Jummah prayer.",
          ),
        ],
      ),
      // Card 3: Your first Ghusl as a Muslim
      FlashcardModel(
        isIntro: false,
        isInfoCard: true,
        infoTitle: "YOUR FIRST GHUSL AS A MUSLIM",
        infoEmoji: "🌙 ✨",
        infoIsCentered: true,
        infoThemeColor: themeColor,
        infoFooterLeft: "How to Perform Ghusl",
        infoFooterRight: "Your new beginning",
        infoBodyText:
            "When you take your Shahada and enter Islam, it is recommended to perform Ghusl as a beautiful symbol of purification and new beginning. You are washing away the old and starting completely fresh.",
        infoQuoteText:
            "\"Islam wipes out what came before it.\" — Prophet Muhammad ﷺ",
        infoBottomText:
            "This Ghusl is your fresh start. Welcome to Islam, brother. 💜",
      ),
      FlashcardModel(
        isIntro: false,
        stepNumberText: "STEP ONE",
        stepNumber: 1,
        totalSteps: 6,
        stepTitle: "MAKE YOUR INTENTION",
        stepEmoji: "🫀",
        stepDescription:
            "In your heart make the intention that you are performing Ghusl to purify yourself for worship. You do not need to say this out loud — Allah knows what is in your heart.",
        notes: [
          FlashcardNote(
            emoji: "💡",
            text:
                "The intention is made in the heart before you begin. No words need to be spoken.",
            isDotted: true,
          ),
          FlashcardNote(
            emoji: "🕌",
            text:
                "This is called Niyyah. Simply intend sincerely that you are purifying yourself for the sake of Allah.",
            isDotted: false,
          ),
        ],
      ),
      // Card 5: Step 2
      FlashcardModel(
        isIntro: false,
        stepNumberText: "STEP TWO",
        stepNumber: 2,
        totalSteps: 6,
        stepTitle: "BISMILLAH & WASH HANDS",
        stepEmoji: "🙌",
        stepDescription:
            "Say Bismillah and wash both hands three times before beginning. This removes any impurity from your hands before you use them to wash the rest of your body.",
        sayThis: FlashcardSayThis(
          arabic: "بِسْمِ اللَّهِ",
          transliteration: "Bismillah",
          translation: "In the name of Allah",
          title: "SAY THIS FIRST",
        ),
        notes: [
          FlashcardNote(
            emoji: "🕌",
            text:
                "Wash between your fingers and make sure every part of both hands is clean before continuing.",
            isDotted: false,
          ),
        ],
      ),
      // Card 6: Step 3
      FlashcardModel(
        isIntro: false,
        stepNumberText: "STEP THREE",
        stepNumber: 3,
        totalSteps: 6,
        stepTitle: "REMOVE IMPURITY",
        stepEmoji: "💧",
        stepDescription:
            "Wash away any physical impurity from your private parts and body using your left hand. This step ensures you are physically clean before beginning the full Ghusl.",
        notes: [
          FlashcardNote(
            emoji: "💡",
            text:
                "Use your left hand for this step. Wash thoroughly until all impurity is removed.",
            isDotted: true,
          ),
          FlashcardNote(
            emoji: "🕌",
            text:
                "After this step wash your hands again with soap before continuing with the rest of Ghusl.",
            isDotted: false,
          ),
        ],
      ),
      // Card 7: Step 4
      FlashcardModel(
        isIntro: false,
        stepNumberText: "STEP FOUR",
        stepNumber: 4,
        totalSteps: 6,
        stepTitle: "PERFORM WUDU",
        stepEmoji: "🤲",
        stepDescription:
            "Perform a complete Wudu — rinse mouth, rinse nose, wash face, wash arms, wipe head and ears. You may delay washing your feet until the end of Ghusl when the water reaches them naturally.",
        notes: [
          FlashcardNote(
            emoji: "💡",
            text:
                "This is the same Wudu from the Wudu flashcards. Follow all 8 steps.",
            isDotted: true,
          ),
          FlashcardNote(
            emoji: "🕌",
            text:
                "Some scholars say you can delay washing your feet until the very end when water flows down to them.",
            isDotted: false,
          ),
        ],
      ),
      // Card 8: Step 5
      FlashcardModel(
        isIntro: false,
        stepNumberText: "STEP FIVE",
        stepNumber: 5,
        totalSteps: 6,
        stepTitle: "WASH YOUR HEAD & HAIR",
        stepEmoji: "💆‍♂️",
        stepDescription:
            "Pour water over your head three times making sure water reaches your scalp completely. Run your fingers through your hair and beard to ensure water reaches every part of your head and face hair.",
        notes: [
          FlashcardNote(
            emoji: "💡",
            text:
                "Make sure water reaches your scalp — not just the surface of your hair.",
            isDotted: true,
          ),
          FlashcardNote(
            emoji: "🕌",
            text:
                "If you have a beard run your wet fingers through it to make sure water reaches the skin beneath.",
            isDotted: false,
          ),
        ],
      ),
      // Card 9: Step 6
      FlashcardModel(
        isIntro: false,
        stepNumberText: "STEP SIX",
        stepNumber: 6,
        totalSteps: 6,
        stepTitle: "WASH YOUR FULL BODY",
        stepEmoji: "🚿",
        stepDescription:
            "Wash your entire body starting from the right side then the left. Make sure water reaches every part — underarms, between toes, the navel and all skin areas. Your Ghusl is now complete.",
        sayThis: FlashcardSayThis(
          arabic:
              "أَشْهَدُ أَنْ لَا إِلٰهَ إِلَّا اللهُ وَأَشْهَدُ أَنَّ مُحَمَّدًا عَبْدُهُ وَرَسُولُهُ",
          transliteration:
              "Ash-hadu an la ilaha illallah wa ash-hadu anna Muhammadan abduhu wa rasuluh",
          translation:
              "I bear witness that there is no god but Allah and Muhammad is His servant and messenger",
          title: "DUA AFTER COMPLETING GHUSL",
        ),
      ),
      // Card 10: Important Things to Know Info Card
      FlashcardModel(
        isIntro: false,
        isInfoCard: true,
        infoTitle: "IMPORTANT THINGS TO KNOW",
        showBrothersBadge: true,
        infoThemeColor: themeColor,
        infoFooterLeft: "How to Perform Ghusl",
        infoFooterRight: "Important notes",
        infoNote: FlashcardNote(
          emoji: "",
          text:
              "No question is too small. You are not alone on this journey. 💜\n— SYA Brothers",
          isDotted: false,
        ),
        infoItems: [
          FlashcardItem(
            emoji: "💍",
            title: "Remove rings and watches",
            description:
                "Remove anything that may prevent water reaching your skin before performing Ghusl.",
          ),
          FlashcardItem(
            emoji: "🧔",
            title: "Beard",
            description:
                "Run wet fingers through your beard to ensure water reaches the skin beneath.",
          ),
          FlashcardItem(
            emoji: "💤",
            title: "Nocturnal emission while fasting",
            description:
                "A nocturnal emission does not break your fast. Perform Ghusl and continue your fast normally.",
          ),
          FlashcardItem(
            emoji: "🤍",
            title: "You are purified",
            description:
                "After Ghusl you are fully purified and may pray, fast, touch the Quran and enter the mosque.",
          ),
        ],
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
    final isWudu = widget.title.toLowerCase().contains("wudu");
    final cards = isWudu ? _wuduCards : _ghuslCards;
    final isCompleted = _currentIndex >= cards.length;

    return Scaffold(
      backgroundColor: const Color(
        0xFFE9EEF2,
      ), // Premium grayish-blue background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: themeColor),
          onPressed: () => Get.back(),
        ),
        title: Text(
          widget.title,
          style: GoogleFonts.playfairDisplay(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: themeColor,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 5.h),
            Text(
              isCompleted
                  ? "Congratulations!"
                  : cards[_currentIndex].isIntro
                  ? "Interactive Learning"
                  : cards[_currentIndex].isInfoCard
                  ? "Overview"
                  : "Step ${cards[_currentIndex].stepNumber} of ${cards.where((c) => !c.isIntro && !c.isInfoCard).length}",
              style: GoogleFonts.inter(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: themeColor,
                letterSpacing: 1.2,
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              isCompleted
                  ? "You have finished this guide."
                  : "Swipe Left for next step, Swipe Right for previous step.",
              style: GoogleFonts.inter(
                fontSize: 11.sp,
                color: AppColors.bodyColor,
              ),
            ),

            // Stack Area
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                child: Center(
                  child: isCompleted
                      ? _buildCompletionCard(isWudu)
                      : PremiumCardDeck(
                          cards: cards,
                          currentIndex: _currentIndex,
                          onSwipe: _onSwipe,
                          cardBuilder: (card) {
                            if (card.isIntro) {
                              return _buildIntroCard(card);
                            } else if (card.isInfoCard) {
                              return _buildInfoCard(card);
                            } else {
                              return _buildStepCard(card);
                            }
                          },
                        ),
                ),
              ),
            ),

            // Controls
            Padding(
              padding: EdgeInsets.only(bottom: 25.h, left: 30.w, right: 30.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Rewind Button
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
                              color: themeColor.withValues(alpha: 0.1),
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
                          size: 22.sp,
                        ),
                      ),
                    ),
                  ),

                  // Simple Progress text
                  Text(
                    isCompleted
                        ? "Completed"
                        : "Card ${_currentIndex + 1} of ${cards.length}",
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: themeColor,
                    ),
                  ),

                  // Reset button
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
                              color: themeColor.withValues(alpha: 0.1),
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
                          size: 22.sp,
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

  // Completion Card
  Widget _buildCompletionCard(bool isWudu) {
    return Container(
      width: 320.w,
      height: 520.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(
          color: themeColor.withValues(alpha: 0.2),
          width: 1.5,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 30.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(22.w),
              decoration: BoxDecoration(
                color: themeColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle_outline_rounded,
                color: themeColor,
                size: 60.sp,
              ),
            ),
            SizedBox(height: 25.h),
            Text(
              "Masha'Allah!",
              style: GoogleFonts.playfairDisplay(
                fontSize: 28.sp,
                fontWeight: FontWeight.bold,
                color: themeColor,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              isWudu
                  ? "You have completed the step-by-step Wudu guide."
                  : "You have completed the step-by-step Ghusl guide.",
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                color: textDark,
                height: 1.5,
              ),
            ),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: themeColor,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 15.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r),
                ),
              ),
              onPressed: _reset,
              child: Text(
                "Restart Guide",
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // INTRO CARD: Styled in deep blue (#3A5C78)
  Widget _buildIntroCard(FlashcardModel card) {
    return Container(
      width: 320.w,
      height: 520.h,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment(0.0, -1.0),
          end: Alignment(0.5, 1.0),
          colors: [Color(0xFF3A5C78), Color(0xFF5A7C98), Color(0xFF7A9DC0)],
          stops: [0.0, 0.45, 1.0],
        ),
        borderRadius: BorderRadius.circular(32.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 40.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Top Header Section
                Column(
                  children: [
                    Container(
                      width: 50.w,
                      height: 1.h,
                      color: Colors.white.withValues(alpha: 0.3),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      "SYA",
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 15.sp,
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
                        color: Colors.white.withValues(alpha: 0.7),
                        letterSpacing: 4.0,
                      ),
                    ),
                  ],
                ),

                // Middle Section
                Column(
                  children: [
                    Text(
                      card.introEmoji ?? "🤲",
                      style: TextStyle(fontSize: 50.sp),
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      card.introTitle ?? "",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.3,
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      card.introSubtitle ?? "",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 14.sp,
                        fontStyle: FontStyle.italic,
                        color: Colors.white.withValues(alpha: 0.85),
                        height: 1.5,
                      ),
                    ),
                  ],
                ),

                // Swipe Help & Bottom Divider
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.swipe_left_rounded,
                          color: Colors.white.withValues(alpha: 0.5),
                          size: 15.sp,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          "SWIPE LEFT FOR NEXT",
                          style: GoogleFonts.inter(
                            fontSize: 9.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white.withValues(alpha: 0.8),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15.h),
                    Container(
                      width: 50.w,
                      height: 1.h,
                      color: Colors.white.withValues(alpha: 0.3),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // STEP CARD: Styled in light cream/off-white background
  Widget _buildStepCard(FlashcardModel card) {
    return Container(
      width: 320.w,
      height: 520.h,
      clipBehavior: Clip.antiAlias, // Clips the children to the rounded corners
      decoration: BoxDecoration(
        color: cardBgLight,
        borderRadius: BorderRadius.circular(32.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Blue top accent bar
          Container(
            height: 12.h, // Perfect premium height
            color: themeColor,
          ),

          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
              child: Column(
                children: [
                  // 1. Top Bar: SYA and Brothers Badge
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "SYA",
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: accentGold,
                          letterSpacing: 1.0,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEDF4F9),
                          borderRadius: BorderRadius.circular(15.r),
                          border: Border.all(
                            color: const Color(0xFFD2DFE9),
                            width: 1.w,
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
                            SizedBox(width: 4.w),
                            Text("🕌", style: TextStyle(fontSize: 9.sp)),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 12.h),

                  // Scrollable Body Content
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 2. Step Title Block with Circle Indicator and Far-Right Icon
                          Row(
                            children: [
                              // Step Circle Indicator with Shadow
                              Container(
                                width: 42.w,
                                height: 42.w,
                                decoration: BoxDecoration(
                                  color: themeColor,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: themeColor.withValues(alpha: 0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  "${card.stepNumber}",
                                  style: GoogleFonts.inter(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(width: 12.w),
                              // Step Title Text
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      card.stepNumberText ?? "",
                                      style: GoogleFonts.inter(
                                        fontSize: 9.sp,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFF4A7A96),
                                        letterSpacing: 1.0,
                                      ),
                                    ),
                                    Text(
                                      card.stepTitle ?? "",
                                      style: GoogleFonts.playfairDisplay(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold,
                                        color: textDark,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Step Emoji
                              if (card.stepEmoji != null)
                                Text(
                                  card.stepEmoji!,
                                  style: TextStyle(fontSize: 30.sp),
                                ),
                            ],
                          ),

                          SizedBox(height: 12.h),
                          Divider(
                            color: const Color(0xFFE5ECF2),
                            thickness: 1.h,
                          ),
                          SizedBox(height: 10.h),

                          // 3. Step Description text
                          Text(
                            card.stepDescription ?? "",
                            style: GoogleFonts.inter(
                              fontSize: 13.sp,
                              color: const Color(0xFF333D47),
                              height: 1.55,
                            ),
                          ),

                          // 3.5 Say This Block (If Present)
                          if (card.sayThis != null) ...[
                            SizedBox(height: 15.h),
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                horizontal: 14.w,
                                vertical: 12.h,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F3F5),
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(
                                  color: const Color(0xFFD0D7DE),
                                  width: 1.w,
                                ),
                              ),
                              child: card.sayThis!.arabic.length > 15
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          card.sayThis!.title ?? "SAY THIS",
                                          style: GoogleFonts.inter(
                                            fontSize: 8.sp,
                                            fontWeight: FontWeight.bold,
                                            color: const Color(0xFF4A7A96),
                                            letterSpacing: 1.0,
                                          ),
                                        ),
                                        SizedBox(height: 8.h),
                                        Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            card.sayThis!.arabic,
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.amiri(
                                              fontSize: 22.sp,
                                              fontWeight: FontWeight.bold,
                                              color: const Color(0xFF1F2328),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 8.h),
                                        Text(
                                          card.sayThis!.transliteration,
                                          style: GoogleFonts.inter(
                                            fontSize: 12.sp,
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.bold,
                                            color: accentGold,
                                          ),
                                        ),
                                        SizedBox(height: 4.h),
                                        Text(
                                          "\"${card.sayThis!.translation}\"",
                                          style: GoogleFonts.inter(
                                            fontSize: 10.sp,
                                            color: const Color(0xFF636E72),
                                          ),
                                        ),
                                      ],
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                card.sayThis!.title ??
                                                    "SAY THIS",
                                                style: GoogleFonts.inter(
                                                  fontSize: 8.sp,
                                                  fontWeight: FontWeight.bold,
                                                  color: const Color(
                                                    0xFF4A7A96,
                                                  ),
                                                  letterSpacing: 1.0,
                                                ),
                                              ),
                                              SizedBox(height: 8.h),
                                              Text(
                                                card.sayThis!.transliteration,
                                                style: GoogleFonts.inter(
                                                  fontSize: 12.sp,
                                                  fontStyle: FontStyle.italic,
                                                  fontWeight: FontWeight.bold,
                                                  color: accentGold,
                                                ),
                                              ),
                                              Text(
                                                "\"${card.sayThis!.translation}\"",
                                                style: GoogleFonts.inter(
                                                  fontSize: 10.sp,
                                                  color: const Color(
                                                    0xFF636E72,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          card.sayThis!.arabic,
                                          style: GoogleFonts.amiri(
                                            fontSize: 22.sp,
                                            fontWeight: FontWeight.bold,
                                            color: const Color(0xFF1F2328),
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ],

                          SizedBox(height: 15.h),

                          // 4. Custom Styled Note Boxes
                          if (card.notes != null)
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: card.notes!.length,
                              separatorBuilder: (context, index) =>
                                  SizedBox(height: 10.h),
                              itemBuilder: (context, index) {
                                final note = card.notes![index];
                                return note.isDotted
                                    ? CustomPaint(
                                        painter: DottedBorderPainter(
                                          color: const Color(0xFFEADCC6),
                                          borderRadius: 12.r,
                                        ),
                                        child: _buildNoteContent(
                                          note,
                                          const Color(0xFFFCF8F2),
                                        ),
                                      )
                                    : Container(
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF9F5EE),
                                          borderRadius: BorderRadius.circular(
                                            12.r,
                                          ),
                                        ),
                                        child: _buildNoteContent(
                                          note,
                                          Colors.transparent,
                                        ),
                                      );
                              },
                            ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 10.h),
                  Divider(color: const Color(0xFFE5ECF2), thickness: 1.h),
                  SizedBox(height: 5.h),

                  // 5. Card Footer: "How to Make Wudu" / "Step X of Y"
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.title.toLowerCase().contains("wudu")
                            ? "How to Make Wudu"
                            : "How to Perform Ghusl",
                        style: GoogleFonts.inter(
                          fontSize: 10.sp,
                          fontStyle: FontStyle.italic,
                          color: const Color(0xFF8B96A5),
                        ),
                      ),
                      Text(
                        "Step ${card.stepNumber} of ${card.totalSteps}",
                        style: GoogleFonts.inter(
                          fontSize: 10.sp,
                          color: const Color(0xFF8B96A5),
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

  Widget _buildNoteContent(FlashcardNote note, Color bgColor) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (note.emoji.isNotEmpty) ...[
            Text(note.emoji, style: TextStyle(fontSize: 14.sp)),
            SizedBox(width: 8.w),
          ],
          Expanded(
            child: Text(
              note.text,
              style: GoogleFonts.inter(
                fontSize: 11.sp,
                fontStyle: FontStyle.italic,
                color: const Color(0xFF786242),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // INFO CARD: Styled in light cream/off-white background with customizable top accent bar
  Widget _buildInfoCard(FlashcardModel card) {
    final barColor = card.infoThemeColor ?? accentGold;

    return Container(
      width: 320.w,
      height: 520.h,
      clipBehavior: Clip.antiAlias, // Clips the children to the rounded corners
      decoration: BoxDecoration(
        color: cardBgLight,
        borderRadius: BorderRadius.circular(32.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Top accent bar
          Container(height: 12.h, color: barColor),

          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
              child: Column(
                children: [
                  // 1. Top Bar / Header: Title & Badge/Emoji
                  if (card.infoIsCentered) ...[
                    if (card.infoEmoji != null) ...[
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          card.infoEmoji!,
                          style: TextStyle(fontSize: 40.sp),
                        ),
                      ),
                      SizedBox(height: 10.h),
                    ],
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        card.infoTitle ?? "",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: themeColor,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ] else ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            card.infoTitle ?? "",
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                              color: themeColor,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        if (card.showBrothersBadge)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEDF4F9),
                              borderRadius: BorderRadius.circular(15.r),
                              border: Border.all(
                                color: const Color(0xFFD2DFE9),
                                width: 1.w,
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
                                SizedBox(width: 4.w),
                                Text("🕌", style: TextStyle(fontSize: 9.sp)),
                              ],
                            ),
                          )
                        else if (card.infoEmoji != null)
                          Text(
                            card.infoEmoji!,
                            style: TextStyle(fontSize: 20.sp),
                          ),
                      ],
                    ),
                  ],

                  SizedBox(height: 12.h),

                  // 2. Scrollable Items & Body Content
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: card.infoIsCentered
                            ? CrossAxisAlignment.center
                            : CrossAxisAlignment.start,
                        children: [
                          if (card.infoBodyText != null) ...[
                            Text(
                              card.infoBodyText!,
                              textAlign: card.infoIsCentered
                                  ? TextAlign.center
                                  : TextAlign.start,
                              style: GoogleFonts.inter(
                                fontSize: 13.sp,
                                color: const Color(0xFF333D47),
                                height: 1.55,
                              ),
                            ),
                            SizedBox(height: 15.h),
                          ],

                          if (card.infoQuoteText != null) ...[
                            Container(
                              width: double.infinity,
                              margin: EdgeInsets.symmetric(vertical: 10.h),
                              padding: EdgeInsets.only(left: 14.w),
                              decoration: BoxDecoration(
                                border: Border(
                                  left: BorderSide(
                                    color: themeColor,
                                    width: 3.w,
                                  ),
                                ),
                              ),
                              child: Text(
                                card.infoQuoteText!,
                                style: GoogleFonts.inter(
                                  fontSize: 12.sp,
                                  fontStyle: FontStyle.italic,
                                  color: const Color(0xFF4A7A96),
                                  height: 1.5,
                                ),
                              ),
                            ),
                            SizedBox(height: 15.h),
                          ],

                          if (card.infoItems != null) ...[
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: card.infoItems!.length,
                              separatorBuilder: (context, index) =>
                                  SizedBox(height: 10.h),
                              itemBuilder: (context, index) {
                                final item = card.infoItems![index];
                                return Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 14.w,
                                    vertical: 12.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16.r),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.02,
                                        ),
                                        blurRadius: 6,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                    border: Border.all(
                                      color: const Color(0xFFEDF2F7),
                                      width: 1.w,
                                    ),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.emoji,
                                        style: TextStyle(fontSize: 18.sp),
                                      ),
                                      SizedBox(width: 12.w),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item.title,
                                              style: GoogleFonts.inter(
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.bold,
                                                color: textDark,
                                              ),
                                            ),
                                            SizedBox(height: 4.h),
                                            Text(
                                              item.description,
                                              style: GoogleFonts.inter(
                                                fontSize: 10.5.sp,
                                                color: const Color(0xFF636E72),
                                                height: 1.4,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],

                          if (card.infoNote != null) ...[
                            SizedBox(height: 15.h),
                            card.infoNote!.isDotted
                                ? CustomPaint(
                                    painter: DottedBorderPainter(
                                      color: const Color(0xFFEADCC6),
                                      borderRadius: 12.r,
                                    ),
                                    child: _buildNoteContent(
                                      card.infoNote!,
                                      const Color(0xFFFCF8F2),
                                    ),
                                  )
                                : Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF9F5EE),
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                    child: _buildNoteContent(
                                      card.infoNote!,
                                      Colors.transparent,
                                    ),
                                  ),
                          ],

                          if (card.infoBottomText != null) ...[
                            SizedBox(height: 20.h),
                            Text(
                              card.infoBottomText!,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                fontSize: 12.sp,
                                fontStyle: FontStyle.italic,
                                color: themeColor.withValues(alpha: 0.8),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),

                  // 3. Footer Section (Left/Right or centered)
                  if (card.infoFooterLeft != null &&
                      card.infoFooterRight != null) ...[
                    SizedBox(height: 10.h),
                    Divider(color: const Color(0xFFE5ECF2), thickness: 1.h),
                    SizedBox(height: 5.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          card.infoFooterLeft!,
                          style: GoogleFonts.inter(
                            fontSize: 10.sp,
                            fontStyle: FontStyle.italic,
                            color: const Color(0xFF8B96A5),
                          ),
                        ),
                        Text(
                          card.infoFooterRight!,
                          style: GoogleFonts.inter(
                            fontSize: 10.sp,
                            color: const Color(0xFF8B96A5),
                          ),
                        ),
                      ],
                    ),
                  ] else if (card.infoFooterText != null) ...[
                    SizedBox(height: 10.h),
                    Divider(color: const Color(0xFFE5ECF2), thickness: 1.h),
                    SizedBox(height: 5.h),
                    Text(
                      card.infoFooterText!,
                      style: GoogleFonts.inter(
                        fontSize: 9.sp,
                        fontWeight: FontWeight.bold,
                        color: barColor,
                        letterSpacing: 2.0,
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
}

// Custom Premium Stack Deck Swiper
class PremiumCardDeck extends StatefulWidget {
  final List<FlashcardModel> cards;
  final int currentIndex;
  final Function(int) onSwipe;
  final Widget Function(FlashcardModel) cardBuilder;

  const PremiumCardDeck({
    super.key,
    required this.cards,
    required this.currentIndex,
    required this.onSwipe,
    required this.cardBuilder,
  });

  @override
  State<PremiumCardDeck> createState() => _PremiumCardDeckState();
}

class _PremiumCardDeckState extends State<PremiumCardDeck>
    with SingleTickerProviderStateMixin {
  Offset _dragOffset = Offset.zero;
  double _angle = 0.0;
  bool _isAnimating = false;
  late AnimationController _animationController;
  late Animation<Offset> _swipeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
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

    // Only scale up next card if dragging left (forward)
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
                        angle:
                            (_swipeAnimation.value.dx / 1000.0) *
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

                    // Swipe Left -> Next (Triggered at -120px)
                    if (_dragOffset.dx < -120) {
                      _animateAndSwipeForward();
                    }
                    // Swipe Right -> Previous (Triggered at +120px)
                    else if (_dragOffset.dx > 120) {
                      _animateAndSwipeBackward();
                    }
                    // Snap back
                    else {
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

    const targetX = -550.0; // flies off to the left
    _swipeAnimation =
        Tween<Offset>(
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

    // Immediately update index to previous card in parent
    widget.onSwipe(widget.currentIndex - 1);

    // Animate the previous card coming back on screen from the left
    setState(() {
      _isAnimating = true;
      _dragOffset = const Offset(-550.0, 0.0);
      _angle = -10 * (math.pi / 180);
    });

    _swipeAnimation =
        Tween<Offset>(
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

    _swipeAnimation = Tween<Offset>(begin: _dragOffset, end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.elasticOut,
          ),
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

// Dotted Border Custom Painter
class DottedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;
  final double dashLength;
  final double borderRadius;

  DottedBorderPainter({
    required this.color,
    this.strokeWidth = 1.0,
    this.gap = 4.0,
    this.dashLength = 6.0,
    this.borderRadius = 12.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          Radius.circular(borderRadius),
        ),
      );

    final dashPath = Path();
    double distance = 0.0;
    for (final metric in path.computeMetrics()) {
      while (distance < metric.length) {
        dashPath.addPath(
          metric.extractPath(distance, distance + dashLength),
          Offset.zero,
        );
        distance += dashLength + gap;
      }
    }
    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Models
class FlashcardModel {
  final bool isIntro;
  final bool isInfoCard;
  final String? introTitle;
  final String? introSubtitle;
  final String? introEmoji;
  final String? stepNumberText;
  final int? stepNumber;
  final int? totalSteps;
  final String? stepTitle;
  final String? stepEmoji;
  final String? stepDescription;
  final List<FlashcardNote>? notes;
  final FlashcardSayThis? sayThis;
  final String? infoTitle;
  final String? infoEmoji;
  final List<FlashcardItem>? infoItems;
  final String? infoBottomText;
  final String? infoFooterText;
  final Color? infoThemeColor;
  final String? infoFooterLeft;
  final String? infoFooterRight;
  final FlashcardNote? infoNote;
  final bool showBrothersBadge;
  final bool infoIsCentered;
  final String? infoBodyText;
  final String? infoQuoteText;

  FlashcardModel({
    required this.isIntro,
    this.isInfoCard = false,
    this.introTitle,
    this.introSubtitle,
    this.introEmoji,
    this.stepNumberText,
    this.stepNumber,
    this.totalSteps,
    this.stepTitle,
    this.stepEmoji,
    this.stepDescription,
    this.notes,
    this.sayThis,
    this.infoTitle,
    this.infoEmoji,
    this.infoItems,
    this.infoBottomText,
    this.infoFooterText,
    this.infoThemeColor,
    this.infoFooterLeft,
    this.infoFooterRight,
    this.infoNote,
    this.showBrothersBadge = false,
    this.infoIsCentered = false,
    this.infoBodyText,
    this.infoQuoteText,
  });
}

class FlashcardItem {
  final String emoji;
  final String title;
  final String description;

  FlashcardItem({
    required this.emoji,
    required this.title,
    required this.description,
  });
}

class FlashcardNote {
  final String emoji;
  final String text;
  final bool isDotted;

  FlashcardNote({
    required this.emoji,
    required this.text,
    required this.isDotted,
  });
}

class FlashcardSayThis {
  final String arabic;
  final String transliteration;
  final String translation;
  final String? title;

  FlashcardSayThis({
    required this.arabic,
    required this.transliteration,
    required this.translation,
    this.title,
  });
}
