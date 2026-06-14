import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/cart/controllers/cart_controller.dart';
import 'package:fresh_leaf/app/modules/vendor_profile/controllers/vendor_profile_controller.dart';
import 'package:fresh_leaf/app/routes/app_routes.dart';
import 'package:fresh_leaf/core/constants/app_sizes.dart';
import 'package:fresh_leaf/core/controllers/wishlist_controller.dart';
import 'package:fresh_leaf/shared/widgets/app_product_card.dart';
import 'package:fresh_leaf/shared/widgets/app_scaffold.dart';
import 'package:fresh_leaf/shared/widgets/app_section_header.dart';
import 'package:get/get.dart';

class VendorProfileView extends GetView<VendorProfileController> {
  const VendorProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final wishlist = Get.find<WishlistController>();

    return AppScaffold(
      scrollable: false,
      padding: EdgeInsets.zero,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return RefreshIndicator(
            onRefresh: controller.loadVendorProfile,
            child: Obx(() {
              final vendor = controller.vendor.value;
              final isLoading = controller.isLoading.value;

              // Ensure we always return something scrollable with AlwaysScrollableScrollPhysics
              // so the RefreshIndicator can be triggered even when empty or loading.
              if (isLoading && vendor == null) {
                return SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: ClampingScrollPhysics(),
                  ),
                  child: SizedBox(
                    height: constraints.maxHeight,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                );
              }

              if (vendor == null) {
                return SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: ClampingScrollPhysics(),
                  ),
                  child: SizedBox(
                    height: constraints.maxHeight,
                    child: Center(
                      child: Text('vendor_not_found'.tr),
                    ),
                  ),
                );
              }

              final items = controller.filteredProducts;
              final hasBanner =
                  vendor.storeFrontImage != null &&
                  vendor.storeFrontImage!.isNotEmpty;

              return NotificationListener<ScrollNotification>(
                onNotification: (scrollInfo) {
                  if (scrollInfo.metrics.pixels >=
                      scrollInfo.metrics.maxScrollExtent - 200) {
                    unawaited(controller.loadMoreProducts());
                  }
                  return false;
                },
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: ClampingScrollPhysics(),
                  ),
                  slivers: [
                    SliverAppBar(
                      expandedHeight: 200,
                      pinned: true,
                      backgroundColor: scheme.surface,
                      iconTheme: IconThemeData(color: scheme.onSurface),
                      actions: [
                        IconButton(
                          icon: const Icon(Icons.share_outlined),
                          onPressed: controller.shareVendor,
                          tooltip: 'share_vendor'.tr,
                          style: IconButton.styleFrom(
                            backgroundColor:
                                scheme.surface.withValues(alpha: 0.7),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Obx(
                          () => IconButton(
                            icon: controller.isStartingChat.value
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Icon(Icons.chat_bubble_outline),
                            onPressed: controller.isStartingChat.value
                                ? null
                                : controller.startChat,
                            tooltip: 'chat_with_vendor'.tr,
                            style: IconButton.styleFrom(
                              backgroundColor:
                                  scheme.surface.withValues(alpha: 0.7),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      flexibleSpace: FlexibleSpaceBar(
                        background: Stack(
                          fit: StackFit.expand,
                          children: [
                            if (hasBanner)
                              Image.network(
                                vendor.storeFrontImage!,
                                fit: BoxFit.cover,
                              )
                            else
                              Container(
                                decoration: LinearGradient(
                                  colors: [
                                    scheme.primaryContainer,
                                    scheme.tertiaryContainer,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ).toDecoration(),
                              ),
                            Container(
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.black54,
                                    Colors.transparent,
                                    Colors.black54,
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: AppSizes.s16,
                              left: AppSizes.s20,
                              right: AppSizes.s20,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      vendor.displayName,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  if (vendor.isVerified) ...[
                                    const SizedBox(width: 6),
                                    const Icon(
                                      Icons.verified,
                                      size: 22,
                                      color: Colors.blueAccent,
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Vendor Business Details & Hours Card
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(AppSizes.s20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Description Block
                            if (vendor.shopDescription != null &&
                                vendor.shopDescription!.isNotEmpty) ...[
                              Text(
                                vendor.shopDescription!,
                                style: TextStyle(
                                  fontSize: 14,
                                  height: 1.5,
                                  color: scheme.onSurfaceVariant,
                                ),
                              ),
                              SizedBox(height: AppSizes.s16),
                            ],
                            // Open hours, Address & Status indicators
                            Container(
                              padding: EdgeInsets.all(AppSizes.s16),
                              decoration: BoxDecoration(
                                color: scheme.surfaceContainerLow,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: scheme.outlineVariant.withValues(
                                    alpha: 0.5,
                                  ),
                                ),
                              ),
                              child: Column(
                                children: [
                                  _infoRow(
                                    icon: Icons.inventory_2_outlined,
                                    title: 'active_products'.tr,
                                    value:
                                        '${vendor.productCount} '
                                        '${'products'.tr}',
                                    scheme: scheme,
                                  ),
                                  Divider(
                                    height: AppSizes.s24,
                                    color: scheme.outlineVariant.withValues(
                                      alpha: 0.5,
                                    ),
                                  ),
                                  _infoRow(
                                    icon: Icons.access_time_rounded,
                                    title: 'business_hours'.tr,
                                    value:
                                        vendor.openingTime != null &&
                                            vendor.closingTime != null
                                        ? '${vendor.openingTime} - '
                                              '${vendor.closingTime}'
                                        : 'always_open'.tr,
                                    scheme: scheme,
                                  ),
                                  Divider(
                                    height: AppSizes.s24,
                                    color: scheme.outlineVariant.withValues(
                                      alpha: 0.5,
                                    ),
                                  ),
                                  _infoRow(
                                    icon: Icons.location_on_outlined,
                                    title: 'location'.tr,
                                    value: vendor.address ?? 'no_address'.tr,
                                    scheme: scheme,
                                  ),
                                  if (vendor.contactPhone != null) ...[
                                    Divider(
                                      height: AppSizes.s24,
                                      color: scheme.outlineVariant.withValues(
                                        alpha: 0.5,
                                      ),
                                    ),
                                    _infoRow(
                                      icon: Icons.phone_outlined,
                                      title: 'phone'.tr,
                                      value: vendor.contactPhone!,
                                      scheme: scheme,
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            SizedBox(height: AppSizes.s24),
                            AppSectionHeader(
                              title: 'vendor_products'.tr,
                              subtitle: 'products_offered_by_vendor'.tr,
                            ),
                            SizedBox(height: AppSizes.s12),
                            Obx(() {
                              final categories = controller.productCategories;
                              if (categories.isEmpty) {
                                return const SizedBox.shrink();
                              }
                              return SizedBox(
                                height: 36,
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: categories.length + 1,
                                  separatorBuilder: (_, _) =>
                                      const SizedBox(width: 8),
                                  itemBuilder: (context, index) {
                                    final isSelected = index == 0
                                        ? controller.selectedCategoryId.value ==
                                              null
                                        : controller.selectedCategoryId.value ==
                                              categories[index - 1].id;
                                    final label = index == 0
                                        ? 'all_categories'.tr
                                        : categories[index - 1].name;
                                    return FilterChip(
                                      selected: isSelected,
                                      label: Text(label),
                                      onSelected: (_) {
                                        controller.category = index == 0
                                            ? null
                                            : categories[index - 1].id;
                                      },
                                      visualDensity: VisualDensity.compact,
                                    );
                                  },
                                ),
                              );
                            }),
                            SizedBox(height: AppSizes.s16),
                          ],
                        ),
                      ),
                    ),
                    if (items.isEmpty)
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.all(AppSizes.s20),
                            child: Text(
                              'no_products_found'.tr,
                              style: TextStyle(color: scheme.onSurfaceVariant),
                            ),
                          ),
                        ),
                      )
                    else
                      SliverPadding(
                        padding: EdgeInsets.symmetric(horizontal: AppSizes.s20),
                        sliver: SliverGrid(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisExtent: 300,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                              ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final product = items[index];
                              return Obx(
                                () => AppProductCard(
                                  title: product.displayTitle.tr,
                                  subtitle: product.displaySubtitle.tr,
                                  imageUrl: product.displayImageUrl,
                                  price:
                                      product.resolvedFinalPriceDisplay.usd > 0
                                      ? product.resolvedFinalPriceDisplay.usd
                                      : product.finalPrice,
                                  originalPrice:
                                      product.resolvedPriceDisplay.usd > 0
                                      ? product.resolvedPriceDisplay.usd
                                      : product.price,
                                  priceKhr:
                                      product.resolvedFinalPriceDisplay.hasKhr
                                      ? product.resolvedFinalPriceDisplay.khr
                                      : null,
                                  currencySymbol: r'$',
                                  badge: product.certificationType?.tr,
                                  averageRating: product.averageRating,
                                  ratingsCount: product.ratingsCount,
                                  isFavorite: wishlist.isFavorite(product.id),
                                  onFavoriteTap: () =>
                                      wishlist.toggleWishlist(product),
                                  onTap: () async {
                                    await Get.toNamed<void>(
                                      AppRoutes.productDetail,
                                      arguments: product,
                                    );
                                  },
                                  onActionTap: () {
                                    if (Get.isRegistered<CartController>()) {
                                      unawaited(
                                        Get.find<CartController>().addToCart(
                                          product.id,
                                          1,
                                        ),
                                      );
                                    }
                                  },
                                ),
                              );
                            },
                            childCount: items.length,
                          ),
                        ),
                      ),
                    SliverToBoxAdapter(
                      child: Obx(
                        () => controller.isPaginating.value
                            ? const Padding(
                                padding: EdgeInsets.all(24),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            : SizedBox(height: AppSizes.s32),
                      ),
                    ),
                  ],
                ),
              );
            }),
          );
        },
      ),
    );
  }

  Widget _infoRow({
    required IconData icon,
    required String title,
    required String value,
    required ColorScheme scheme,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20,
          color: scheme.primary,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: scheme.onSurfaceVariant.withValues(alpha: 0.8),
                ),
              ),
              const SizedBox(height: 3),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: scheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

extension on LinearGradient {
  Decoration toDecoration() => BoxDecoration(gradient: this);
}
