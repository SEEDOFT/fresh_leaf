import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:fresh_leaf/app/routes/app_routes.dart';
import 'package:fresh_leaf/shared/widgets/app_empty_state.dart';
import 'package:get/get.dart';

class OrdersEmptyStateWidget extends StatelessWidget {
  const OrdersEmptyStateWidget({
    super.key,
    this.filtered = false,
  });

  final bool filtered;

  @override
  Widget build(BuildContext context) {
    return AppEmptyState(
      icon: Icons.inventory_2_outlined,
      title: filtered ? 'orders_filter_empty_title'.tr : 'no_orders_yet'.tr,
      subtitle: filtered
          ? 'orders_filter_empty_subtitle'.tr
          : 'no_orders_subtitle'.tr,
      actionLabel: filtered ? null : 'start_shopping'.tr,
      onActionPressed: filtered
          ? null
          : () {
              if (Get.isRegistered<DashboardController>()) {
                Get.find<DashboardController>().currentIndex = 0;
              } else {
                unawaited(
                  Get.offAllNamed<void>(AppRoutes.dashboard),
                );
              }
            },
    );
  }
}
