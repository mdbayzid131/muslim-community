import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_community/appcolore.dart';
import 'package:muslim_community/jummarole/askimam/ui/submissionsuccessui.dart';

import 'package:muslim_community/jummarole/askimam/controller/ask_imam_controller.dart';
import 'package:intl/intl.dart';

class AskImamUI extends StatefulWidget {
  const AskImamUI({super.key});

  @override
  State<AskImamUI> createState() => _AskImamUIState();
}

class _AskImamUIState extends State<AskImamUI> {
  bool isAskTab = true;
  final AskImamController _controller = Get.put(AskImamController());

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: RefreshIndicator(
        onRefresh: () => _controller.fetchMyQuestions(),
        color: AppColors.jummaColor,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              // High-Fidelity Header
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(top: 80.h, bottom: 60.h),
                decoration: BoxDecoration(
                  color: AppColors.jummaColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50.r),
                    bottomRight: Radius.circular(50.r),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.jummaColor.withValues(alpha: 0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    'Ask Imam',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 48.sp,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 30.h),

              // Refined Tab Switcher
              Container(
                margin: EdgeInsets.symmetric(horizontal: 24.w),
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
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
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          decoration: BoxDecoration(
                            color: isAskTab
                                ? AppColors.jummaColor
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                          child: Center(
                            child: Text(
                              'Ask Imam',
                              style: GoogleFonts.inter(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.bold,
                                color: isAskTab
                                    ? Colors.white
                                    : AppColors.jummaColor.withValues(
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
                        onTap: () => setState(() => isAskTab = false),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          decoration: BoxDecoration(
                            color: !isAskTab
                                ? AppColors.jummaColor
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                          child: Center(
                            child: Text(
                              'Answered',
                              style: GoogleFonts.inter(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.bold,
                                color: !isAskTab
                                    ? Colors.white
                                    : AppColors.jummaColor.withValues(
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

              SizedBox(height: 40.h),

              // Content Section
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: isAskTab ? _buildAskForm() : _buildAnsweredList(),
              ),
            ],
          ),
        ),
      ),
    );
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
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.titleColor,
            ),
          ),
          SizedBox(height: 15.h),
          TextField(
            controller: _controller.questionController,
            maxLines: 8,
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              color: AppColors.titleColor,
            ),
            decoration: InputDecoration(
              hintText: 'Type your question here...',
              hintStyle: GoogleFonts.inter(
                color: AppColors.greyColor,
                fontSize: 16.sp,
              ),
              filled: true,
              fillColor: Colors.white,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.r),
                borderSide: const BorderSide(
                  color: AppColors.goldColor,
                  width: 1.2,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.r),
                borderSide: const BorderSide(
                  color: AppColors.jummaColor,
                  width: 2,
                ),
              ),
              contentPadding: EdgeInsets.all(24.w),
            ),
          ),
          SizedBox(height: 50.h),
          SizedBox(
            width: double.infinity,
            height: 70.h,
            child: Obx(
              () => ElevatedButton(
                onPressed: _controller.isSubmitting.value
                    ? null
                    : () async {
                        final success = await _controller.submitQuestion(
                          _controller.questionController.text,
                        );
                        if (success) {
                          _controller.questionController.clear();
                          Get.to(
                            () => const SubmissionSuccessUI(),
                            transition: Transition.fadeIn,
                          );
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.jummaColor,
                  shape: const StadiumBorder(),
                  elevation: 10,
                  shadowColor: AppColors.jummaColor.withValues(alpha: 0.3),
                ),
                child: _controller.isSubmitting.value
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.send_rounded,
                            color: Colors.white,
                            size: 22.sp,
                          ),
                          SizedBox(width: 14.w),
                          Text(
                            'Submit Question',
                            style: GoogleFonts.inter(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
          SizedBox(height: 50.h),
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Text(
                'Your question will be answered by a qualified Imam. Please be respectful and patient.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  color: AppColors.bodyColor,
                  height: 1.6,
                ),
              ),
            ),
          ),
          SizedBox(height: 50.h),
        ],
      ),
    );
  }

  Widget _buildAnsweredList() {
    return Obx(() {
      if (_controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (_controller.myQuestions.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.question_answer_outlined,
                size: 64.sp,
                color: Colors.grey.shade300,
              ),
              SizedBox(height: 20.h),
              Text(
                'No questions yet',
                style: GoogleFonts.inter(
                  fontSize: 18.sp,
                  color: Colors.grey.shade400,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      }

      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _controller.myQuestions.length,
          itemBuilder: (context, index) {
            final question = _controller.myQuestions[index];
            return Column(
              children: [
                // Question Card
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(24.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
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
                                size: 14,
                                color: Colors.grey,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                'Submitted ${DateFormat('MMM dd, yyyy').format(question.createdAt)}',
                                style: GoogleFonts.inter(
                                  fontSize: 12.sp,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: question.status == 'answered'
                                  ? Colors.green.withValues(alpha: 0.1)
                                  : Colors.orange.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Text(
                              question.status.toUpperCase(),
                              style: GoogleFonts.inter(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.bold,
                                color: question.status == 'answered'
                                    ? Colors.green
                                    : Colors.orange,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 18.h),
                      Text(
                        question.question,
                        style: GoogleFonts.inter(
                          fontSize: 16.sp,
                          color: AppColors.titleColor,
                          height: 1.7,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                if (question.answers.isNotEmpty) ...[
                  SizedBox(height: 15.h),
                  // Answer Card
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(1.2.w),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.jummaColor.withValues(alpha: 0.4),
                          AppColors.jummaColor.withValues(alpha: 0.1),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                    child: Container(
                      padding: EdgeInsets.all(24.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(29.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(10.w),
                                decoration: BoxDecoration(
                                  color: AppColors.jummaColor,
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: const Icon(
                                  Icons.auto_awesome_rounded,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                              SizedBox(width: 16.w),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Answer from Imam',
                                    style: GoogleFonts.inter(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.jummaColor,
                                    ),
                                  ),
                                  Text(
                                    'Answered ${DateFormat('MMM dd').format(question.answers.first.createdAt)}',
                                    style: GoogleFonts.inter(
                                      fontSize: 12.sp,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 20.h),
                          const Divider(thickness: 0.5),
                          SizedBox(height: 20.h),
                          Text(
                            question.answers.first.answer,
                            style: GoogleFonts.inter(
                              fontSize: 15.sp,
                              color: AppColors.bodyColor,
                              height: 1.8,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                SizedBox(height: 25.h),
              ],
            );
          },
        ),
      );
    });
  }
}
