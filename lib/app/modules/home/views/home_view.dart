import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/cart/views/cart_panel_view.dart';
import 'package:fresh_leaf/app/modules/home/controllers/home_controller.dart';
import 'package:fresh_leaf/app/modules/home/widgets/home_widget.dart';
import 'package:fresh_leaf/app/routes/app_routes.dart';
import 'package:fresh_leaf/shared/helpers/responsive_helper.dart';
import 'package:fresh_leaf/shared/widgets/app_scaffold.dart';
import 'package:fresh_leaf/shared/widgets/app_section_header.dart';
import 'package:get/get.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return AppScaffold(
      onRefresh: controller.refreshHome,
      padding: EdgeInsets.symmetric(vertical: 20.scaled),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: showCartPanel,
        icon: const Icon(Icons.shopping_cart_outlined),
        label: Text('cart'.tr),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HomeAppBarWidget(),
          SizedBox(height: 24.scaled),
          const HomeHeroCardWidget(),
          SizedBox(height: 32.scaled),
          AppSectionHeader(
            title: 'browse_categories'.tr,
            style: AppSectionHeaderStyle.medium,
            trailing: GestureDetector(
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
          ),
          SizedBox(height: 16.scaled),
          HomeCategoriesWidget(
            categories: controller.categories.toList(),
          ),
          SizedBox(height: 24.scaled),
          AppSectionHeader(
            title: 'picked_this_morning'.tr,
            subtitle: 'picked_this_morning_subtitle'.tr,
          ),
          SizedBox(height: 16.scaled),
          Obx(() {
            final products = controller.pickedThisMorning.toList();
            return HomeHorizontalProductsWidget(
              pickedThisMorning: products,
            );
          }),
        ],
      ),
    );
  }
}
