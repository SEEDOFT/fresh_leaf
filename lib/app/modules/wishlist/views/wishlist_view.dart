import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/wishlist/controllers/wishlist_controller.dart';
import 'package:fresh_leaf/app/modules/wishlist/widgets/wishlist_empty_state_widget.dart';
import 'package:fresh_leaf/app/routes/app_routes.dart';
import 'package:fresh_leaf/shared/helpers/responsive_helper.dart';
import 'package:fresh_leaf/shared/widgets/app_product_card.dart';
import 'package:get/get.dart';

class WishlistView extends GetView<WishlistController> {
  const WishlistView({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: scheme.surfaceContainerLow,
      appBar: AppBar(
        title: Text(
          'wishlist'.tr,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: scheme.surface,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading && controller.items.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.items.isEmpty) {
          return WishlistEmptyStateWidget(scheme: scheme);
        }

        return RefreshIndicator(
          onRefresh: controller.fetchWishlist,
          child: GridView.builder(
            padding: EdgeInsets.all(16.scaled),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: 16.scaled,
              mainAxisSpacing: 16.scaled,
            ),
            itemCount: controller.items.length,
            itemBuilder: (context, index) {
              final product = controller.items[index];
              return AppProductCard(
                title: product.title,
                imageUrl: product.imageUrl,
                price: product.price,
                subtitle: product.subtitle,
                isFavorite: true,
                onFavoriteTap: () => controller.toggleWishlist(product),
                onTap: () => Get.toNamed<void>(
                  AppRoutes.productDetail,
                  arguments: product,
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
