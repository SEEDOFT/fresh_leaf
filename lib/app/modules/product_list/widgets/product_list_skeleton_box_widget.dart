import 'package:flutter/material.dart';

class ProductListSkeletonBoxWidget extends StatelessWidget {
  const ProductListSkeletonBoxWidget({
    required this.width,
    required this.borderRadius,
    required this.color,
    super.key,
    this.child,
  });

  final double width;
  final BorderRadius borderRadius;
  final Color color;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: color,
        borderRadius: borderRadius,
      ),
      child: child == null ? null : Center(child: child),
    );
  }
}
