import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fresh_leaf/core/theme/app_colors.dart';
import 'package:fresh_leaf/app/routes/app_routes.dart';
import '../models/order.dart';

class OrdersHeader extends StatelessWidget {
  const OrdersHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          colors: [Color(0xFF2E5321), Color(0xFF1F3C16)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order History',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Track your baskets and reorder quickly.',
            style: TextStyle(
              color: Color(0xFFDAE7D0),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class OrdersFilterBar extends StatelessWidget {
  const OrdersFilterBar({
    super.key,
    required this.filters,
    required this.selected,
    required this.onChanged,
  });

  final List<String> filters;
  final String selected;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (context, index) {
          final filter = filters[index];
          final active = selected == filter;
          return GestureDetector(
            onTap: () => onChanged(filter),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOut,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
              decoration: BoxDecoration(
                color: active ? AppColors.darkGreen : Colors.white,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                  color: active ? AppColors.darkGreen : AppColors.grayBorder,
                ),
              ),
              child: Text(
                filter,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: active ? Colors.white : AppColors.textLight,
                ),
              ),
            ),
          );
        },
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemCount: filters.length,
      ),
    );
  }
}

class OrderItemWidget extends StatelessWidget {
  const OrderItemWidget({super.key, required this.order, this.onTap});

  final Order order;
  final VoidCallback? onTap;

  bool get _delivered => order.status == 'Delivered';

  @override
  Widget build(BuildContext context) {
    final badgeBg = _delivered
        ? AppColors.accentLime.withValues(alpha: 0.25)
        : AppColors.accentPeach.withValues(alpha: 0.35);
    final badgeText = _delivered
        ? AppColors.primaryDarkGreen
        : AppColors.accentBrown;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.grayBorder.withValues(alpha: 0.7),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 14,
              offset: const Offset(0, 7),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: badgeBg,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    order.status,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: badgeText,
                    ),
                  ),
                ),
                const Spacer(),
                const Icon(
                  Icons.receipt_long,
                  size: 16,
                  color: AppColors.textLight,
                ),
                const SizedBox(width: 4),
                Text(
                  order.id,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textLight,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              order.date,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textLight,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
            ..._buildItemPreview(),
            const SizedBox(height: 14),
            Row(
              children: [
                Text(
                  '\$${order.total.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryDarkGreen,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.cardLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    children: [
                      Text(
                        'View',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark,
                        ),
                      ),
                      SizedBox(width: 6),
                      Icon(
                        Icons.arrow_forward,
                        size: 14,
                        color: AppColors.textDark,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildItemPreview() {
    final previewCount = order.items.length > 2 ? 2 : order.items.length;
    final previewItems = order.items.take(previewCount);

    final rows = previewItems
        .map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              children: [
                Text(
                  '${item['quantity']}x',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    item['name'] as String? ?? '-',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textDark,
                    ),
                  ),
                ),
                Text(
                  '\$${((item['price'] as num?) ?? 0).toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textLight,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        )
        .toList();

    if (order.items.length > previewCount) {
      rows.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Text(
            '+${order.items.length - previewCount} more item(s)',
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textLight,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }
    return rows;
  }
}

class EmptyOrdersWidget extends StatelessWidget {
  const EmptyOrdersWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                color: AppColors.cardLight,
                borderRadius: BorderRadius.circular(28),
              ),
              child: const Icon(
                Icons.inventory_2_outlined,
                size: 48,
                color: AppColors.textLight,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'No orders yet',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Once you place your first basket, it will appear here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textLight,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Get.toNamed(AppRoutes.home),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                padding: const EdgeInsets.symmetric(
                  horizontal: 26,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Start Shopping',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OrdersLoadingWidget extends StatelessWidget {
  const OrdersLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryGreen),
          ),
          SizedBox(height: 10),
          Text(
            'Fetching your orders...',
            style: TextStyle(
              color: AppColors.textLight,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class OrdersListWidget extends StatelessWidget {
  const OrdersListWidget({
    super.key,
    required this.groupedOrders,
    this.onOrderTap,
  });

  final Map<String, List<Order>> groupedOrders;
  final ValueChanged<Order>? onOrderTap;

  @override
  Widget build(BuildContext context) {
    if (groupedOrders.isEmpty) {
      return const Center(
        child: Text(
          'No orders in this status',
          style: TextStyle(
            color: AppColors.textLight,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    final sectionKeys = groupedOrders.keys.toList();

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      itemCount: sectionKeys.length,
      itemBuilder: (context, sectionIndex) {
        final section = sectionKeys[sectionIndex];
        final sectionOrders = groupedOrders[section] ?? const <Order>[];

        return Padding(
          padding: EdgeInsets.only(
            bottom: sectionIndex == sectionKeys.length - 1 ? 0 : 14,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SectionHeader(title: section),
              const SizedBox(height: 10),
              ...sectionOrders.map(
                (order) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: OrderItemWidget(
                    order: order,
                    onTap: onOrderTap == null ? null : () => onOrderTap!(order),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(width: 10),
        const Expanded(
          child: Divider(
            thickness: 1,
            color: AppColors.grayBorder,
          ),
        ),
      ],
    );
  }
}
