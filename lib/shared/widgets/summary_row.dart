import 'package:flutter/material.dart';
import 'package:fresh_leaf/core/theme/app_colors.dart';

class SummaryRow extends StatelessWidget {
  const SummaryRow({
    required this.label,
    required this.amount,
    this.isDiscount = false,
    this.emphasize = false,
    this.textColor,
    this.mutedColor,
    this.primaryColor,
    super.key,
  });

  final String label;
  final double amount;
  final bool isDiscount;
  final bool emphasize;
  final Color? textColor;
  final Color? mutedColor;
  final Color? primaryColor;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final baseTextColor = textColor ?? scheme.onSurface;
    final baseMutedColor = mutedColor ?? scheme.onSurfaceVariant;
    final basePrimaryColor = primaryColor ?? scheme.primary;

    final amountColor = emphasize
        ? basePrimaryColor
        : isDiscount
            ? AppColors.success
            : baseTextColor;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: emphasize ? 16 : 14,
            fontWeight: emphasize ? FontWeight.w800 : FontWeight.w500,
            color: emphasize ? baseTextColor : baseMutedColor,
          ),
        ),
        Text(
          '${amount < 0 ? '-' : ''}\$${amount.abs().toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: emphasize ? 19 : 15,
            fontWeight: FontWeight.w800,
            color: amountColor,
          ),
        ),
      ],
    );
  }
}
