import 'package:flutter/material.dart';

class SplashBlobWidget extends StatelessWidget {
  const SplashBlobWidget({
    required this.diameter,
    required this.color,
    super.key,
  });

  final double diameter;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
