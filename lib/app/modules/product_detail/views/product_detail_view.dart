import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/product_detail/controllers/product_detail_controller.dart';
import 'package:fresh_leaf/app/modules/product_detail/widgets/product_detail_widget.dart';
import 'package:get/get.dart';

class ProductDetailView extends GetView<ProductDetailController> {
  const ProductDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final scaffoldBg = Theme.of(context).scaffoldBackgroundColor;
    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: AppBar(
        backgroundColor: scaffoldBg,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: scheme.onSurface),
          onPressed: Get.back,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite_border, color: scheme.onSurface),
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
                controller.subtitle.tr,
                style: TextStyle(
                  color: scheme.onSurfaceVariant,
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
              Text(
                'about_this_item'.tr,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: scheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                controller.description.tr,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.6,
                  color: scheme.onSurfaceVariant,
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
