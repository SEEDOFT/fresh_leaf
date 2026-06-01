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
      onRefresh: controller.loadVendorProfile,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final vendor = controller.vendor.value;
        if (vendor == null) {
          return Center(
            child: Text('vendor_not_found'.tr),
          );
        }

        final items = controller.products;
        final hasBanner =
            vendor.storeFrontImage != null &&
            vendor.storeFrontImage!.isNotEmpty;

        return CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          slivers: [
            // Sliver AppBar with Store Banner Parallax
            SliverAppBar(
              expandedHeight: 200,
              pinned: true,
              stretch: true,
              backgroundColor: scheme.surface,
              iconTheme: IconThemeData(color: scheme.onSurface),
              actions: [
                Obx(
                  () => IconButton(
                    icon: controller.isStartingChat.value
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.chat_bubble_outline),
                    onPressed: controller.isStartingChat.value
                        ? null
                        : controller.startChat,
                    tooltip: 'chat_with_vendor'.tr,
                    style: IconButton.styleFrom(
                      backgroundColor: scheme.surface.withValues(alpha: 0.7),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],
              flexibleSpace: FlexibleSpaceBar(
                stretchModes: const [
                  StretchMode.zoomBackground,
                  StretchMode.fadeTitle,
                ],
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
                    // Dark linear overlay backdrop scrim
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
                          // Active Products Count Badge row
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
                          // Opening Hours row
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
                          // Address row
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
                            // Phone row
                            _infoRow(
                              icon: Icons.phone_outlined,
                              title: 'phone_number'.tr,
                              value: vendor.contactPhone!,
                              scheme: scheme,
                            ),
                          ],
                        ],
                      ),
                    ),
                    SizedBox(height: AppSizes.s24),
                    // Section header
                    AppSectionHeader(
                      title: 'vendor_products'.tr,
                      subtitle: 'products_offered_by_vendor'.tr,
                    ),
                    SizedBox(height: AppSizes.s16),
                  ],
                ),
              ),
            ),
            // Sliver Grid listing the vendor's items
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
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.70,
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
                          price: product.resolvedFinalPriceDisplay.usd > 0
                              ? product.resolvedFinalPriceDisplay.usd
                              : product.finalPrice,
                          originalPrice: product.resolvedPriceDisplay.usd > 0
                              ? product.resolvedPriceDisplay.usd
                              : product.price,
                          priceKhr: product.resolvedFinalPriceDisplay.hasKhr
                              ? product.resolvedFinalPriceDisplay.khr
                              : null,
                          currencySymbol: r'$',
                          isFavorite: wishlist.isFavorite(product.id),
                          onFavoriteTap: () => wishlist.toggleWishlist(product),
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
            // Bottom Safe Margin
            SliverToBoxAdapter(
              child: SizedBox(height: AppSizes.s32),
            ),
          ],
        );
      }),
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
