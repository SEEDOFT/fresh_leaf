import 'package:flutter/material.dart';

class AppBadge extends StatelessWidget {
  const AppBadge({
    required this.label,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
    this.borderRadius = 12,
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    this.fontSize = 11,
    this.fontWeight = FontWeight.w700,
    super.key,
  });

  final String label;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final double fontSize;
  final FontWeight fontWeight;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bg = backgroundColor ?? scheme.primary.withValues(alpha: 0.12);
    final fg = foregroundColor ?? scheme.primary;

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: fontSize + 4, color: fg),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: TextStyle(
              color: fg,
              fontWeight: fontWeight,
              fontSize: fontSize,
            ),
          ),
        ],
      ),
    );
  }
}
