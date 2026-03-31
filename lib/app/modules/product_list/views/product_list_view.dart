import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fresh_leaf/app/modules/product_list/widgets/product_list_widget.dart';
import 'package:fresh_leaf/app/modules/product_list/controllers/product_list_controller.dart';

class ProductListView extends GetView<ProductListController> {
  const ProductListView({super.key});

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
        title: Text(
          'all_products'.tr,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: scheme.onSurface,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Obx(
          () => controller.isLoading.value
              ? const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                  ),
                )
              : LayoutBuilder(
                  builder: (context, constraints) {
                    final screenWidth = MediaQuery.of(context).size.width;

                    final int crossAxisCount;
                    final double itemHeight;
                    if (screenWidth < 360) {
                      crossAxisCount = 1;
                      itemHeight = 260;
                    } else if (screenWidth < 700) {
                      crossAxisCount = 2;
                      itemHeight = 285;
                    } else if (screenWidth < 1024) {
                      crossAxisCount = 3;
                      itemHeight = 305;
                    } else {
                      crossAxisCount = 4;
                      itemHeight = 320;
                    }

                    const double spacing = 16;
                    const double horizontalPadding = 32; // 16 + 16
                    final double itemWidth =
                        (constraints.maxWidth -
                                horizontalPadding -
                                (crossAxisCount - 1) * spacing) /
                            crossAxisCount;

                    return GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        childAspectRatio: itemWidth / itemHeight,
                        crossAxisSpacing: spacing,
                        mainAxisSpacing: spacing,
                      ),
                      itemCount: controller.products.length,
                      itemBuilder: (context, index) {
                        final product = controller.products[index];
                        return ProductListItemWidget(
                          product: product,
                          onTap: () {
                            Get.toNamed('/product_detail', arguments: product);
                          },
                        );
                      },
                    );
                  },
                ),
        ),
      ),
    );
  }
}
