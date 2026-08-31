import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:muslim_community/config/themes/app_colors.dart';

class CustomLoader extends StatelessWidget {
  final Color? color;
  final double? size;

  const CustomLoader({super.key, this.color, this.size});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size ?? 36.w,
        height: size ?? 36.w,
        child: CircularProgressIndicator(
          strokeWidth: 3,
          valueColor: AlwaysStoppedAnimation<Color>(color ?? AppColors.maleColor),
        ),
      ),
    );
  }
}
