import 'package:flutter/material.dart';

class SplashLeafPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final leafPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF66BB6A), Color(0xFF2E7D32)],
      ).createShader(Rect.fromLTWH(0, 0, w, h))
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(w * 0.5, h * 0.08)
      ..cubicTo(w * 0.88, h * 0.08, w * 0.92, h * 0.5, w * 0.5, h * 0.88)
      ..cubicTo(w * 0.08, h * 0.5, w * 0.12, h * 0.08, w * 0.5, h * 0.08)
      ..close();

    canvas.drawPath(path, leafPaint);

    final veinPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.35)
      ..strokeWidth = w * 0.03
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      Offset(w * 0.5, h * 0.2),
      Offset(w * 0.5, h * 0.78),
      veinPaint,
    );

    final thinVein = Paint()
      ..color = Colors.white.withValues(alpha: .22)
      ..strokeWidth = w * 0.018
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    for (var i = 1; i <= 3; i++) {
      final t = 0.28 + i * 0.13;
      canvas
        ..drawLine(
          Offset(w * 0.5, h * t),
          Offset(w * (0.5 + 0.22), h * (t - 0.08)),
          thinVein,
        )
        ..drawLine(
          Offset(w * 0.5, h * t),
          Offset(w * (0.5 - 0.22), h * (t - 0.08)),
          thinVein,
        );
    }
  }

  @override
  bool shouldRepaint(_) => false;
}
