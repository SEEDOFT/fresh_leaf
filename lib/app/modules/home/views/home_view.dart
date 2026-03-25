import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/home/widgets/home_widget.dart';
import 'package:fresh_leaf/core/theme/app_colors.dart';
import 'package:fresh_leaf/shared/widgets/app_bar.dart';
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
              appBar(),
              const SizedBox(height: 24),
              HomeWidget.buildHeroCard(),
              const SizedBox(height: 32),
              HomeWidget.buildCategories(controller),
              const SizedBox(height: 24),
              HomeWidget.buildAIBanner(),
              const SizedBox(height: 32),
              HomeWidget.buildSectionHeader(
                'Picked This Morning',
                'Straight from our local partner farms',
              ),
              const SizedBox(height: 16),
              HomeWidget.buildHorizontalProducts(controller),
            ],
          ),
        ),
      ),
    );
  }
}
