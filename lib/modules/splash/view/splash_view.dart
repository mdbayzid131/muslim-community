import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_community/config/constants/image_paths.dart';
import 'package:muslim_community/config/themes/app_colors.dart';
import 'package:muslim_community/modules/splash/controller/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. Background Gradient
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 1.3,
                  colors: [
                    Color(0xFFFFFDF9),
                    Color(0xFFF6EEDF),
                  ],
                ),
              ),
            ),
          ),

          // 2. Background Geometric Pattern
          Positioned.fill(
            child: FadeTransition(
              opacity: controller.bgPatternFade,
              child: AnimatedBuilder(
                animation: controller.rotationAngle,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: controller.rotationAngle.value,
                    child: child,
                  );
                },
                child: CustomPaint(
                  painter: IslamicPatternPainter(
                    color: AppColors.goldColor.withValues(alpha: 0.05),
                  ),
                ),
              ),
            ),
          ),

          // 3. Main Content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 24.h),

                    // Pulsing Logo
                    Center(
                      child: FadeTransition(
                        opacity: controller.logoFade,
                        child: ScaleTransition(
                          scale: controller.logoScale,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              AnimatedBuilder(
                                animation: controller.logoGlow,
                                builder: (context, child) {
                                  return Container(
                                    width: 170.w * controller.logoGlow.value,
                                    height: 170.w * controller.logoGlow.value,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(28.r),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.goldColor.withValues(
                                            alpha: 0.12 *
                                                (1.0 -
                                                    controller.logoGlow.value +
                                                    0.3),
                                          ),
                                          blurRadius: 30.r,
                                          spreadRadius: 10.r,
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                              Container(
                                width: 150.w,
                                height: 150.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24.r),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.goldColor.withValues(alpha: 0.15),
                                      blurRadius: 15.r,
                                      spreadRadius: 2.r,
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(24.r),
                                  child: Image.asset(
                                    ImagePaths.splashScreenLogo,
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Icon(
                                        Icons.mosque_outlined,
                                        color: AppColors.goldColor,
                                        size: 50.sp,
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 20.h),

                    // Title Text
                    AnimatedBuilder(
                      animation: controller.titleSlide,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, controller.titleSlide.value),
                          child: child,
                        );
                      },
                      child: FadeTransition(
                        opacity: controller.titleFade,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              'Sumayyah • Yasir • Ammar',
                              style: GoogleFonts.playfairDisplay(
                                fontSize: 22.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.titleColor,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 12.h),

                    // Quote Text
                    AnimatedBuilder(
                      animation: controller.quoteSlide,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, controller.quoteSlide.value),
                          child: child,
                        );
                      },
                      child: FadeTransition(
                        opacity: controller.quoteFade,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 40.w),
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: '"Honouring those who stood alone— \n',
                                  style: GoogleFonts.playfairDisplay(
                                    fontStyle: FontStyle.italic,
                                    fontSize: 16.sp,
                                    color: const Color(0xFF4A5568),
                                    height: 1.4,
                                  ),
                                ),
                                TextSpan(
                                  text: 'now a family for every revert"',
                                  style: GoogleFonts.playfairDisplay(
                                    fontStyle: FontStyle.italic,
                                    fontSize: 16.sp,
                                    color: AppColors.goldColor,
                                    fontWeight: FontWeight.w600,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 36.h),

                    // Loading Bar
                    FadeTransition(
                      opacity: controller.loadingFade,
                      child: Column(
                        children: [
                          AnimatedBuilder(
                            animation: controller.progressController,
                            builder: (context, child) {
                              return PremiumProgressBar(
                                progress: controller.progressController.value,
                                backgroundColor:
                                    AppColors.goldColor.withValues(alpha: 0.15),
                                progressColor: AppColors.goldColor,
                                width: 140.w,
                                height: 3.h,
                              );
                            },
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            'Connecting with the Ummah...',
                            style: GoogleFonts.inter(
                              fontSize: 11.sp,
                              color: const Color(0xFF718096),
                              letterSpacing: 0.8,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class IslamicPatternPainter extends CustomPainter {
  final Color color;

  IslamicPatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8
      ..isAntiAlias = true;

    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width * 0.7;

    canvas.drawCircle(center, maxRadius * 0.12, paint);
    canvas.drawCircle(center, maxRadius * 0.32, paint);
    canvas.drawCircle(center, maxRadius * 0.52, paint);
    canvas.drawCircle(center, maxRadius * 0.72, paint);
    canvas.drawCircle(center, maxRadius * 0.92, paint);

    _drawStar(canvas, center, maxRadius * 0.22, 8, paint, innerRatio: 0.707);
    _drawInterlockingSquares(canvas, center, maxRadius * 0.42, paint);
    _drawHexagonalStar(canvas, center, maxRadius * 0.62, paint);
    _drawTwelvePointedStar(canvas, center, maxRadius * 0.82, paint);
    _drawRadiatingLines(canvas, center, maxRadius * 0.92, 24, paint);
  }

  void _drawStar(Canvas canvas, Offset center, double radius, int points,
      Paint paint, {double innerRatio = 0.5}) {
    final path = Path();
    final totalPoints = points * 2;
    final angleStep = (2 * math.pi) / totalPoints;

    for (int i = 0; i < totalPoints; i++) {
      final currentAngle = i * angleStep;
      final currentRadius = (i % 2 == 0) ? radius : (radius * innerRatio);
      final x = center.dx + currentRadius * math.cos(currentAngle);
      final y = center.dy + currentRadius * math.sin(currentAngle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawInterlockingSquares(
      Canvas canvas, Offset center, double radius, Paint paint) {
    _drawRegularPolygon(canvas, center, radius, 4, paint, 0);
    _drawRegularPolygon(canvas, center, radius, 4, paint, math.pi / 4);
  }

  void _drawTwelvePointedStar(
      Canvas canvas, Offset center, double radius, Paint paint) {
    _drawRegularPolygon(canvas, center, radius, 4, paint, 0);
    _drawRegularPolygon(canvas, center, radius, 4, paint, math.pi / 6);
    _drawRegularPolygon(canvas, center, radius, 4, paint, math.pi / 3);
  }

  void _drawHexagonalStar(
      Canvas canvas, Offset center, double radius, Paint paint) {
    _drawRegularPolygon(canvas, center, radius, 3, paint, 0);
    _drawRegularPolygon(canvas, center, radius, 3, paint, math.pi);
  }

  void _drawRegularPolygon(Canvas canvas, Offset center, double radius,
      int sides, Paint paint, double startAngle) {
    final path = Path();
    final angleStep = (2 * math.pi) / sides;
    for (int i = 0; i < sides; i++) {
      final currentAngle = startAngle + i * angleStep;
      final x = center.dx + radius * math.cos(currentAngle);
      final y = center.dy + radius * math.sin(currentAngle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawRadiatingLines(
      Canvas canvas, Offset center, double radius, int count, Paint paint) {
    final angleStep = (2 * math.pi) / count;
    for (int i = 0; i < count; i++) {
      final angle = i * angleStep;
      final startRadius = radius * 0.72;
      final startX = center.dx + startRadius * math.cos(angle);
      final startY = center.dy + startRadius * math.sin(angle);
      final endX = center.dx + radius * math.cos(angle);
      final endY = center.dy + radius * math.sin(angle);
      canvas.drawLine(Offset(startX, startY), Offset(endX, endY), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class PremiumProgressBar extends StatelessWidget {
  final double progress;
  final Color backgroundColor;
  final Color progressColor;
  final double width;
  final double height;

  const PremiumProgressBar({
    super.key,
    required this.progress,
    required this.backgroundColor,
    required this.progressColor,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(height / 2),
      ),
      child: Stack(
        children: [
          FractionallySizedBox(
            widthFactor: progress,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    progressColor.withValues(alpha: 0.7),
                    progressColor,
                  ],
                ),
                borderRadius: BorderRadius.circular(height / 2),
                boxShadow: [
                  BoxShadow(
                    color: progressColor.withValues(alpha: 0.3),
                    blurRadius: 4.r,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
