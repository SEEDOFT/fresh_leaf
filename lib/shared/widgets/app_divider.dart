import 'package:flutter/material.dart';

class AppDivider extends StatelessWidget {
  const AppDivider({
    this.height = 1,
    this.thickness = 1,
    this.indent,
    this.endIndent,
    this.opacity = 0.35,
    super.key,
  });

  final double height;
  final double thickness;
  final double? indent;
  final double? endIndent;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Divider(
      height: height,
      thickness: thickness,
      indent: indent,
      endIndent: endIndent,
      color: scheme.outline.withValues(alpha: opacity),
    );
  }
}
