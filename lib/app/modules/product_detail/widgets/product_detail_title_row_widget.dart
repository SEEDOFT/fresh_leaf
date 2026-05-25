import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/product_detail/controllers/product_detail_controller.dart';
import 'package:fresh_leaf/shared/helpers/helper.dart';
import 'package:get/get.dart';

class TitleRowWidget extends StatelessWidget {
  const TitleRowWidget({
    required this.title,
    required this.origin,
    required this.total,
    required this.controller,
    super.key,
  });

  final String title;
  final String origin;
  final double total;
  final ProductDetailController controller;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final currencySymbol = controller.product.currencySymbol ?? r'$';
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title.tr,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: scheme.onSurface,
                  height: 1.2,
                ),
              ),
              if (controller.hasDiscount) ...[
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: scheme.errorContainer,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '-${controller.discountPercentage.toStringAsFixed(0)}%',
                    style: TextStyle(
                      color: scheme.onErrorContainer,
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '$currencySymbol${formatPrice(total)}',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: scheme.primary,
              ),
            ),
            if (controller.hasDiscount)
              Text(
                '$currencySymbol'
                '${formatPrice(controller.originalPrice * controller.quantity.value)}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: scheme.onSurfaceVariant.withValues(alpha: 0.6),
                  decoration: TextDecoration.lineThrough,
                ),
              ),
          ],
        ),
      ],
    );
  }
}
