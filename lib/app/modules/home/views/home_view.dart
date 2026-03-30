import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/cart/views/cart_panel_view.dart';
import 'package:fresh_leaf/app/modules/home/widgets/home_widget.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final scaffoldBg = Theme.of(context).scaffoldBackgroundColor;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: scaffoldBg,
        floatingActionButton: const FloatingActionButton.extended(
          onPressed: showCartPanel,
          icon: Icon(Icons.shopping_cart_outlined),
          label: Text('Cart'),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HomeAppBarWidget(),
                const SizedBox(height: 24),
                const HomeHeroCardWidget(),
                const SizedBox(height: 32),
                HomeCategoriesWidget(categories: controller.categories),
                const SizedBox(height: 24),
                const HomeSectionHeaderWidget(
                  title: 'Picked This Morning',
                  subtitle: 'Straight from our local partner farms',
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
