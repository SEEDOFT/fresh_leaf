import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/cart/bindings/cart_binding.dart';
import 'package:fresh_leaf/app/modules/cart/controllers/cart_controller.dart';
import 'package:fresh_leaf/app/modules/cart/views/cart_panel_view.dart';
import 'package:fresh_leaf/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:fresh_leaf/app/modules/home/controllers/home_controller.dart';
import 'package:fresh_leaf/app/modules/home/widgets/home_widget.dart';
import 'package:fresh_leaf/core/constants/app_sizes.dart';
import 'package:fresh_leaf/shared/widgets/app_scaffold.dart';
import 'package:fresh_leaf/shared/widgets/skeleton_loading_widget.dart';
import 'package:get/get.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      onRefresh: controller.refreshHome,
      padding: EdgeInsets.symmetric(vertical: AppSizes.s20),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Obx(() {
            if (!Get.isRegistered<CartController>()) {
              CartBinding().dependencies();
            }
            final cartController = Get.find<CartController>();
            final count = cartController.items.length;

            return FloatingActionButton.extended(
              heroTag: 'cart_fab',
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
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HomeAppBarWidget(),
          SizedBox(height: AppSizes.s24),
          const HomeActiveOrdersWidget(),
          SizedBox(height: AppSizes.s32),
          Obx(
            () => HomeCategoriesWidget(
              categories: controller.categories.toList(),
            ),
          ),
          SizedBox(height: AppSizes.s24),
          Padding(
            padding: EdgeInsets.only(left: AppSizes.s24),
            child: Obx(() {
              final filter = controller.selectedFilter.value;
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _FilterChip(
                      title: 'picked_this_morning'.tr,
                      isActive: filter == 'picked',
                      onTap: () => controller.selectedFilter.value = 'picked',
                    ),
                    SizedBox(width: AppSizes.s8),
                    _FilterChip(
                      title: 'Top Rated',
                      isActive: filter == 'top_rated',
                      onTap: () =>
                          controller.selectedFilter.value = 'top_rated',
                    ),
                    SizedBox(width: AppSizes.s8),
                    _FilterChip(
                      title: 'New Arrivals',
                      isActive: filter == 'new',
                      onTap: () => controller.selectedFilter.value = 'new',
                    ),
                  ],
                ),
              );
            }),
          ),
          SizedBox(height: AppSizes.s16),
          Obx(() {
            if (controller.isLoadingProducts.value) {
              return const ProductHorizontalSkeleton();
            }
            final products = controller.filteredProductsByTab;
            return HomeHorizontalProductsWidget(
              pickedThisMorning: products,
            );
          }),
          SizedBox(height: AppSizes.s32),
          GestureDetector(
            onTap: () {
              Get.find<DashboardController>().currentIndex = 2;
            },
            child: const HomeAIBannerWidget(),
          ),
          SizedBox(height: AppSizes.s80), // extra space for FABs
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.title,
    required this.isActive,
    required this.onTap,
  });

  final String title;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? scheme.primary : scheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isActive ? scheme.onPrimary : scheme.onSurfaceVariant,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
