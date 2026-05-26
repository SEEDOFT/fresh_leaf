import 'package:flutter/material.dart';
import 'package:fresh_leaf/core/models/money_display.dart';
import 'package:fresh_leaf/shared/widgets/app_card.dart';
import 'package:fresh_leaf/shared/widgets/exchange_rate_text.dart';
import 'package:fresh_leaf/shared/widgets/primary_button.dart';
import 'package:fresh_leaf/shared/widgets/summary_row.dart';
import 'package:get/get.dart';

class CartSummaryWidget extends StatelessWidget {
  const CartSummaryWidget({
    required this.subtotal,
    required this.total,
    required this.itemCount,
    required this.width,
    required this.onCheckout,
    required this.subtotalDisplay,
    required this.totalDisplay,
    super.key,
  });

  final double subtotal;
  final double total;
  final int itemCount;
  final double width;
  final VoidCallback onCheckout;
  final MoneyDisplay subtotalDisplay;
  final MoneyDisplay totalDisplay;

  @override
  Widget build(BuildContext context) {
    const discount = 0.0;
    final grandTotal = total - discount;
    final scheme = Theme.of(context).colorScheme;

    return AppCard(
      width: width,
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 12),
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
      borderRadius: 24,
      showShadow: true,
      child: LayoutBuilder(
        builder: (context, constraints) => Column(
          children: [
            Row(
              children: [
                // const Icon(
                //   Icons.local_shipping_outlined,
                //   size: 18,
                //   color: AppColors.accentBrown,
                // ),
                // const SizedBox(width: 6),
                // Text(
                //   'delivery_eta'.tr,
                //   style: TextStyle(
                //     fontSize: 12,
                //     color: scheme.onSurfaceVariant,
                //     fontWeight: FontWeight.w600,
                //   ),
                // ),
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
              amount: grandTotal,
              amountDisplay: totalDisplay,
              emphasize: true,
            ),
            const SizedBox(height: 6),
            ExchangeRateText(display: totalDisplay),
            const SizedBox(height: 14),
            PrimaryButton(
              label: 'proceed_to_checkout'.tr,
              onPressed: onCheckout,
              icon: Icons.lock_rounded,
              width: constraints.maxWidth,
              height: 50,
              borderRadius: 16,
            ),
          ],
        ),
      ),
    );
  }
}
