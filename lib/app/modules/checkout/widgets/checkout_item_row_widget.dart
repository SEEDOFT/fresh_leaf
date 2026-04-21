import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/cart/controllers/cart_controller.dart';
import 'package:fresh_leaf/shared/widgets/app_network_image.dart';

class CheckoutItemRowWidget extends StatelessWidget {
  const CheckoutItemRowWidget({
    required this.item,
    super.key,
  });

  final CartItem item;

  @override
  Widget build(BuildContext context) {
    final total = item.price * item.quantity;
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: scheme.outline.withValues(alpha: 0.35)),
      ),
      child: Row(
        children: [
          AppNetworkImage(
            url: item.imageUrl,
            width: 52,
            height: 52,
            borderRadius: BorderRadius.circular(12),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: scheme.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${item.quantity} x \$${item.price.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '\$${total.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: scheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
