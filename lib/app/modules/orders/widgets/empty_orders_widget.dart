import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/routes/app_routes.dart';
import 'package:fresh_leaf/shared/widgets/app_empty_state.dart';
import 'package:get/get.dart';

class EmptyOrdersWidget extends StatelessWidget {
  const EmptyOrdersWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AppEmptyState(
      icon: Icons.inventory_2_outlined,
      title: 'no_orders_yet'.tr,
      subtitle: 'no_orders_subtitle'.tr,
      actionLabel: 'start_shopping'.tr,
      onActionPressed: () async => await Get.toNamed<void>(AppRoutes.home),
    );
  }
}
