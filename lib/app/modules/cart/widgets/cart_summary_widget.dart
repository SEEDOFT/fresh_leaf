import 'package:flutter/material.dart';
import 'package:fresh_leaf/core/theme/app_colors.dart';

class CartSummaryWidget extends StatelessWidget {
  const CartSummaryWidget({
    super.key,
    required this.subtotal,
    required this.deliveryFee,
    required this.total,
    required this.itemCount,
    required this.width,
    required this.onCheckout,
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
        border: Border.all(color: AppColors.grayBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
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
                  'Delivery in 25-35 min',
                  style: TextStyle(
                    fontSize: 12,
                    color: scheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Text(
                  '$itemCount item${itemCount == 1 ? '' : 's'}',
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
              'Subtotal',
              subtotal,
              textColor: scheme.onSurface,
              mutedColor: scheme.onSurfaceVariant,
            ),
            const SizedBox(height: 8),
            _summaryRow(
              'Delivery',
              deliveryFee,
              textColor: scheme.onSurface,
              mutedColor: scheme.onSurfaceVariant,
            ),
            const SizedBox(height: 8),
            _summaryRow(
              'Discount',
              -discount,
              textColor: scheme.onSurface,
              mutedColor: scheme.onSurfaceVariant,
              isDiscount: true,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(height: 1, color: AppColors.grayBorder),
            ),
            _summaryRow(
              'Total',
              grandTotal,
              textColor: scheme.onSurface,
              mutedColor: scheme.onSurfaceVariant,
              emphasize: true,
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: constraints.maxWidth,
              child: ElevatedButton.icon(
                onPressed: onCheckout,
                icon: const Icon(Icons.lock_rounded, size: 18),
                label: const Text(
                  'Proceed to Checkout',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
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
    bool emphasize = false,
    bool isDiscount = false,
  }) {
    final amountColor = emphasize
        ? AppColors.primaryDarkGreen
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
