import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/orders/widgets/orders_item_widget.dart';
import 'package:fresh_leaf/app/modules/orders/widgets/orders_timeline_section_header_widget.dart';
import 'package:fresh_leaf/core/models/order.dart';
import 'package:get/get.dart';

class OrdersListWidget extends StatelessWidget {
  const OrdersListWidget({
    required this.groupedOrders,
    required this.scheme,
    required this.onLoadMore,
    required this.isLoadingMore,
    required this.hasMore,
    super.key,
    this.onOrderTap,
  });

  final Map<String, List<Order>> groupedOrders;
  final ColorScheme scheme;
  final VoidCallback onLoadMore;
  final RxBool isLoadingMore;
  final RxBool hasMore;
  final ValueChanged<Order>? onOrderTap;

  @override
  Widget build(BuildContext context) {
    final sectionKeys = groupedOrders.keys.toList();

    return NotificationListener<ScrollNotification>(
      onNotification: (scrollInfo) {
        if (!isLoadingMore.value &&
            hasMore.value &&
            scrollInfo.metrics.pixels >=
                scrollInfo.metrics.maxScrollExtent - 200) {
          onLoadMore();
        }
        return false;
      },
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        itemCount: sectionKeys.length + 1,
        itemBuilder: (context, sectionIndex) {
          if (sectionIndex == sectionKeys.length) {
            return Obx(() {
              if (isLoadingMore.value) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              return const SizedBox.shrink();
            });
          }

          final section = sectionKeys[sectionIndex];
          final sectionOrders = groupedOrders[section] ?? const <Order>[];

          return Padding(
            padding: EdgeInsets.only(
              bottom: sectionIndex == sectionKeys.length - 1 ? 0 : 14,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OrdersTimelineSectionHeaderWidget(
                  title: _translateSection(section),
                  scheme: scheme,
                ),
                const SizedBox(height: 10),
                ...sectionOrders.map(
                  (order) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: OrderItemWidget(
                      order: order,
                      scheme: scheme,
                      onTap: onOrderTap == null
                          ? null
                          : () => onOrderTap!(order),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _translateSection(String section) {
    switch (section) {
      case 'Today':
        return 'today'.tr;
      case 'This Week':
        return 'this_week'.tr;
      case 'This Month':
        return 'this_month'.tr;
      default:
        return 'earlier'.tr;
    }
  }
}
