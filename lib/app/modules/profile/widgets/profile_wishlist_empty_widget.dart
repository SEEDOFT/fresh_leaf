import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:fresh_leaf/app/routes/app_routes.dart';
import 'package:fresh_leaf/shared/widgets/app_empty_state.dart';
import 'package:get/get.dart';

class WishlistEmptyWidget extends StatelessWidget {
  const WishlistEmptyWidget({
    super.key,
    this.title,
    this.subtitle,
    this.showAction = true,
  });

  final String? title;
  final String? subtitle;
  final bool showAction;

  @override
  Widget build(BuildContext context) {
    return AppEmptyState(
      icon: Icons.favorite_border,
      title: title ?? 'wishlist_empty_title'.tr,
      subtitle: subtitle ?? 'wishlist_empty_subtitle'.tr,
      actionLabel: showAction ? 'start_shopping'.tr : null,
      onActionPressed: showAction
          ? () {
              if (Get.isRegistered<DashboardController>()) {
                Get.find<DashboardController>().currentIndex = 0;
                Get.back<void>();
              } else {
                unawaited(Get.offAllNamed<void>(AppRoutes.dashboard));
              }
            }
          : null,
    );
  }
}
