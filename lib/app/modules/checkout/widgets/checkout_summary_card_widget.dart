import 'package:flutter/material.dart';
import 'package:fresh_leaf/shared/widgets/app_card.dart';
import 'package:fresh_leaf/shared/widgets/primary_button.dart';
import 'package:fresh_leaf/shared/widgets/summary_row.dart';
import 'package:get/get.dart';

class CheckoutSummaryCardWidget extends StatelessWidget {
  const CheckoutSummaryCardWidget({
    required this.subtotal,
    required this.deliveryFee,
    required this.discount,
    required this.total,
    required this.isPlacingOrder,
    required this.onPlaceOrder,
    super.key,
  });

  final double subtotal;
  final double deliveryFee;
  final double discount;
  final double total;
  final bool isPlacingOrder;
  final VoidCallback onPlaceOrder;

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
          ),
          const SizedBox(height: 8),
          SummaryRow(
            label: 'delivery_fee'.tr,
            amount: deliveryFee,
          ),
          const SizedBox(height: 8),
          SummaryRow(
            label: 'discount'.tr,
            amount: -discount,
            isDiscount: true,
          ),
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
            emphasize: true,
          ),
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
