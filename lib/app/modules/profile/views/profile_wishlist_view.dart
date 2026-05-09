import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/profile/controllers/profile_wishlist_controller.dart';
import 'package:fresh_leaf/app/modules/profile/widgets/profile_wishlist_widget.dart';
import 'package:fresh_leaf/core/models/product_info.dart';
import 'package:fresh_leaf/shared/widgets/custom_app_bar.dart';
import 'package:get/get.dart';

class ProfileWishlistView extends GetView<ProfileWishlistController> {
  const ProfileWishlistView({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final scaffoldBg = Theme.of(context).scaffoldBackgroundColor;
    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: CustomAppBar(title: 'wishlist'.tr),
      body: Obx(() {
        if (controller.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.items.isEmpty) {
          return const WishlistEmptyWidget();
        }

        final visible = controller.visibleItems;
        final leftColumn = <ProductInfo>[];
        final rightColumn = <ProductInfo>[];
        for (var i = 0; i < visible.length; i++) {
          if (i.isEven) {
            leftColumn.add(visible[i]);
          } else {
            rightColumn.add(visible[i]);
          }
        }

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          children: [
            _WishlistControls(controller: controller),
            const SizedBox(height: 14),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: leftColumn
                        .map(
                          (item) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: WishlistItemCard(
                              item: item,
                              imageHeight: _imageHeightFor(item, isLeft: true),
                              onOpen: () => controller.openProductDetail(item),
                              onRemove: () => controller.removeItem(item),
                              onAddToCart: () => controller.addToCart(item),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    children: rightColumn
                        .map(
                          (item) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: WishlistItemCard(
                              item: item,
                              imageHeight: _imageHeightFor(item, isLeft: false),
                              onOpen: () => controller.openProductDetail(item),
                              onRemove: () => controller.removeItem(item),
                              onAddToCart: () => controller.addToCart(item),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'wishlist_hint_tap_card'.tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: scheme.onSurfaceVariant,
                fontSize: 12,
              ),
            ),
          ],
        );
      }),
    );
  }

  double _imageHeightFor(ProductInfo item, {required bool isLeft}) {
    final seed =
        item.title.length +
        (item.tags.firstOrNull?.length ?? 0) +
        (isLeft ? 1 : 2);
    final variation = seed % 3;
    if (variation == 0) return 148;
    if (variation == 1) return 176;
    return 196;
  }
}

class _WishlistControls extends StatelessWidget {
  const _WishlistControls({required this.controller});

  final ProfileWishlistController controller;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: scheme.outline.withValues(alpha: 0.16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: controller.categories
                        .map(
                          (category) => Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ChoiceChip(
                              label: Text(
                                category == 'All'
                                    ? 'wishlist_category_all'.tr
                                    : category,
                              ),
                              selected:
                                  controller.selectedCategory.value == category,
                              onSelected: (_) => controller.category = category,
                              labelStyle: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color:
                                    controller.selectedCategory.value ==
                                        category
                                    ? scheme.onPrimaryContainer
                                    : scheme.onSurfaceVariant,
                              ),
                              selectedColor: scheme.primaryContainer,
                              backgroundColor: scheme.surfaceContainerHighest
                                  .withValues(alpha: 0.5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                                side: BorderSide(
                                  color: scheme.outline.withValues(alpha: 0.15),
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
              PopupMenuButton<WishlistSortType>(
                initialValue: controller.selectedSort.value,
                onSelected: (sort) => controller.sort = sort,
                tooltip: 'wishlist_sort'.tr,
                itemBuilder: (context) => WishlistSortType.values
                    .map(
                      (sort) => PopupMenuItem<WishlistSortType>(
                        value: sort,
                        child: Text(controller.sortLabel(sort)),
                      ),
                    )
                    .toList(),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: scheme.surfaceContainerHighest.withValues(
                      alpha: 0.55,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.swap_vert_rounded,
                        size: 16,
                        color: scheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        controller.sortLabel(controller.selectedSort.value),
                        style: TextStyle(
                          fontSize: 11.5,
                          color: scheme.onSurfaceVariant,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
