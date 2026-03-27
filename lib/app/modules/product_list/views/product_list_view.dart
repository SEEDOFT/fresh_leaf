import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fresh_leaf/app/modules/product_list/widgets/product_list_widget.dart';
import 'package:fresh_leaf/app/modules/product_list/controllers/product_list_controller.dart';

class ProductListView extends GetView<ProductListController> {
  const ProductListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: Get.back,
        ),
        title: const Text(
          'All Products',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
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
              : GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
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
                ),
        ),
      ),
    );
  }
}
