import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/cart/bindings/cart_binding.dart';
import 'package:fresh_leaf/app/modules/cart/controllers/cart_controller.dart';
import 'package:fresh_leaf/app/modules/cart/views/cart_panel_view.dart';
import 'package:fresh_leaf/app/modules/home/controllers/home_controller.dart';
import 'package:fresh_leaf/app/modules/home/widgets/home_widget.dart';
import 'package:fresh_leaf/core/constants/app_sizes.dart';
import 'package:fresh_leaf/shared/widgets/app_scaffold.dart';
import 'package:fresh_leaf/shared/widgets/app_section_header.dart';
import 'package:fresh_leaf/shared/widgets/skeleton_loading_widget.dart';
import 'package:get/get.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      onRefresh: controller.refreshHome,
      padding: EdgeInsets.symmetric(vertical: AppSizes.s20),
      floatingActionButton: Obx(() {
        if (!Get.isRegistered<CartController>()) {
          CartBinding().dependencies();
        }
        final cartController = Get.find<CartController>();
        final count = cartController.items.length;

        return FloatingActionButton.extended(
          onPressed: showCartPanel,
          icon: count > 0
              ? Badge(
                  label: Text(count > 99 ? '99+' : count.toString()),
                  child: const Icon(Icons.shopping_cart_outlined),
                )
              : const Icon(Icons.shopping_cart_outlined),
          label: Text('cart'.tr),
        );
      }),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HomeAppBarWidget(),
          SizedBox(height: AppSizes.s24),
          const HomeHeroCardWidget(),
          SizedBox(height: AppSizes.s32),
          Obx(
            () => HomeCategoriesWidget(
              categories: controller.categories.toList(),
            ),
          ),
          SizedBox(height: AppSizes.s24),
          AppSectionHeader(
            title: 'picked_this_morning'.tr,
            subtitle: 'picked_this_morning_subtitle'.tr,
          ),
          SizedBox(height: AppSizes.s16),
          Obx(() {
            if (controller.isLoadingProducts.value) {
              return const ProductHorizontalSkeleton();
            }
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
