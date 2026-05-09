import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/product_list/controllers/product_list_controller.dart';
import 'package:fresh_leaf/app/routes/app_routes.dart';
import 'package:fresh_leaf/core/controllers/wishlist_controller.dart';
import 'package:fresh_leaf/shared/widgets/app_product_card.dart';
import 'package:fresh_leaf/shared/widgets/custom_app_bar.dart';
import 'package:get/get.dart';

class ProductListView extends GetView<ProductListController> {
  const ProductListView({super.key});

  @override
  Widget build(BuildContext context) {
    final scaffoldBg = Theme.of(context).scaffoldBackgroundColor;
    final wishlistController = Get.find<WishlistController>();

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: CustomAppBar(title: 'all_products'.tr),
      body: SafeArea(
        child: Obx(
          () => controller.isLoading.value
              ? const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                  ),
                )
              : LayoutBuilder(
                  builder: (context, constraints) {
                    final screenWidth = MediaQuery.of(context).size.width;

                    final int crossAxisCount;
                    final double itemHeight;
                    if (screenWidth < 360) {
                      crossAxisCount = 1;
                      itemHeight = 260;
                    } else if (screenWidth < 700) {
                      crossAxisCount = 2;
                      itemHeight = 285;
                    } else if (screenWidth < 1024) {
                      crossAxisCount = 3;
                      itemHeight = 305;
                    } else {
                      crossAxisCount = 4;
                      itemHeight = 320;
                    }

                    const double spacing = 16;
                    const double horizontalPadding = 32; // 16 + 16
                    final itemWidth =
                        (constraints.maxWidth -
                            horizontalPadding -
                            (crossAxisCount - 1) * spacing) /
                        crossAxisCount;

                    return GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        childAspectRatio: itemWidth / itemHeight,
                        crossAxisSpacing: spacing,
                        mainAxisSpacing: spacing,
                      ),
                      itemCount: controller.products.length,
                      itemBuilder: (context, index) {
                        final product = controller.products[index];
                        return Obx(
                          () => AppProductCard(
                            title: product.title.tr,
                            subtitle: product.subtitle.tr,
                            imageUrl: product.imageUrl,
                            price: product.price,
                            isFavorite: wishlistController.isFavorite(
                              product.id,
                            ),
                            onFavoriteTap: () =>
                                wishlistController.toggleWishlist(product),
                            onTap: () async {
                              await Get.toNamed<void>(
                                AppRoutes.productDetail,
                                arguments: product,
                              );
                            },
                            onActionTap: () {},
                          ),
                        );
                      },
                    );
                  },
                ),
        ),
      ),
    );
  }
}
