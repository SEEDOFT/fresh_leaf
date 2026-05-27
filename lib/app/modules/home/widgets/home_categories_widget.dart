import 'package:flutter/material.dart' hide SearchController;
import 'package:fresh_leaf/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:fresh_leaf/app/modules/search/controllers/search_controller.dart';
import 'package:fresh_leaf/app/routes/app_routes.dart';
import 'package:fresh_leaf/core/constants/app_sizes.dart';
import 'package:fresh_leaf/core/models/product_category.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class HomeCategoriesWidget extends StatelessWidget {
  const HomeCategoriesWidget({
    required this.categories,
    super.key,
  });

  final List<ProductCategory> categories;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSizes.p24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'browse_categories'.tr,
                style: TextStyle(
                  fontSize: AppSizes.s20,
                  fontWeight: FontWeight.bold,
                  color: scheme.onSurface,
                ),
              ),
              GestureDetector(
                onTap: () async => await Get.toNamed(AppRoutes.productList),
                child: Text(
                  'view_all'.tr,
                  style: TextStyle(
                    fontSize: AppSizes.s13,
                    fontWeight: FontWeight.w600,
                    color: scheme.primary.withValues(alpha: 0.8),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: AppSizes.p16),
        SizedBox(
          height: AppSizes.categoryCardHeight,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: AppSizes.p24),
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            separatorBuilder: (_, _) => SizedBox(width: AppSizes.p12),
            itemBuilder: (context, index) {
              final cat = categories[index];
              return GestureDetector(
                onTap: () {
                  final searchController = Get.find<SearchController>();
                  searchController.selectedCategoryId.value = cat.id;
                  if (Get.isRegistered<DashboardController>()) {
                    Get.find<DashboardController>().currentIndex = 1;
                  }
                },
                child: Container(
                  width: AppSizes.categoryCardWidth,
                  decoration: BoxDecoration(
                    color: scheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(AppSizes.radius24),
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: AppSizes.p12,
                    horizontal: AppSizes.p8,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _iconFor(cat.icon),
                        color: scheme.onSurface,
                      ),
                      SizedBox(height: AppSizes.p8),
                      Text(
                        cat.name,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: AppSizes.s11,
                          fontWeight: FontWeight.w600,
                          color: scheme.onSurface,
                          height: 1.1,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  IconData _iconFor(ProductCategoryIcon icon) {
    switch (icon) {
      case ProductCategoryIcon.fruit:
        return MdiIcons.foodApple;
      case ProductCategoryIcon.rootAndTuber:
        return MdiIcons.carrot;
      case ProductCategoryIcon.bulbAndStem:
        return MdiIcons.corn;
      case ProductCategoryIcon.legume:
        return MdiIcons.peanut;
      case ProductCategoryIcon.indigenousAndWild:
        return MdiIcons.sprout;
      case ProductCategoryIcon.leaf:
        return MdiIcons.leaf;
    }
  }
}
