import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fresh_leaf/core/theme/app_colors.dart';
import '../controllers/orders_controller.dart';

// Order Item Widget
class OrderItemWidget extends StatelessWidget {
  final Order order;
  final VoidCallback? onTap;

  const OrderItemWidget({super.key, required this.order, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order #${order.id}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                Text(
                  order.date,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textLight,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Order Items
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: order.items
                  .map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Text(
                            '${item['quantity']}x ',
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.textDark,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              item['name'] as String,
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.textDark,
                              ),
                            ),
                          ),
                          Text(
                            '\$${(item['price'] as double).toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.textDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 16),
            // Order Total and Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                Text(
                  '\$${order.total.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryGreen,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: order.status == 'Delivered'
                    ? AppColors.accentLime.withValues(alpha: 0.2)
                    : AppColors.accentPeach.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                order.status,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: order.status == 'Delivered'
                      ? AppColors.accentLime
                      : AppColors.accentPeach,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Empty Orders Widget
class EmptyOrdersWidget extends StatelessWidget {
  const EmptyOrdersWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.shopping_bag_outlined,
            size: 64,
            color: AppColors.textLight,
          ),
          const SizedBox(height: 16),
          const Text(
            'No orders yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Your order history will appear here',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textLight,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Get.toNamed('/home'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Start Shopping',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Orders Loading Widget
class OrdersLoadingWidget extends StatelessWidget {
  const OrdersLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryGreen),
      ),
    );
  }
}

// Orders List Widget
class OrdersListWidget extends StatelessWidget {
  final List<Order> orders;
  final ValueChanged<Order>? onOrderTap;

  const OrdersListWidget({super.key, required this.orders, this.onOrderTap});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (context, index) {
        return OrderItemWidget(
          order: orders[index],
          onTap: () {
            if (onOrderTap != null) {
              onOrderTap!(orders[index]);
            }
          },
        );
      },
    );
  }
}
