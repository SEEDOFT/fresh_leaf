import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/home/widgets/home_network_image_widget.dart';
import 'package:fresh_leaf/app/routes/app_routes.dart';
import 'package:fresh_leaf/core/models/home_product.dart';
import 'package:fresh_leaf/core/models/product_info.dart';
import 'package:get/get.dart';

class HomeHorizontalProductsWidget extends StatelessWidget {
  const HomeHorizontalProductsWidget({
    required this.pickedThisMorning,
    super.key,
  });

  final List<HomeProduct> pickedThisMorning;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final scheme = Theme.of(context).colorScheme;
    if (pickedThisMorning.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          decoration: BoxDecoration(
            color: scheme.surface,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Icon(
                Icons.search_off_outlined,
                color: scheme.onSurfaceVariant,
              ),
              const SizedBox(height: 10),
              Text(
                'no_matching_products'.tr,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: scheme.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'try_another_keyword_short'.tr,
                style: TextStyle(
                  fontSize: 12,
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SizedBox(
      height: 280,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        scrollDirection: Axis.horizontal,
        itemCount: pickedThisMorning.length,
        separatorBuilder: (_, _) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final item = pickedThisMorning[index];
          return GestureDetector(
            onTap: () async {
              final product = ProductInfo(
                title: item.title.tr,
                subtitle: item.subtitle.tr,
                description:
                    (item.description.isEmpty
                            ? 'seasonal_pick_description'
                            : item.description)
                        .tr,
                imageUrl: item.image,
                tags: (item.tags.isEmpty ? ['organic', 'fresh'] : item.tags)
                    .map((e) => e.tr)
                    .toList(),
                price: item.priceValue,
                origin: (item.origin.isEmpty ? 'local_farm' : item.origin).tr,
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
              );
              await Get.toNamed<void>(
                AppRoutes.productDetail,
                arguments: product,
              );
            },
            child: Container(
              width: 200,
              decoration: BoxDecoration(
                color: scheme.surface,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      HomeNetworkImageWidget(
                        url: item.image,
                        height: 140,
                        width: 200,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(24),
                        ),
                      ),
                      Positioned(
                        top: 12,
                        left: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: scheme.secondaryContainer,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            item.badge.tr,
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: scheme.onSecondaryContainer,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                item.title.tr,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: scheme.onSurface,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              item.priceText,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: scheme.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.subtitle.tr,
                          style: TextStyle(
                            fontSize: 12,
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          width: media.size.width,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: scheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add,
                                size: 16,
                                color: scheme.onSurface,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'add_to_cart'.tr,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                  color: scheme.onSurface,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
