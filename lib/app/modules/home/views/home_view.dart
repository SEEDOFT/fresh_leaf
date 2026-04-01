import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/cart/views/cart_panel_view.dart';
import 'package:fresh_leaf/app/modules/home/controllers/home_controller.dart';
import 'package:fresh_leaf/app/modules/home/widgets/home_widget.dart';
import 'package:get/get.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final scaffoldBg = Theme.of(context).scaffoldBackgroundColor;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: scaffoldBg,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: showCartPanel,
        icon: const Icon(Icons.shopping_cart_outlined),
        label: Text('cart'.tr),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: controller.refreshHome,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HomeAppBarWidget(),
                const SizedBox(height: 24),
                const HomeHeroCardWidget(),
                const SizedBox(height: 32),
                HomeCategoriesWidget(
                  categories: controller.categories.toList(),
                ),
                const SizedBox(height: 24),
                HomeSectionHeaderWidget(
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
          ),
        ),
      ),
    );
  }
}
