import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/routes/app_routes.dart';
import 'package:fresh_leaf/core/models/home_product.dart';
import 'package:fresh_leaf/core/models/product_info.dart';
import 'package:fresh_leaf/shared/helpers/product_share_helper.dart';
import 'package:fresh_leaf/shared/helpers/responsive_helper.dart';
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
        padding: EdgeInsets.symmetric(horizontal: 24.scaled),
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(
            horizontal: 20.scaled,
            vertical: 24.scaled,
          ),
          decoration: BoxDecoration(
            color: scheme.surface,
            borderRadius: BorderRadius.circular(20.scaled),
          ),
          child: Column(
            children: [
              Icon(
                Icons.search_off_outlined,
                color: scheme.onSurfaceVariant,
              ),
              SizedBox(height: 10.scaled),
              Text(
                'no_matching_products'.tr,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: scheme.onSurface,
                ),
              ),
              SizedBox(height: 4.scaled),
              Text(
                'try_another_keyword_short'.tr,
                style: TextStyle(
                  fontSize: 12.scaled,
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SizedBox(
      height: 280.scaled,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 24.scaled),
        scrollDirection: Axis.horizontal,
        itemCount: pickedThisMorning.length,
        separatorBuilder: (_, _) => SizedBox(width: 16.scaled),
        itemBuilder: (context, index) {
          final item = pickedThisMorning[index];
          return SizedBox(
            width: 200.scaled,
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
                  shareSlug: ProductShareHelper.resolveSlug(
                    title: item.title.tr,
                    shareSlug: item.shareSlug,
                  ),
                  shareDeepLink: item.shareDeepLink.isEmpty
                      ? null
                      : item.shareDeepLink,
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
