import 'package:flutter/material.dart';

class OrdersTimelineSectionHeaderWidget extends StatelessWidget {
  const OrdersTimelineSectionHeaderWidget({
    required this.title,
    required this.scheme,
    super.key,
  });

  final String title;
  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 9,
          height: 9,
          decoration: BoxDecoration(
            color: scheme.primary,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            color: scheme.onSurface,
            fontSize: 13,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Container(
            height: 1,
            color: scheme.outline.withValues(alpha: 0.18),
          ),
        ),
      ],
    );
  }
}
