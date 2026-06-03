import 'package:flutter/material.dart';
import 'package:fresh_leaf/core/models/money_display.dart';
import 'package:fresh_leaf/shared/widgets/app_card.dart';
import 'package:fresh_leaf/shared/widgets/exchange_rate_text.dart';
import 'package:fresh_leaf/shared/widgets/primary_button.dart';
import 'package:fresh_leaf/shared/widgets/summary_row.dart';
import 'package:get/get.dart';

class CheckoutSummaryCardWidget extends StatelessWidget {
  const CheckoutSummaryCardWidget({
    required this.subtotal,
    required this.discount,
    required this.total,
    required this.isPlacingOrder,
    required this.onPlaceOrder,
    required this.subtotalDisplay,
    required this.discountDisplay,
    required this.totalDisplay,
    this.showCurrencySelection = false,
    this.selectedPaymentCurrencyId = 2,
    this.onCurrencySelected,
    super.key,
  });

  final double subtotal;
  final double discount;
  final double total;
  final bool isPlacingOrder;
  final VoidCallback onPlaceOrder;
  final MoneyDisplay subtotalDisplay;
  final MoneyDisplay discountDisplay;
  final MoneyDisplay totalDisplay;
  final bool showCurrencySelection;
  final int selectedPaymentCurrencyId;
  final ValueChanged<int>? onCurrencySelected;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final scheme = Theme.of(context).colorScheme;

    return AppCard(
      width: screenWidth - 32,
      child: Column(
        children: [
          SummaryRow(
            label: 'subtotal'.tr,
            amount: subtotal,
            amountDisplay: subtotalDisplay,
          ),
          if (discount > 0) ...[
            const SizedBox(height: 8),
            SummaryRow(
              label: 'discount'.tr,
              amount: -discount,
              amountDisplay: discountDisplay,
              isDiscount: true,
            ),
          ],
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Divider(
              height: 1,
              color: scheme.outline.withValues(alpha: 0.35),
            ),
          ),
          SummaryRow(
            label: 'total'.tr,
            amount: total,
            amountDisplay: totalDisplay,
            emphasize: true,
          ),
          const SizedBox(height: 6),
          ExchangeRateText(display: totalDisplay),
          if (showCurrencySelection) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: SegmentedButton<int>(
                segments: const [
                  ButtonSegment<int>(
                    value: MoneyDisplay.usdCurrencyId,
                    label: Text('Pay in USD'),
                  ),
                  ButtonSegment<int>(
                    value: MoneyDisplay.khrCurrencyId,
                    label: Text('Pay in KHR'),
                  ),
                ],
                selected: {selectedPaymentCurrencyId},
                onSelectionChanged: (newSelection) {
                  onCurrencySelected?.call(newSelection.first);
                },
              ),
            ),
          ],
          const SizedBox(height: 14),
          PrimaryButton(
            label: 'place_order'.tr,
            onPressed: onPlaceOrder,
            isLoading: isPlacingOrder,
            width: screenWidth - 64,
            borderRadius: 16,
          ),
        ],
      ),
    );
  }
}
