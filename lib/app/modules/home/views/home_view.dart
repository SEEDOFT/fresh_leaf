import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/cart/views/cart_panel_view.dart';
import 'package:fresh_leaf/app/modules/home/controllers/home_controller.dart';
import 'package:fresh_leaf/app/modules/home/widgets/home_widget.dart';
import 'package:fresh_leaf/app/routes/app_routes.dart';
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
      padding: const EdgeInsets.symmetric(vertical: 20),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: showCartPanel,
        icon: const Icon(Icons.shopping_cart_outlined),
        label: Text('cart'.tr),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HomeAppBarWidget(),
          const SizedBox(height: 24),
          const HomeHeroCardWidget(),
          const SizedBox(height: 32),
          AppSectionHeader(
            title: 'browse_categories'.tr,
            style: AppSectionHeaderStyle.medium,
            trailing: GestureDetector(
              onTap: () async => await Get.toNamed(AppRoutes.productList),
              child: Text(
                'view_all'.tr,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: scheme.primary.withValues(alpha: 0.8),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          HomeCategoriesWidget(
            categories: controller.categories.toList(),
          ),
          const SizedBox(height: 24),
          AppSectionHeader(
            title: 'picked_this_morning'.tr,
            subtitle: 'picked_this_morning_subtitle'.tr,
          ),
          const SizedBox(height: 16),
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
