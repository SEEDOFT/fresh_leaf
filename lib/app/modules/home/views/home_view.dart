import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/home/widgets/home_widget.dart';
import 'package:fresh_leaf/core/theme/app_colors.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
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
              const HomeAIBannerWidget(),
              const SizedBox(height: 32),
              const HomeSectionHeaderWidget(
                title: 'Picked This Morning',
                subtitle: 'Straight from our local partner farms',
              ),
              const SizedBox(height: 16),
              HomeHorizontalProductsWidget(
                pickedThisMorning: controller.pickedThisMorning,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
