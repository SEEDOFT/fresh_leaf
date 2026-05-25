import 'package:flutter/material.dart' hide SearchController;
import 'package:fresh_leaf/app/modules/search/controllers/search_controller.dart';
import 'package:fresh_leaf/app/modules/search/widgets/search_widget.dart';
import 'package:fresh_leaf/core/controllers/wishlist_controller.dart';
import 'package:fresh_leaf/shared/widgets/app_product_card.dart';
import 'package:fresh_leaf/shared/widgets/app_scaffold.dart';
import 'package:fresh_leaf/shared/widgets/skeleton_loading_widget.dart';
import 'package:get/get.dart';

class SearchView extends GetView<SearchController> {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final wishlistController = Get.find<WishlistController>();

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: AppScaffold(
        scrollable: false,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'search'.tr,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: scheme.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'search_subtitle'.tr,
              style: TextStyle(
                color: scheme.onSurfaceVariant,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 14),
            Obx(
              () => SearchSearchFieldWidget(
                controller: controller.textController,
                query: controller.query,
                onChanged: (value) => controller.query = value,
                onClear: controller.clearQuery,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 36,
              child: Obx(() {
                final activeTag = controller.activeTag;
                return ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.quickTags.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final label = controller.quickTags[index];
                    return SearchFilterChipWidget(
                      label: controller.displayLabelForTag(label),
                      isSelected: activeTag == label,
                      onTap: () => controller.activeTag = label,
                    );
                  },
                );
              }),
            ),
            const SizedBox(height: 14),
            Obx(
              () => Text(
                (controller.results.length == 1
                        ? 'results_one'
                        : 'results_other')
                    .trParams({
                      'count': '${controller.results.length}',
                    }),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Obx(() {
                if (controller.isLoading) {
                  return const ProductListSkeleton();
                }

                final items = controller.results;
                if (items.isEmpty) {
                  return const SearchEmptyWidget();
                }

                return ListView.separated(
                  padding: const EdgeInsets.only(bottom: 20),
                  itemCount: items.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = items[index];

                    return AppProductCard(
                      title: item.displayTitle.tr,
                      subtitle: item.displaySubtitle.tr,
                      imageUrl: item.displayImageUrl,
                      price: item.price,
                      currencySymbol: item.currencySymbol,
                      layout: AppProductCardLayout.list,
                      isFavorite: wishlistController.isFavorite(item.id),
                      onFavoriteTap: () =>
                          wishlistController.toggleWishlist(item),
                      onTap: () => controller.openProduct(item),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
