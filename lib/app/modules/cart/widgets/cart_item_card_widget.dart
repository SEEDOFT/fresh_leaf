import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/cart/controllers/cart_controller.dart';
import 'package:fresh_leaf/shared/helpers/responsive_helper.dart';
import 'package:fresh_leaf/shared/widgets/app_network_image.dart';
import 'package:fresh_leaf/shared/widgets/app_quantity_selector.dart';
import 'package:get/get.dart';

class CartItemCardWidget extends StatelessWidget {
  const CartItemCardWidget({
    required this.item,
    required this.onMinus,
    required this.onPlus,
    required this.onRemove,
    super.key,
  });

  final CartItem item;
  final VoidCallback onMinus;
  final VoidCallback onPlus;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final itemTotal = item.price * item.quantity;
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.all(12.scaled),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(22.scaled),
        border: Border.all(color: scheme.outline.withValues(alpha: 0.35)),
        boxShadow: [
          BoxShadow(
            color: scheme.shadow.withValues(alpha: 0.15),
            blurRadius: 14.scaled,
            offset: Offset(0, 8.scaled),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppNetworkImage(
            url: item.imageUrl,
            width: 86.scaled,
            height: 86.scaled,
            borderRadius: BorderRadius.circular(16.scaled),
          ),
          SizedBox(width: 12.scaled),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16.scaled,
                          fontWeight: FontWeight.w800,
                          color: scheme.onSurface,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: onRemove,
                      splashRadius: 18.scaled,
                      icon: Icon(
                        Icons.close_rounded,
                        size: 20.scaled,
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.scaled),
                Text(
                  item.subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13.scaled,
                    color: scheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 10.scaled),
                Row(
                  children: [
                    AppQuantitySelector(
                      quantity: item.quantity,
                      onIncrement: onPlus,
                      onDecrement: onMinus,
                      borderRadius: 20.scaled,
                    ),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (item.originalPrice != null &&
                            item.originalPrice! > item.price)
                          Text(
                            '\$${(item.originalPrice! * item.quantity).toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 12.scaled,
                              decoration: TextDecoration.lineThrough,
                              color: scheme.onSurfaceVariant.withValues(
                                alpha: 0.6,
                              ),
                            ),
                          ),
                        Text(
                          '\$${itemTotal.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 18.scaled,
                            fontWeight: FontWeight.w900,
                            color: scheme.primary,
                          ),
                        ),
                        if (item.priceKhr != null)
                          Text(
                            '${(item.priceKhr! * item.quantity).toStringAsFixed(0)} ៛',
                            style: TextStyle(
                              fontSize: 12.scaled,
                              fontWeight: FontWeight.bold,
                              color: scheme.onSurfaceVariant,
                            ),
                          ),
                        Text(
                          '\$${item.price.toStringAsFixed(2)} ${'each'.tr}',
                          style: TextStyle(
                            fontSize: 10.scaled,
                            color: scheme.onSurfaceVariant.withValues(
                              alpha: 0.7,
                            ),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
