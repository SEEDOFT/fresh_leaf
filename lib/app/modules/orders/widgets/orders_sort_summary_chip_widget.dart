import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/orders/controllers/orders_controller.dart';
import 'package:get/get.dart';

class OrdersSortSummaryChipWidget extends StatelessWidget {
  const OrdersSortSummaryChipWidget({
    required this.label,
    required this.selectedSort,
    required this.onSortChanged,
    required this.scheme,
    super.key,
  });

  final String label;
  final OrderSortType selectedSort;
  final ValueChanged<OrderSortType> onSortChanged;
  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: PopupMenuButton<OrderSortType>(
        initialValue: selectedSort,
        onSelected: onSortChanged,
        position: PopupMenuPosition.under,
        itemBuilder: (context) => <PopupMenuEntry<OrderSortType>>[
          PopupMenuItem<OrderSortType>(
            value: OrderSortType.newest,
            child: Text('orders_sort_newest'.tr),
          ),
          PopupMenuItem<OrderSortType>(
            value: OrderSortType.oldest,
            child: Text('orders_sort_oldest'.tr),
          ),
          PopupMenuItem<OrderSortType>(
            value: OrderSortType.highestTotal,
            child: Text('orders_sort_highest_total'.tr),
          ),
        ],
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: scheme.surfaceContainerHighest.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: scheme.outline.withValues(alpha: 0.16)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${'orders_sort'.tr}: $label',
                style: TextStyle(
                  color: scheme.onSurfaceVariant,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.keyboard_arrow_down,
                size: 14,
                color: scheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
