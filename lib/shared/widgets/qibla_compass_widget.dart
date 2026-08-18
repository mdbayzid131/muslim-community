import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math' as math;

class QiblaCompassWidget extends StatelessWidget {
  final RxDouble dialRotation;
  final RxDouble needleRotation;
  final Color primaryColor;

  const QiblaCompassWidget({
    Key? key,
    required this.dialRotation,
    required this.needleRotation,
    required this.primaryColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // 1. Dynamic Outer Compass Face
        Obx(
          () => AnimatedRotation(
            turns: dialRotation.value,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            child: SizedBox(
              width: 250,
              height: 250,
              child: CustomPaint(
                painter: CompassDialPainter(primaryColor: primaryColor),
              ),
            ),
          ),
        ),

        // 2. The Dynamic Qibla Pointer
        Obx(
          () => AnimatedRotation(
            turns: needleRotation.value,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            child: SizedBox(
              width: 200,
              height: 200,
              child: CustomPaint(
                painter: CompassNeedlePainter(color: primaryColor),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class CompassDialPainter extends CustomPainter {
  final Color primaryColor;
  CompassDialPainter({required this.primaryColor});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;

    // Background color (deeper beige)
    final bgPaint = Paint()
      ..color = const Color(0xFFF5EDDC)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, bgPaint);

    // Outer thick ring (deeper tone)
    final outerRingPaint = Paint()
      ..color = const Color(0xFFE2D1B3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14;
    canvas.drawCircle(center, radius - 7, outerRingPaint);

    // Inner thin rings (deeper tone)
    final innerRingPaint = Paint()
      ..color = const Color(0xFFD1B78F)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawCircle(center, radius - 16, innerRingPaint);

    // Solid inner ring (replacing the dotted ring)
    final solidRingPaint = Paint()
      ..color = const Color(0xFFD1B78F)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawCircle(center, radius - 45, solidRingPaint);

    // N, E, S, W text
    _drawText(canvas, center, "N", Offset(0, -(radius - 28)), primaryColor);
    _drawText(canvas, center, "E", Offset(radius - 28, 0), Colors.grey[700]!);
    _drawText(canvas, center, "S", Offset(0, radius - 28), Colors.grey[700]!);
    _drawText(canvas, center, "W", Offset(-(radius - 28), 0), Colors.grey[700]!);
  }

  void _drawText(Canvas canvas, Offset center, String text, Offset position, Color color) {
    final textSpan = TextSpan(
      text: text,
      style: TextStyle(
        color: color,
        fontSize: 15,
        fontWeight: FontWeight.bold,
      ),
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(center.dx + position.dx - textPainter.width / 2,
             center.dy + position.dy - textPainter.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class CompassNeedlePainter extends CustomPainter {
  final Color color;
  CompassNeedlePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;

    // Draw the main needle (top half)
    final needlePaint = Paint()
      ..color = const Color(0xFFC19A4B)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(center.dx, center.dy - radius + 35); // Tip
    path.lineTo(center.dx + 4, center.dy);
    path.lineTo(center.dx - 4, center.dy);
    path.close();
    canvas.drawPath(path, needlePaint);

    // Draw the tail pointer (bottom half)
    final tailPaint = Paint()
      ..color = const Color(0xFFD1B78F)
      ..style = PaintingStyle.fill;
    final path2 = Path();
    path2.moveTo(center.dx, center.dy + radius - 40); // Tail
    path2.lineTo(center.dx + 2, center.dy);
    path2.lineTo(center.dx - 2, center.dy);
    path2.close();
    canvas.drawPath(path2, tailPaint);

    // Center circular outline
    final centerOutlinePaint = Paint()
      ..color = const Color(0xFFC19A4B)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    // Center circle
    final centerCirclePaint = Paint()
      ..color = const Color(0xFFF9FDF9)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 12, centerCirclePaint);
    canvas.drawCircle(center, 12, centerOutlinePaint);

    // Draw simple isometric Kaaba icon at the tip
    _drawKaaba(canvas, Offset(center.dx, center.dy - radius + 20));
  }

  void _drawKaaba(Canvas canvas, Offset topTip) {
    final blackPaint = Paint()..color = const Color(0xFF1A1A1A);
    final darkGrey = Paint()..color = const Color(0xFF333333);
    final goldPaint = Paint()..color = const Color(0xFFFFD700); 

    double w = 11; // width
    double h = 13; // height
    double dw = 9; // depth width
    double dh = 5; // depth height

    Offset base = Offset(topTip.dx, topTip.dy + 8);
    
    // Right Face (Dark Grey)
    final rightPath = Path()
      ..moveTo(base.dx, base.dy)
      ..lineTo(base.dx + w, base.dy - dh)
      ..lineTo(base.dx + w, base.dy - dh - h)
      ..lineTo(base.dx, base.dy - h)
      ..close();
    canvas.drawPath(rightPath, darkGrey);

    // Left Face (Black)
    final leftPath = Path()
      ..moveTo(base.dx, base.dy)
      ..lineTo(base.dx - w, base.dy - dh)
      ..lineTo(base.dx - w, base.dy - dh - h)
      ..lineTo(base.dx, base.dy - h)
      ..close();
    canvas.drawPath(leftPath, blackPaint);

    // Top Face (Darkest)
    final topPath = Path()
      ..moveTo(base.dx, base.dy - h)
      ..lineTo(base.dx + w, base.dy - h - dh)
      ..lineTo(base.dx, base.dy - h - dh * 2)
      ..lineTo(base.dx - w, base.dy - h - dh)
      ..close();
    canvas.drawPath(topPath, Paint()..color = const Color(0xFF111111));

    // Gold band on left face
    final leftBand = Path()
      ..moveTo(base.dx, base.dy - h + 3)
      ..lineTo(base.dx - w, base.dy - dh - h + 3)
      ..lineTo(base.dx - w, base.dy - dh - h + 5)
      ..lineTo(base.dx, base.dy - h + 5)
      ..close();
    canvas.drawPath(leftBand, goldPaint);

    // Gold band on right face
    final rightBand = Path()
      ..moveTo(base.dx, base.dy - h + 3)
      ..lineTo(base.dx + w, base.dy - dh - h + 3)
      ..lineTo(base.dx + w, base.dy - dh - h + 5)
      ..lineTo(base.dx, base.dy - h + 5)
      ..close();
    canvas.drawPath(rightBand, goldPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
