import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_community/appcolore.dart';

class AskImamUI extends StatelessWidget {
  const AskImamUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.question_answer,
            size: 60.sp,
            color: AppColors.maleColor.withValues(alpha: 0.5),
          ),
          SizedBox(height: 20.h),
          Text(
            'Ask Imam Module',
            style: GoogleFonts.playfairDisplay(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.titleColor,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            'Ask Imam interface will be designed here.',
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              color: AppColors.bodyColor,
            ),
          ),
        ],
      ),
    );
  }
}
