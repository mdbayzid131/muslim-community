import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_community/config/themes/app_colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final bool isLoading;
  final double? width;
  final double? height;
  final double? borderRadius;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool isOutlined;
  final Color? borderColor;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.isLoading = false,
    this.width,
    this.height,
    this.borderRadius,
    this.prefixIcon,
    this.suffixIcon,
    this.isOutlined = false,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final defaultBg = backgroundColor ?? AppColors.maleColor;
    final defaultText = textColor ?? (isOutlined ? defaultBg : Colors.white);
    final radius = borderRadius ?? 12.r;

    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 50.h,
      child: isOutlined
          ? OutlinedButton(
              onPressed: isLoading ? null : onPressed,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: borderColor ?? defaultBg, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(radius),
                ),
              ),
              child: _buildChild(defaultText),
            )
          : ElevatedButton(
              onPressed: isLoading ? null : onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: defaultBg,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(radius),
                ),
              ),
              child: _buildChild(defaultText),
            ),
    );
  }

  Widget _buildChild(Color fontColor) {
    if (isLoading) {
      return SizedBox(
        width: 24.w,
        height: 24.w,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(fontColor),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (prefixIcon != null) ...[
          prefixIcon!,
          SizedBox(width: 8.w),
        ],
        Text(
          text,
          style: GoogleFonts.inter(
            color: fontColor,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (suffixIcon != null) ...[
          SizedBox(width: 8.w),
          suffixIcon!,
        ],
      ],
    );
  }
}
