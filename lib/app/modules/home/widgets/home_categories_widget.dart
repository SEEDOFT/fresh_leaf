import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/routes/app_routes.dart';
import 'package:fresh_leaf/core/models/home_category.dart';
import 'package:fresh_leaf/shared/helpers/responsive_helper.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class HomeCategoriesWidget extends StatelessWidget {
  const HomeCategoriesWidget({
    required this.categories,
    super.key,
  });

  final List<HomeCategory> categories;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.scaled),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'browse_categories'.tr,
                style: TextStyle(
                  fontSize: 20.scaled,
                  fontWeight: FontWeight.bold,
                  color: scheme.onSurface,
                ),
              ),
              GestureDetector(
                onTap: () async => await Get.toNamed(AppRoutes.productList),
                child: Text(
                  'view_all'.tr,
                  style: TextStyle(
                    fontSize: 13.scaled,
                    fontWeight: FontWeight.w600,
                    color: scheme.primary.withValues(alpha: 0.8),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.scaled),
        SizedBox(
          height: 120.scaled,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 24.scaled),
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            separatorBuilder: (_, _) => SizedBox(width: 12.scaled),
            itemBuilder: (context, index) {
              final cat = categories[index];
              return Container(
                width: 85.scaled,
                decoration: BoxDecoration(
                  color: scheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(24.scaled),
                ),
                padding: EdgeInsets.symmetric(
                  vertical: 12.scaled,
                  horizontal: 8.scaled,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _iconFor(cat.icon),
                      color: scheme.onSurface,
                    ),
                    SizedBox(height: 8.scaled),
                    Text(
                      cat.titleKey.tr,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11.scaled,
                        fontWeight: FontWeight.w600,
                        color: scheme.onSurface,
                        height: 1.1,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  IconData _iconFor(HomeCategoryIcon icon) {
    switch (icon) {
      case HomeCategoryIcon.fruit:
        return MdiIcons.foodApple; // 🍎 Actual apple icon (not just a symbol)
      case HomeCategoryIcon.rootAndTuber:
        return MdiIcons.carrot; // 🥕 Carrot — closest to root/tuber crops
      case HomeCategoryIcon.bulmAndStem:
        return MdiIcons.corn; // 🌽 Corn — good for bulb/stem veggies
      case HomeCategoryIcon.legume:
        return MdiIcons.peanut; // 🥜 Peanut — directly represents legumes
      case HomeCategoryIcon.indigenousAndWild:
        return MdiIcons.sprout; // 🌱 Sprout — evokes wild/foraged plants
      case HomeCategoryIcon.leaf:
        return MdiIcons.leaf; // 🍃 Leaf — exact match, also in MDI
    }
  }
}
