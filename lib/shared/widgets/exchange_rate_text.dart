import 'package:flutter/material.dart';
import 'package:fresh_leaf/core/models/money_display.dart';
import 'package:fresh_leaf/shared/helpers/helper.dart';

class ExchangeRateText extends StatelessWidget {
  const ExchangeRateText({
    required this.display,
    this.textAlign = TextAlign.end,
    super.key,
  });

  final MoneyDisplay display;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    final usd = display.usd;
    final khr = display.khr;
    if (usd <= 0 || khr <= 0) {
      return const SizedBox.shrink();
    }

    final rate = khr / usd;
    final scheme = Theme.of(context).colorScheme;

    return Text(
      '\$1 = ${formatPriceNoDecimals(rate)}៛',
      textAlign: textAlign,
      style: TextStyle(
        color: scheme.onSurfaceVariant,
        fontSize: 11,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
