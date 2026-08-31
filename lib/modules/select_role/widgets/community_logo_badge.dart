import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:muslim_community/config/themes/app_colors.dart';

enum CommunityLogoType { brother, sister, jumma }

class CommunityLogoBadge extends StatelessWidget {
  final CommunityLogoType type;
  final double size;

  const CommunityLogoBadge({super.key, required this.type, this.size = 85.0});

  @override
  Widget build(BuildContext context) {
    final Color themeColor = switch (type) {
      CommunityLogoType.brother => AppColors.maleColor,
      CommunityLogoType.sister => AppColors.femaleColor,
      CommunityLogoType.jumma => AppColors.jummaColor,
    };

    final double badgeSize = size.w;

    return Container(
      width: badgeSize,
      height: badgeSize,
      decoration: BoxDecoration(
        color: themeColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: themeColor.withValues(alpha: 0.35),
            blurRadius: 18.r,
            spreadRadius: 2.r,
            offset: Offset(0, 6.h),
          ),
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.6),
            blurRadius: 10.r,
            offset: Offset(-2.w, -2.h),
          ),
        ],
      ),
      child: Center(
        child: SizedBox(
          width: badgeSize * 0.62,
          height: badgeSize * 0.62,
          child: CustomPaint(
            painter: switch (type) {
              CommunityLogoType.brother => ExactMosqueLogoPainter(),
              CommunityLogoType.sister => ExactSisterLogoPainter(),
              CommunityLogoType.jumma => ExactMosqueLogoPainter(),
            },
          ),
        ),
      ),
    );
  }
}

class ExactMosqueLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final whitePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final w = size.width;
    final h = size.height;

    final minaretCap = Path();
    minaretCap.moveTo(w * 0.08, h * 0.40);
    minaretCap.lineTo(w * 0.32, h * 0.40);
    minaretCap.lineTo(w * 0.32, h * 0.32);
    minaretCap.cubicTo(
      w * 0.32,
      h * 0.20,
      w * 0.20,
      h * 0.12,
      w * 0.20,
      h * 0.12,
    );
    minaretCap.cubicTo(
      w * 0.20,
      h * 0.12,
      w * 0.08,
      h * 0.20,
      w * 0.08,
      h * 0.32,
    );
    minaretCap.close();

    final minaretBody = Path()
      ..addRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTRB(w * 0.08, h * 0.44, w * 0.32, h * 0.85),
          bottomLeft: Radius.circular(w * 0.08),
          bottomRight: Radius.circular(w * 0.02),
          topLeft: Radius.circular(w * 0.02),
        ),
      );

    final domePath = Path();
    domePath.moveTo(w * 0.30, h * 0.62);
    domePath.cubicTo(
      w * 0.28,
      h * 0.46,
      w * 0.35,
      h * 0.30,
      w * 0.63,
      h * 0.22,
    );
    domePath.cubicTo(
      w * 0.91,
      h * 0.30,
      w * 0.98,
      h * 0.46,
      w * 0.95,
      h * 0.62,
    );
    domePath.close();

    final baseRRect = RRect.fromRectAndCorners(
      Rect.fromLTRB(w * 0.30, h * 0.58, w * 0.95, h * 0.85),
      bottomRight: Radius.circular(w * 0.08),
      bottomLeft: Radius.circular(w * 0.08),
      topRight: Radius.circular(w * 0.04),
    );

    Path fullMosquePath = Path();
    fullMosquePath = Path.combine(PathOperation.union, minaretCap, minaretBody);
    fullMosquePath = Path.combine(
      PathOperation.union,
      fullMosquePath,
      domePath,
    );
    fullMosquePath = Path.combine(
      PathOperation.union,
      fullMosquePath,
      Path()..addRRect(baseRRect),
    );

    final leftArch = Path();
    leftArch.moveTo(w * 0.42, h * 0.85);
    leftArch.lineTo(w * 0.42, h * 0.72);
    leftArch.arcToPoint(
      Offset(w * 0.50, h * 0.72),
      radius: Radius.circular(w * 0.04),
    );
    leftArch.lineTo(w * 0.50, h * 0.85);
    leftArch.close();

    final centerArch = Path();
    centerArch.moveTo(w * 0.57, h * 0.85);
    centerArch.lineTo(w * 0.57, h * 0.69);
    centerArch.cubicTo(
      w * 0.57,
      h * 0.64,
      w * 0.63,
      h * 0.61,
      w * 0.63,
      h * 0.61,
    );
    centerArch.cubicTo(
      w * 0.63,
      h * 0.61,
      w * 0.69,
      h * 0.64,
      w * 0.69,
      h * 0.69,
    );
    centerArch.lineTo(w * 0.69, h * 0.85);
    centerArch.close();

    final rightArch = Path();
    rightArch.moveTo(w * 0.76, h * 0.85);
    rightArch.lineTo(w * 0.76, h * 0.72);
    rightArch.arcToPoint(
      Offset(w * 0.84, h * 0.72),
      radius: Radius.circular(w * 0.04),
    );
    rightArch.lineTo(w * 0.84, h * 0.85);
    rightArch.close();

    fullMosquePath = Path.combine(
      PathOperation.difference,
      fullMosquePath,
      leftArch,
    );
    fullMosquePath = Path.combine(
      PathOperation.difference,
      fullMosquePath,
      centerArch,
    );
    fullMosquePath = Path.combine(
      PathOperation.difference,
      fullMosquePath,
      rightArch,
    );

    canvas.drawPath(fullMosquePath, whitePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class ExactSisterLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final whitePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final w = size.width;
    final h = size.height;

    final outerMoon = Path()
      ..addOval(
        Rect.fromCircle(center: Offset(w * 0.48, h * 0.50), radius: w * 0.44),
      );

    final innerMoon = Path()
      ..addOval(
        Rect.fromCircle(center: Offset(w * 0.62, h * 0.44), radius: w * 0.36),
      );

    final crescentPath = Path.combine(
      PathOperation.difference,
      outerMoon,
      innerMoon,
    );

    canvas.drawPath(crescentPath, whitePaint);

    final starPath = _createStarPath(
      centerX: w * 0.68,
      centerY: h * 0.42,
      outerRadius: w * 0.16,
      innerRadius: w * 0.07,
    );

    canvas.drawPath(starPath, whitePaint);
  }

  Path _createStarPath({
    required double centerX,
    required double centerY,
    required double outerRadius,
    required double innerRadius,
  }) {
    final path = Path();
    final double step = pi / 5;
    double angle = -pi / 2;

    path.moveTo(
      centerX + outerRadius * cos(angle),
      centerY + outerRadius * sin(angle),
    );

    for (int i = 0; i < 5; i++) {
      angle += step;
      path.lineTo(
        centerX + innerRadius * cos(angle),
        centerY + innerRadius * sin(angle),
      );
      angle += step;
      path.lineTo(
        centerX + outerRadius * cos(angle),
        centerY + outerRadius * sin(angle),
      );
    }
    path.close();
    return path;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
