import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fresh_leaf/app/modules/profile/controllers/profile_wishlist_controller.dart';
import 'package:fresh_leaf/app/modules/profile/widgets/profile_widget.dart';
import 'package:fresh_leaf/app/modules/profile/widgets/profile_wishlist_widget.dart';

class ProfileWishlistView extends GetView<ProfileWishlistController> {
  const ProfileWishlistView({super.key});

  @override
  Widget build(BuildContext context) {
    final scaffoldBg = Theme.of(context).scaffoldBackgroundColor;
    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: ProfileAppBar(title: 'wishlist'.tr),
      body: Obx(() {
        if (controller.items.isEmpty) {
          return const WishlistEmptyWidget();
        }

        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
          itemCount: controller.items.length + 1,
          separatorBuilder: (_, _) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            if (index == 0) {
              return WishlistHeroCard(itemCount: controller.items.length);
            }

            final item = controller.items[index - 1];
            return WishlistItemCard(
              item: item,
              onRemove: () => controller.removeItem(item),
              onAddToCart: () => controller.addToCart(item),
            );
          },
        );
      }),
    );
  }
}
