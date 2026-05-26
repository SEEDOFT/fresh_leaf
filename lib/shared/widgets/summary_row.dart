import 'package:flutter/material.dart';
import 'package:fresh_leaf/core/models/money_display.dart';
import 'package:fresh_leaf/core/theme/app_colors.dart';
import 'package:fresh_leaf/shared/widgets/money_amount_text.dart';

class SummaryRow extends StatelessWidget {
  const SummaryRow({
    required this.label,
    required this.amount,
    this.isDiscount = false,
    this.emphasize = false,
    this.textColor,
    this.mutedColor,
    this.primaryColor,
    this.amountDisplay,
    super.key,
  });

  final String label;
  final double amount;
  final bool isDiscount;
  final bool emphasize;
  final Color? textColor;
  final Color? mutedColor;
  final Color? primaryColor;
  final MoneyDisplay? amountDisplay;

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
        MoneyAmountText(
          amount: amount,
          display: amountDisplay,
          primaryStyle: TextStyle(
            fontSize: emphasize ? 19 : 15,
            fontWeight: FontWeight.w800,
            color: amountColor,
          ),
          secondaryStyle: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: baseMutedColor,
          ),
        ),
      ],
    );
  }
}
