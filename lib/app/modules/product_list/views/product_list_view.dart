import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/cart/controllers/cart_controller.dart'
    as fresh_leaf_cart;
import 'package:fresh_leaf/app/modules/product_list/controllers/product_list_controller.dart';
import 'package:fresh_leaf/app/routes/app_routes.dart';
import 'package:fresh_leaf/core/controllers/wishlist_controller.dart';
import 'package:fresh_leaf/shared/widgets/app_product_card.dart';
import 'package:fresh_leaf/shared/widgets/custom_app_bar.dart';
import 'package:fresh_leaf/shared/widgets/paginated_list_view.dart';
import 'package:fresh_leaf/shared/widgets/skeleton_loading_widget.dart';
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
              ? const ProductGridSkeleton()
              : RefreshIndicator(
                  onRefresh: controller.refreshProducts,
                  child: LayoutBuilder(
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

                      return PaginatedGridView(
                        items: controller.products,
                        onLoadMore: controller.loadMore,
                        isLoadingMore: controller.isLoadingMore,
                        hasMore: controller.hasMore,
                        padding: const EdgeInsets.all(16),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          childAspectRatio: itemWidth / itemHeight,
                          crossAxisSpacing: spacing,
                          mainAxisSpacing: spacing,
                        ),
                        itemBuilder: (context, index, product) {
                          return Obx(
                            () => AppProductCard(
                              title: product.displayTitle.tr,
                              subtitle: product.displaySubtitle.tr,
                              imageUrl: product.displayImageUrl,
                              price: product.resolvedFinalPriceDisplay.usd > 0
                                  ? product.resolvedFinalPriceDisplay.usd
                                  : product.finalPrice,
                              originalPrice:
                                  product.resolvedPriceDisplay.usd > 0
                                  ? product.resolvedPriceDisplay.usd
                                  : product.price,
                              priceKhr: product.resolvedFinalPriceDisplay.hasKhr
                                  ? product.resolvedFinalPriceDisplay.khr
                                  : null,
                              currencySymbol: r'$',
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
                              onActionTap: () {
                                unawaited(
                                  Get.find<fresh_leaf_cart.CartController>()
                                      .addToCart(product.id, 1),
                                );
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
        ),
      ),
    );
  }
}
