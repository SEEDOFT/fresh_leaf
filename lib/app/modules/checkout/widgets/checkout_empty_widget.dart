import 'package:flutter/material.dart';
import 'package:fresh_leaf/shared/widgets/app_empty_state.dart';
import 'package:get/get.dart';

class CheckoutEmptyWidget extends StatelessWidget {
  const CheckoutEmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AppEmptyState(
      icon: Icons.shopping_bag_outlined,
      title: 'nothing_to_checkout'.tr,
      subtitle: 'checkout_empty_subtitle'.tr,
      actionLabel: 'back_to_cart'.tr,
      onActionPressed: Get.back<void>,
    );
  }
}
