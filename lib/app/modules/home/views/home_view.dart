import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/home/widgets/home_widget.dart';
import 'package:fresh_leaf/core/theme/app_colors.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HomeAppBarWidget(),
                const SizedBox(height: 18),
                HomeSearchBarWidget(
                  onChanged: controller.updateSearchQuery,
                ),
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
                Obx(
                  () => HomeHorizontalProductsWidget(
                    pickedThisMorning: controller.filteredPickedThisMorning,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
