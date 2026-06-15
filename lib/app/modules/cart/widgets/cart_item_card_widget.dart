import 'package:flutter/material.dart';

import 'package:fresh_leaf/core/models/cart_item.dart';
import 'package:fresh_leaf/shared/helpers/responsive_helper.dart';
import 'package:fresh_leaf/shared/widgets/app_network_image.dart';
import 'package:fresh_leaf/shared/widgets/app_quantity_selector.dart';
import 'package:fresh_leaf/shared/widgets/money_amount_text.dart';

class CartItemCardWidget extends StatelessWidget {
  const CartItemCardWidget({
    required this.item,
    required this.onMinus,
    required this.onPlus,
    required this.onRemove,
    required this.onTap,
    super.key,
  });

  final CartItem item;
  final VoidCallback onMinus;
  final VoidCallback onPlus;
  final VoidCallback onRemove;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final itemTotal = item.subtotal;
    final itemTotalDisplay = item.resolvedSubtotalDisplay;
    final scheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
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
                    [
                      if (item.vendorInventory?.displaySubtitle.isNotEmpty ??
                          false)
                        item.vendorInventory!.displaySubtitle,
                      if (item.vendorInventory?.unitName?.isNotEmpty ?? false)
                        item.vendorInventory!.unitName!,
                    ].join(' • '),
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
                            MoneyAmountText(
                              amount: itemTotal,
                              display: itemTotalDisplay,
                              primaryStyle: TextStyle(
                                fontSize: 18.scaled,
                                fontWeight: FontWeight.w900,
                                color: scheme.primary,
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
      ),
    );
  }
}
