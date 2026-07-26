import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_community/appcolore.dart';
import 'package:muslim_community/male_role/discover/ui/ask_success_ui.dart';
import 'package:muslim_community/female_role/discover/controller/asksistercontroller.dart';

class AskSisterUI extends StatefulWidget {
  const AskSisterUI({super.key});

  @override
  State<AskSisterUI> createState() => _AskSisterUIState();
}

class _AskSisterUIState extends State<AskSisterUI> {
  bool isAskTab = true;
  final AskSisterController controller = Get.put(AskSisterController());
  final TextEditingController _questionController = TextEditingController();

  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => controller.fetchMyQuestions(),
      color: AppColors.femaleColor,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            // Tab Switcher
            Container(
              margin: EdgeInsets.symmetric(horizontal: 24.w),
              padding: EdgeInsets.all(6.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => isAskTab = true),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        decoration: BoxDecoration(
                          color: isAskTab
                              ? AppColors.femaleColor
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(15.r),
                        ),
                        child: Center(
                          child: Text(
                            'Ask Sister',
                            style: GoogleFonts.inter(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: isAskTab
                                  ? Colors.white
                                  : AppColors.femaleColor.withValues(
                                      alpha: 0.5,
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() => isAskTab = false);
                        controller.fetchMyQuestions();
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        decoration: BoxDecoration(
                          color: !isAskTab
                              ? AppColors.femaleColor
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(15.r),
                        ),
                        child: Center(
                          child: Text(
                            'Answered',
                            style: GoogleFonts.inter(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: !isAskTab
                                  ? Colors.white
                                  : AppColors.femaleColor.withValues(
                                      alpha: 0.5,
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 30.h),

            // Content Section
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: isAskTab ? _buildAskForm() : _buildAnsweredList(),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ), // SingleChildScrollView
    ); // RefreshIndicator
  }

  Widget _buildAskForm() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Question',
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.titleColor,
            ),
          ),
          SizedBox(height: 15.h),
          TextField(
            controller: _questionController,
            maxLines: 6,
            style: GoogleFonts.inter(
              fontSize: 15.sp,
              color: AppColors.titleColor,
            ),
            decoration: InputDecoration(
              hintText: 'Type your question here...',
              hintStyle: GoogleFonts.inter(
                color: AppColors.greyColor,
                fontSize: 14.sp,
              ),
              filled: true,
              fillColor: Colors.white,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.r),
                borderSide: BorderSide(
                  color: AppColors.femaleColor.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.r),
                borderSide: const BorderSide(
                  color: AppColors.femaleColor,
                  width: 1.5,
                ),
              ),
              contentPadding: EdgeInsets.all(20.w),
            ),
          ),
          SizedBox(height: 30.h),
          SizedBox(
            width: double.infinity,
            height: 55.h,
            child: Obx(() {
              final isSubmitting = controller.isSubmitting.value;
              return ElevatedButton(
                onPressed: isSubmitting
                    ? null
                    : () async {
                        final question = _questionController.text;
                        final success = await controller.submitQuestion(
                          question,
                        );
                        if (success) {
                          _questionController.clear();
                          Get.to(
                            () => const AskSuccessUI(role: 'sister'),
                            transition: Transition.fadeIn,
                          );
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.femaleColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                  elevation: 0,
                ),
                child: isSubmitting
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.send_rounded,
                            color: Colors.white,
                            size: 18.sp,
                          ),
                          SizedBox(width: 10.w),
                          Text(
                            'Submit Question',
                            style: GoogleFonts.inter(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
              );
            }),
          ),
          SizedBox(height: 30.h),
          Center(
            child: Text(
              'Your question will be answered by a qualified sister. Please be respectful and patient.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 13.sp,
                color: AppColors.bodyColor,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnsweredList() {
    return Obx(() {
      if (controller.isLoading.value && controller.myQuestions.isEmpty) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(40.0),
            child: CircularProgressIndicator(color: AppColors.femaleColor),
          ),
        );
      }

      if (controller.myQuestions.isEmpty) {
        return Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 60.h, horizontal: 24.w),
            child: Column(
              children: [
                Icon(
                  Icons.question_answer_outlined,
                  size: 60.sp,
                  color: Colors.grey[400],
                ),
                SizedBox(height: 15.h),
                Text(
                  'No questions submitted yet',
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Your submitted questions and answers will appear here.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 13.sp,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
        );
      }

      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller.myQuestions.length,
          separatorBuilder: (context, index) => SizedBox(height: 20.h),
          itemBuilder: (context, index) {
            final question = controller.myQuestions[index];
            final hasAnswer = question.answers.isNotEmpty;
            final dateStr =
                "${question.createdAt.day}/${question.createdAt.month}/${question.createdAt.year}";

            return Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: hasAnswer
                      ? AppColors.femaleColor.withValues(alpha: 0.15)
                      : Colors.grey.withValues(alpha: 0.15),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.01),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.access_time_rounded,
                            size: 12,
                            color: Colors.grey,
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            'Submitted $dateStr',
                            style: GoogleFonts.inter(
                              fontSize: 11.sp,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: hasAnswer
                              ? Colors.green.withValues(alpha: 0.1)
                              : Colors.orange.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          hasAnswer ? 'ANSWERED' : 'PENDING',
                          style: GoogleFonts.inter(
                            fontSize: 9.sp,
                            fontWeight: FontWeight.bold,
                            color: hasAnswer ? Colors.green : Colors.orange,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    question.question,
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      color: AppColors.titleColor,
                      height: 1.6,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (hasAnswer) ...[
                    SizedBox(height: 15.h),
                    const Divider(thickness: 0.5),
                    SizedBox(height: 15.h),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            color: AppColors.femaleColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Icon(
                            Icons.auto_awesome_rounded,
                            color: AppColors.femaleColor,
                            size: 16.sp,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Answer from Sister',
                              style: GoogleFonts.inter(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.femaleColor,
                              ),
                            ),
                            Text(
                              'Answered on ${question.answers.first.createdAt.day}/${question.answers.first.createdAt.month}/${question.answers.first.createdAt.year}',
                              style: GoogleFonts.inter(
                                fontSize: 11.sp,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      question.answers.first.answer,
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        color: AppColors.bodyColor,
                        height: 1.7,
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      );
    });
  }
}
