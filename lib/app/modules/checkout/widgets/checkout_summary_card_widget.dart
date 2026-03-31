import 'package:flutter/material.dart';
import 'package:fresh_leaf/core/theme/app_colors.dart';
import 'package:get/get.dart';

class CheckoutSummaryCardWidget extends StatelessWidget {
  const CheckoutSummaryCardWidget({
    super.key,
    required this.subtotal,
    required this.deliveryFee,
    required this.discount,
    required this.total,
    required this.isPlacingOrder,
    required this.onPlaceOrder,
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

    return Container(
      width: screenWidth - 32,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: scheme.outline.withValues(alpha: 0.35)),
      ),
      child: Column(
        children: [
          _row(
            'subtotal'.tr,
            subtotal,
            textColor: scheme.onSurface,
            mutedColor: scheme.onSurfaceVariant,
          ),
          const SizedBox(height: 8),
          _row(
            'delivery_fee'.tr,
            deliveryFee,
            textColor: scheme.onSurface,
            mutedColor: scheme.onSurfaceVariant,
          ),
          const SizedBox(height: 8),
          _row(
            'discount'.tr,
            -discount,
            textColor: scheme.onSurface,
            mutedColor: scheme.onSurfaceVariant,
            highlight: true,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1, color: scheme.outline.withValues(alpha: 0.35)),
          ),
          _row(
            'total'.tr,
            total,
            textColor: scheme.onSurface,
            mutedColor: scheme.onSurfaceVariant,
            large: true,
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: screenWidth - 64,
            child: ElevatedButton(
              onPressed: isPlacingOrder ? null : onPlaceOrder,
              style: ElevatedButton.styleFrom(
                backgroundColor: scheme.primary,
                foregroundColor: scheme.onPrimary,
                minimumSize: const Size(0, 52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: isPlacingOrder
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: scheme.onPrimary,
                      ),
                    )
                  : Text(
                      'place_order'.tr,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(
    String label,
    double amount, {
    required Color textColor,
    required Color mutedColor,
    bool large = false,
    bool highlight = false,
  }) {
    final amountText =
        '${amount < 0 ? '-' : ''}\$${amount.abs().toStringAsFixed(2)}';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: large ? textColor : mutedColor,
            fontSize: large ? 16 : 13,
            fontWeight: large ? FontWeight.w800 : FontWeight.w600,
          ),
        ),
        Text(
          amountText,
          style: TextStyle(
            color: large
                ? textColor
                : highlight
                ? AppColors.success
                : textColor,
            fontSize: large ? 20 : 14,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}
