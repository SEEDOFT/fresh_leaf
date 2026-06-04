import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:fresh_leaf/app/modules/orders/controllers/orders_controller.dart';
import 'package:fresh_leaf/core/constants/app_sizes.dart';
import 'package:get/get.dart';

/// Displays a summary of the user's active orders on the home
/// screen, with a tap action to navigate to the Orders tab.
class HomeActiveOrdersWidget extends StatelessWidget {
  const HomeActiveOrdersWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSizes.s24),
      child: Obx(() {
        final ordersController = Get.find<OrdersController>();
        final activeCount = ordersController.activeOrderCount;
        final totalOrders = ordersController.items.length;

        return GestureDetector(
          onTap: () {
            Get.find<DashboardController>().currentIndex = 3;
          },
          child: Container(
            padding: EdgeInsets.all(AppSizes.s20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [
                        scheme.primaryContainer,
                        scheme.primaryContainer.withValues(alpha: 0.7),
                      ]
                    : [
                        scheme.primary,
                        scheme.primary.withValues(alpha: 0.8),
                      ],
              ),
              borderRadius: BorderRadius.circular(AppSizes.s24),
              boxShadow: [
                BoxShadow(
                  color: scheme.primary.withValues(alpha: 0.25),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(AppSizes.s12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(AppSizes.s16),
                  ),
                  child: Icon(
                    Icons.local_shipping_rounded,
                    color: isDark ? scheme.onPrimaryContainer : Colors.white,
                    size: 28,
                  ),
                ),
                SizedBox(width: AppSizes.s16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        activeCount > 0
                            ? 'active_orders_title'.trParams({
                                'count': activeCount.toString(),
                              })
                            : 'no_active_orders'.tr,
                        style: TextStyle(
                          color: isDark
                              ? scheme.onPrimaryContainer
                              : Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                          height: 1.2,
                        ),
                      ),
                      SizedBox(height: AppSizes.s4),
                      Text(
                        activeCount > 0
                            ? 'tap_to_track'.tr
                            : 'total_orders_placed'.trParams({
                                'count': totalOrders.toString(),
                              }),
                        style: TextStyle(
                          color:
                              (isDark
                                      ? scheme.onPrimaryContainer
                                      : Colors.white)
                                  .withValues(alpha: 0.85),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: isDark ? scheme.onPrimaryContainer : Colors.white,
                  size: 24,
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
