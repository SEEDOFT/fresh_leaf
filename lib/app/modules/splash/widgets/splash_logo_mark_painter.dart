import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/splash/widgets/splash_leaf_painter.dart';

class SplashLogoMarkPainter extends CustomPainter {
  SplashLogoMarkPainter({required this.isDark, required this.scheme});
  final bool isDark;
  final ColorScheme scheme;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final bgPaint = Paint()
      ..shader = const RadialGradient(
        colors: [Color(0xFFF9FFF8), Color(0xFFEDF7E9)],
        stops: [0.2, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, w, h));
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), bgPaint);

    final leaf = SplashLeafPainter();
    canvas
      ..save()
      ..translate(w * 0.19, h * 0.19);
    leaf.paint(canvas, Size(w * 0.62, h * 0.62));
    canvas.restore();

    TextPainter(
        text: TextSpan(
          text: 'FL',
          style: TextStyle(
            fontFamily: 'NotoSansKhmer',
            fontWeight: FontWeight.w900,
            fontSize: 30,
            color: isDark ? scheme.onSurface : const Color(0xFF1B5E20),
            letterSpacing: -1.1,
          ),
        ),
        textDirection: TextDirection.ltr,
      )
      ..layout()
      ..paint(
        canvas,
        Offset(w * 0.32, h * 0.35),
      );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
