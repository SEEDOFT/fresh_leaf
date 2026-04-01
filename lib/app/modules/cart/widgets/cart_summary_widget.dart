import 'package:flutter/material.dart';
import 'package:fresh_leaf/core/theme/app_colors.dart';
import 'package:get/get.dart';

class CartSummaryWidget extends StatelessWidget {
  const CartSummaryWidget({
    required this.subtotal,
    required this.deliveryFee,
    required this.total,
    required this.itemCount,
    required this.width,
    required this.onCheckout,
    super.key,
  });

  final double subtotal;
  final double deliveryFee;
  final double total;
  final int itemCount;
  final double width;
  final VoidCallback onCheckout;

  @override
  Widget build(BuildContext context) {
    final discount = subtotal >= 25 ? 2.00 : 0.0;
    final grandTotal = total - discount;
    final scheme = Theme.of(context).colorScheme;

    return Container(
      width: width,
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 12),
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: scheme.outline.withValues(alpha: 0.35)),
        boxShadow: [
          BoxShadow(
            color: scheme.shadow.withValues(alpha: 0.16),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) => Column(
          children: [
            Row(
              children: [
                const Icon(
                  Icons.local_shipping_outlined,
                  size: 18,
                  color: AppColors.accentBrown,
                ),
                const SizedBox(width: 6),
                Text(
                  'delivery_eta'.tr,
                  style: TextStyle(
                    fontSize: 12,
                    color: scheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Text(
                  (itemCount == 1 ? 'items_count_one' : 'items_count_other')
                      .trParams({'count': '$itemCount'}),
                  style: TextStyle(
                    fontSize: 12,
                    color: scheme.onSurfaceVariant,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _summaryRow(
              'subtotal'.tr,
              subtotal,
              textColor: scheme.onSurface,
              mutedColor: scheme.onSurfaceVariant,
              primaryColor: scheme.primary,
            ),
            const SizedBox(height: 8),
            _summaryRow(
              'delivery'.tr,
              deliveryFee,
              textColor: scheme.onSurface,
              mutedColor: scheme.onSurfaceVariant,
              primaryColor: scheme.primary,
            ),
            const SizedBox(height: 8),
            _summaryRow(
              'discount'.tr,
              -discount,
              textColor: scheme.onSurface,
              mutedColor: scheme.onSurfaceVariant,
              primaryColor: scheme.primary,
              isDiscount: true,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Divider(
                height: 1,
                color: scheme.outline.withValues(alpha: 0.35),
              ),
            ),
            _summaryRow(
              'total'.tr,
              grandTotal,
              textColor: scheme.onSurface,
              mutedColor: scheme.onSurfaceVariant,
              primaryColor: scheme.primary,
              emphasize: true,
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: constraints.maxWidth,
              child: ElevatedButton.icon(
                onPressed: onCheckout,
                icon: const Icon(Icons.lock_rounded, size: 18),
                label: Text(
                  'proceed_to_checkout'.tr,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: scheme.primary,
                  foregroundColor: scheme.onPrimary,
                  minimumSize: const Size(0, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryRow(
    String label,
    double amount, {
    required Color textColor,
    required Color mutedColor,
    required Color primaryColor,
    bool emphasize = false,
    bool isDiscount = false,
  }) {
    final amountColor = emphasize
        ? primaryColor
        : isDiscount
        ? AppColors.success
        : textColor;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: emphasize ? 16 : 14,
            fontWeight: emphasize ? FontWeight.w800 : FontWeight.w500,
            color: emphasize ? textColor : mutedColor,
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
