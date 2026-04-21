import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/routes/app_routes.dart';
import 'package:fresh_leaf/core/models/home_product.dart';
import 'package:fresh_leaf/core/models/product_info.dart';
import 'package:fresh_leaf/shared/widgets/app_product_card.dart';
import 'package:get/get.dart';

class HomeHorizontalProductsWidget extends StatelessWidget {
  const HomeHorizontalProductsWidget({
    required this.pickedThisMorning,
    super.key,
  });

  final List<HomeProduct> pickedThisMorning;

  @override
  Widget build(BuildContext context) {
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
          return SizedBox(
            width: 200,
            child: AppProductCard(
              title: item.title.tr,
              subtitle: item.subtitle.tr,
              imageUrl: item.image,
              price: item.priceValue,
              badge: item.badge.tr,
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
              onActionTap: () {},
            ),
          );
        },
      ),
    );
  }
}
