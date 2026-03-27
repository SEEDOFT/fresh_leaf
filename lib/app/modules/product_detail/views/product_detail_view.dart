import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/product_detail/controllers/product_detail_controller.dart';
import 'package:fresh_leaf/app/modules/product_detail/widgets/product_detail_widget.dart';
import 'package:fresh_leaf/core/theme/app_colors.dart';
import 'package:get/get.dart';

class ProductDetailView extends GetView<ProductDetailController> {
  const ProductDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textDark),
          onPressed: Get.back,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border, color: AppColors.textDark),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeroImageWidget(imageUrl: controller.imageUrl),
              const SizedBox(height: 20),
              TitleRowWidget(
                title: controller.title,
                origin: controller.origin,
                total: controller.total,
              ),
              const SizedBox(height: 8),
              Text(
                controller.subtitle,
                style: const TextStyle(
                  color: AppColors.textLight,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 12),
              TagsWidget(tags: controller.tags),
              const SizedBox(height: 16),
              InfoTilesWidget(
                harvest: controller.harvest,
                origin: controller.origin,
                storage: controller.storage,
              ),
              const SizedBox(height: 16),
              const Text(
                'About this item',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                controller.description,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.6,
                  color: AppColors.textLight,
                ),
              ),
              const SizedBox(height: 24),
              QuantityRowWidget(
                quantity: controller.quantity.value,
                onIncrement: controller.increment,
                onDecrement: controller.decrement,
              ),
              const SizedBox(height: 20),
              AddButtonWidget(
                total: controller.total,
                onPressed: () {},
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
