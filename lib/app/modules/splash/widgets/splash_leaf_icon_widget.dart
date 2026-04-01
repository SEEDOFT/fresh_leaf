import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/splash/widgets/splash_leaf_painter.dart';

class SplashLeafIconWidget extends StatelessWidget {
  const SplashLeafIconWidget({required this.size, super.key});

  final double size;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: SplashLeafPainter(),
    );
  }
}
