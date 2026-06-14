import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/cart/bindings/cart_binding.dart';
import 'package:fresh_leaf/app/modules/cart/controllers/cart_controller.dart';
import 'package:fresh_leaf/app/modules/cart/views/cart_panel_view.dart';
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
    final scheme = Theme.of(context).colorScheme;
    return AppScaffold(
      scrollable: false,
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          return RefreshIndicator(
            onRefresh: controller.refreshHome,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
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
                                  onTap: () => controller.selectedFilter.value =
                                      'picked',
                                ),
                                SizedBox(width: AppSizes.s8),
                                _FilterChip(
                                  title: 'Top Rated',
                                  isActive: filter == 'top_rated',
                                  onTap: () => controller.selectedFilter.value =
                                      'top_rated',
                                ),
                                SizedBox(width: AppSizes.s8),
                                _FilterChip(
                                  title: 'New Arrivals',
                                  isActive: filter == 'new',
                                  onTap: () =>
                                      controller.selectedFilter.value = 'new',
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
                      const HomePromotionCarouselWidget(),
                    ],
                  ),
                ),
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: AppSizes.s32),
                        Divider(
                          height: 1,
                          indent: 24,
                          endIndent: 24,
                          color: scheme.outlineVariant.withValues(alpha: 0.3),
                        ),
                        SizedBox(height: AppSizes.s16),
                        Text(
                          'FreshLeaf Organics\nFresh, organic produce '
                          'delivered to your door.',
                          style: TextStyle(
                            fontSize: 12,
                            color: scheme.onSurfaceVariant.withValues(
                              alpha: 0.6,
                            ),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: AppSizes.s8),
                        Text(
                          'FreshLeaf \nv0.1.0',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: scheme.onSurfaceVariant.withValues(
                              alpha: 0.4,
                            ),
                          ),
                        ),
                        Obx(
                          () {
                            final wd = controller.clockWeekday.value;
                            final d = controller.clockDay.value;
                            final ord = controller.clockOrdinal.value;
                            final my = controller.clockMonthYear.value;
                            return RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                style: TextStyle(
                                  fontSize: 11,
                                  color: scheme.onSurfaceVariant
                                      .withValues(alpha: 0.4),
                                ),
                                children: [
                                  TextSpan(text: '$wd $d'),
                                  WidgetSpan(
                                    baseline: TextBaseline.alphabetic,
                                    alignment: PlaceholderAlignment
                                        .aboveBaseline,
                                    child: Text(
                                      ord,
                                      style: TextStyle(
                                        fontSize: 7,
                                        color: scheme.onSurfaceVariant
                                            .withValues(alpha: 0.4),
                                      ),
                                    ),
                                  ),
                                  TextSpan(text: ' $my'),
                                ],
                              ),
                            );
                          },
                        ),
                        Obx(
                          () => Text(
                            controller.clockTime.value,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 11,
                              color: scheme.onSurfaceVariant
                                  .withValues(alpha: 0.4),
                            ),
                          ),
                        ),
                        SizedBox(height: AppSizes.s16),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
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
