import 'package:flutter/material.dart';
import 'package:fresh_leaf/shared/widgets/app_empty_state.dart';
import 'package:get/get.dart';

class WishlistEmptyWidget extends StatelessWidget {
  const WishlistEmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AppEmptyState(
      icon: Icons.favorite_border,
      title: 'wishlist_empty_title'.tr,
      subtitle: 'wishlist_empty_subtitle'.tr,
    );
  }
}
