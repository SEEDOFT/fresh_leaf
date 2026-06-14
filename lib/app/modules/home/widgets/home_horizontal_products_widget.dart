import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/cart/controllers/cart_controller.dart';
import 'package:fresh_leaf/app/modules/home/controllers/home_controller.dart';
import 'package:fresh_leaf/app/routes/app_routes.dart';
import 'package:fresh_leaf/core/constants/app_sizes.dart';
import 'package:fresh_leaf/core/controllers/wishlist_controller.dart';
import 'package:fresh_leaf/core/models/vendor_inventory.dart';
import 'package:fresh_leaf/shared/widgets/app_product_card.dart';
import 'package:get/get.dart';

class HomeHorizontalProductsWidget extends GetView<HomeController> {
  const HomeHorizontalProductsWidget({
    required this.pickedThisMorning,
    super.key,
  });

  final List<VendorInventory> pickedThisMorning;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final wishlistController = Get.find<WishlistController>();

    if (pickedThisMorning.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSizes.s24),
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(
            horizontal: AppSizes.s20,
            vertical: AppSizes.s24,
          ),
          decoration: BoxDecoration(
            color: scheme.surface,
            borderRadius: BorderRadius.circular(AppSizes.s20),
          ),
          child: Column(
            children: [
              Icon(
                Icons.search_off_outlined,
                color: scheme.onSurfaceVariant,
              ),
              SizedBox(height: AppSizes.s10),
              Text(
                'no_matching_products'.tr,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: scheme.onSurface,
                ),
              ),
              SizedBox(height: AppSizes.s4),
              Text(
                'try_another_keyword_short'.tr,
                style: TextStyle(
                  fontSize: AppSizes.s12,
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SizedBox(
      height: AppSizes.s320,
      child: NotificationListener<ScrollNotification>(
        onNotification: (scrollInfo) {
          if (scrollInfo.metrics.pixels >=
              scrollInfo.metrics.maxScrollExtent - 200) {
            unawaited(controller.loadMoreProducts());
          }
          return false;
        },
        child: ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: AppSizes.s24),
          scrollDirection: Axis.horizontal,
          itemCount: pickedThisMorning.length + 1,
          separatorBuilder: (_, _) => SizedBox(width: AppSizes.s16),
          itemBuilder: (context, index) {
            if (index == pickedThisMorning.length) {
              return Obx(() {
                if (controller.isPaginating.value) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                return const SizedBox.shrink();
              });
            }

            final item = pickedThisMorning[index];

            return SizedBox(
              width: AppSizes.s200,
              child: Obx(
                () => AppProductCard(
                  title: item.displayTitle.tr,
                  subtitle: item.displaySubtitle.tr,
                  imageUrl: item.displayImageUrl,
                  price: item.resolvedFinalPriceDisplay.usd > 0
                      ? item.resolvedFinalPriceDisplay.usd
                      : item.finalPrice,
                  originalPrice: item.resolvedPriceDisplay.usd > 0
                      ? item.resolvedPriceDisplay.usd
                      : item.price,
                  priceKhr: item.resolvedFinalPriceDisplay.hasKhr
                      ? item.resolvedFinalPriceDisplay.khr
                      : null,
                  currencySymbol: r'$',
                  badge: item.certificationType?.tr,
                  averageRating: item.averageRating,
                  ratingsCount: item.ratingsCount,
                  isFavorite: wishlistController.isFavorite(item.id),
                  onFavoriteTap: () => wishlistController.toggleWishlist(item),
                  onTap: () async {
                    await Get.toNamed<void>(
                      AppRoutes.productDetail,
                      arguments: item,
                    );
                  },
                  onActionTap: () =>
                      Get.find<CartController>().addToCart(item.id, 1),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
