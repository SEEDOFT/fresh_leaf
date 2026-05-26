import 'package:fresh_leaf/shared/helpers/helper.dart';

class MoneyDisplay {
  const MoneyDisplay({
    required this.usd,
    required this.khr,
  });

  factory MoneyDisplay.fromMap(dynamic value) {
    if (value is Map<String, dynamic>) {
      return MoneyDisplay(
        usd: toDouble(value['USD']),
        khr: toDouble(value['KHR']),
      );
    }

    if (value is Map) {
      final mapped = value.map<String, dynamic>(
        (dynamic key, dynamic item) => MapEntry<String, dynamic>(
          key.toString(),
          item,
        ),
      );
      return MoneyDisplay.fromMap(mapped);
    }

    return MoneyDisplay.empty;
  }

  factory MoneyDisplay.fromCurrencyAmount({
    required double amount,
    required int? currencyId,
  }) {
    return switch (currencyId) {
      khrCurrencyId => MoneyDisplay(usd: 0, khr: amount),
      _ => MoneyDisplay(usd: amount, khr: 0),
    };
  }

  static const int khrCurrencyId = 1;
  static const int usdCurrencyId = 2;

  static const MoneyDisplay empty = MoneyDisplay(usd: 0, khr: 0);

  final double usd;
  final double khr;

  bool get hasUsd => usd > 0;
  bool get hasKhr => khr > 0;
  bool get hasBoth => hasUsd && hasKhr;
  bool get isEmpty => !hasUsd && !hasKhr;

  String get usdText => '\$${formatPrice(usd)}';
  String get khrText => '${formatPriceNoDecimals(khr)} KHR';

  String get primaryText {
    if (hasUsd) return usdText;
    if (hasKhr) return khrText;
    return '\$${formatPrice(0)}';
  }

  String? get secondaryText {
    if (hasUsd && hasKhr) return khrText;
    return null;
  }

  String get combinedText {
    final secondary = secondaryText;
    if (secondary == null) return primaryText;
    return '$primaryText / $secondary';
  }

  String? get usdToKhrRateText {
    if (!hasBoth) return null;
    final rate = khr / usd;
    if (rate <= 0) return null;
    return '1 USD = ${formatPriceNoDecimals(rate)} KHR';
  }

  String? get khrToUsdRateText {
    if (!hasBoth) return null;
    final rate = usd / khr;
    if (rate <= 0) return null;
    return '1 KHR = \$${rate.toStringAsFixed(8)}';
  }

  MoneyDisplay multiply(double quantity) {
    return MoneyDisplay(
      usd: usd * quantity,
      khr: khr * quantity,
    );
  }

  MoneyDisplay subtract(MoneyDisplay other) {
    return MoneyDisplay(
      usd: usd - other.usd,
      khr: khr - other.khr,
    );
  }
}
