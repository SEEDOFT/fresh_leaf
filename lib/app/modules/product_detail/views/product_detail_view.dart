import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/product_detail/controllers/product_detail_controller.dart';
import 'package:fresh_leaf/app/modules/product_detail/widgets/product_detail_widgets.dart';
import 'package:fresh_leaf/core/models/vendor_inventory.dart';
import 'package:fresh_leaf/core/services/rating_service.dart';
import 'package:fresh_leaf/shared/widgets/app_scaffold.dart';
import 'package:fresh_leaf/shared/widgets/custom_app_bar.dart';
import 'package:get/get.dart';

class ProductDetailView extends StatelessWidget {
  const ProductDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final args = Get.arguments;
    final tag = switch (args) {
      final VendorInventory v => 'product_${v.id}',
      final Map<String, dynamic> m => 'product_${m['id']}',
      _ => null,
    };
    return GetBuilder<ProductDetailController>(
      tag: tag,
      init: ProductDetailController(
        wishlistController: Get.find(),
        productService: Get.find(),
        cartController: Get.find(),
        ratingService: Get.find<RatingService>(),
      ),
      builder: (controller) {
        return AppScaffold(
          appBar: CustomAppBar(
            title: controller.title,
            showCartButton: true,
            actions: [
              IconButton(
                icon: Icon(Icons.share_outlined, color: scheme.onSurface),
                onPressed: controller.shareProduct,
                tooltip: 'share_product'.tr,
              ),
              Obx(
                () => IconButton(
                  icon: Icon(
                    controller.isFavorite
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    color: controller.isFavorite
                        ? scheme.error
                        : scheme.onSurface,
                  ),
                  onPressed: controller.toggleWishlist,
                ),
              ),
            ],
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (controller.isLoading.value && controller.product == null)
                const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (controller.product != null) ...[
                HeroImageWidget(imageUrls: controller.allImages),
                const SizedBox(height: 20),
                TitleRowWidget(
                  title: controller.title,
                  origin: controller.origin,
                  total: controller.total,
                  controller: controller,
                ),
                const SizedBox(height: 8),
                Text(
                  controller.subtitle.tr,
                  style: TextStyle(
                    color: scheme.onSurfaceVariant,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 12),
                TagsWidget(tags: controller.tags),
                const SizedBox(height: 16),
                InfoTilesWidget(
                  harvest: controller.harvest,
                  origin: controller.origin,
                  storage: controller.storage,
                ),
                const SizedBox(height: 16),
                Text(
                  'about_this_item'.tr,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: scheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  controller.description.tr,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.6,
                    color: scheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 24),
                ProductDetailVendorCard(product: controller.product!),
                const SizedBox(height: 24),
                ProductDetailRatingCard(tag: tag),
                const SizedBox(height: 24),
                Obx(
                  () => QuantityRowWidget(
                    quantity: controller.quantity.value,
                    unitSymbol: controller.product!.unitSymbol,
                    onIncrement: controller.increment,
                    onDecrement: controller.decrement,
                    onChanged: (val) =>
                        controller.updateQuantity(val.toDouble()),
                    allowDecimal: controller.allowDecimal,
                  ),
                ),
                const SizedBox(height: 20),
                Obx(
                  () => AddButtonWidget(
                    total: controller.total,
                    onPressed: controller.addToCart,
                    controller: controller,
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ],
          ),
        );
      },
    );
  }
}
