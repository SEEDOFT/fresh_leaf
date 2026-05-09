import 'package:flutter/material.dart' hide SearchController;
import 'package:fresh_leaf/app/modules/search/controllers/search_controller.dart';
import 'package:fresh_leaf/app/modules/search/widgets/search_widget.dart';
import 'package:fresh_leaf/core/controllers/wishlist_controller.dart';
import 'package:fresh_leaf/core/models/product_info.dart';
import 'package:fresh_leaf/shared/helpers/product_share_helper.dart';
import 'package:fresh_leaf/shared/widgets/app_product_card.dart';
import 'package:fresh_leaf/shared/widgets/app_scaffold.dart';
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
                    final productInfo = ProductInfo(
                      id: item.id,
                      title: item.title.tr,
                      subtitle: item.subtitle.tr,
                      description:
                          (item.description.isEmpty
                                  ? 'seasonal_pick_description'
                                  : item.description)
                              .tr,
                      imageUrl: item.image,
                      tags:
                          (item.tags.isEmpty ? ['organic', 'fresh'] : item.tags)
                              .map<String>((e) => e.tr)
                              .toList(),
                      price: item.priceValue,
                      origin:
                          (item.origin.isEmpty ? 'local_farm' : item.origin).tr,
                      harvest:
                          (item.harvest.isEmpty
                                  ? 'harvested_this_week'
                                  : item.harvest)
                              .tr,
                      storage:
                          (item.storage.isEmpty
                                  ? 'refrigerate_extend_freshness'
                                  : item.storage)
                              .tr,
                      shareSlug: ProductShareHelper.resolveSlug(
                        title: item.title.tr,
                        shareSlug: item.shareSlug,
                      ),
                      shareDeepLink: item.shareDeepLink.isEmpty
                          ? null
                          : item.shareDeepLink,
                      originalPrice: item.originalPrice > 0
                          ? item.originalPrice
                          : null,
                      priceKhr: item.activePriceKhr > 0
                          ? item.activePriceKhr
                          : null,
                    );

                    return AppProductCard(
                      title: item.title.tr,
                      subtitle: item.subtitle.tr,
                      imageUrl: item.image,
                      price: item.priceValue,
                      layout: AppProductCardLayout.list,
                      isFavorite: wishlistController.isFavorite(item.id),
                      onFavoriteTap: () =>
                          wishlistController.toggleWishlist(productInfo),
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
