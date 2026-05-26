import 'package:flutter/material.dart';
import 'package:fresh_leaf/core/models/money_display.dart';
import 'package:fresh_leaf/shared/helpers/helper.dart';

class MoneyAmountText extends StatelessWidget {
  const MoneyAmountText({
    required this.amount,
    this.display,
    this.textAlign = TextAlign.end,
    this.primaryStyle,
    this.secondaryStyle,
    super.key,
  });

  final double amount;
  final MoneyDisplay? display;
  final TextAlign textAlign;
  final TextStyle? primaryStyle;
  final TextStyle? secondaryStyle;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final money = display;
    final prefix = amount < 0 ? '-' : '';
    final fallbackText = '\$${formatPrice(amount.abs())}';
    final primaryText = money == null || money.isEmpty
        ? '$prefix$fallbackText'
        : '$prefix${money.primaryText}';
    final rawSecondaryText = money?.secondaryText;
    final secondaryText = rawSecondaryText == null
        ? null
        : '$prefix$rawSecondaryText';

    if (secondaryText == null) {
      return Text(
        primaryText,
        textAlign: textAlign,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: primaryStyle,
      );
    }

    return Column(
      crossAxisAlignment: textAlign == TextAlign.start
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          primaryText,
          textAlign: textAlign,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: primaryStyle,
        ),
        Text(
          secondaryText,
          textAlign: textAlign,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style:
              secondaryStyle ??
              primaryStyle?.copyWith(
                color: scheme.onSurfaceVariant,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }
}
