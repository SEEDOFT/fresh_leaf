import 'package:flutter/material.dart';

import 'package:fresh_leaf/core/models/cart_item.dart';
import 'package:fresh_leaf/shared/helpers/helper.dart';
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
    final itemTotal = item.subtotal;
    final price = item.vendorInventory?.finalPrice ?? 0.0;
    final originalPrice = item.vendorInventory?.price ?? 0.0;
    final hasDiscount = (item.vendorInventory?.discountPercentage ?? 0) > 0;
    final currencySymbol = item.vendorInventory?.currencySymbol ?? r'$';
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
            url: item.vendorInventory?.displayImageUrl ?? '',
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
                        item.vendorInventory?.displayTitle ?? '',
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
                  item.vendorInventory?.displaySubtitle ?? '',
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
                      quantity: item.quantity.toInt(),
                      onIncrement: onPlus,
                      onDecrement: onMinus,
                      borderRadius: 20.scaled,
                    ),
                    SizedBox(width: 8.scaled),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerRight,
                            child: Text(
                              '$currencySymbol${formatPrice(itemTotal)}',
                              style: TextStyle(
                                fontSize: 18.scaled,
                                fontWeight: FontWeight.w900,
                                color: scheme.primary,
                              ),
                            ),
                          ),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerRight,
                            child: _buildUnitPrice(
                              price,
                              originalPrice,
                              currencySymbol,
                              hasDiscount,
                            ),
                          ),
                        ],
                      ),
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

  Widget _buildUnitPrice(
    double price,
    double originalPrice,
    String currencySymbol,
    bool hasDiscount,
  ) {
    final priceStr = formatPrice(price);
    final origPriceStr = formatPrice(originalPrice);

    return Builder(
      builder: (context) {
        final scheme = Theme.of(context).colorScheme;

        if (hasDiscount) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$currencySymbol$origPriceStr',
                style: TextStyle(
                  fontSize: 10.scaled,
                  color: scheme.onSurfaceVariant.withValues(alpha: 0.7),
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
              SizedBox(width: 4.scaled),
              Text(
                '$currencySymbol$priceStr ${'each'.tr}',
                style: TextStyle(
                  fontSize: 10.scaled,
                  color: scheme.error,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          );
        }

        return Text(
          '$currencySymbol$priceStr ${'each'.tr}',
          style: TextStyle(
            fontSize: 10.scaled,
            color: scheme.onSurfaceVariant.withValues(alpha: 0.7),
            fontWeight: FontWeight.w600,
          ),
        );
      },
    );
  }
}
