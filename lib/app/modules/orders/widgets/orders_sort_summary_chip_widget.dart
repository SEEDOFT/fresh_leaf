import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrdersSortSummaryChipWidget extends StatelessWidget {
  const OrdersSortSummaryChipWidget({
    required this.label,
    required this.scheme,
    super.key,
  });

  final String label;
  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: scheme.surfaceContainerHighest.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: scheme.outline.withValues(alpha: 0.16)),
        ),
        child: Text(
          '${'orders_sort'.tr}: $label',
          style: TextStyle(
            color: scheme.onSurfaceVariant,
            fontSize: 11.5,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
