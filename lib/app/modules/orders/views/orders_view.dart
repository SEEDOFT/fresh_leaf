import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fresh_leaf/app/modules/orders/widgets/orders_widget.dart';
import 'package:fresh_leaf/app/modules/product_detail/models/product_info.dart';
import '../controllers/orders_controller.dart';

class OrdersView extends GetView<OrdersController> {
  const OrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Obx(
          () => controller.isLoading.value
              ? const OrdersLoadingWidget()
              : controller.orders.isEmpty
              ? const EmptyOrdersWidget()
              : OrdersListWidget(
                  orders: controller.orders,
                  onOrderTap: (order) {
                    // Convert order first item to product info for demo
                    // In a real app, you'd fetch product details from API
                    if (order.items.isNotEmpty) {
                      final firstItem = order.items.first;
                      final productInfo = ProductInfo(
                        title: firstItem['name'] as String? ?? 'Product',
                        subtitle: 'Fresh from our farms',
                        description: 'High-quality organic product',
                        imageUrl:
                            'https://images.unsplash.com/photo-1542838132-92c53300491e?q=80&w=1000',
                        tags: ['Organic', 'Fresh'],
                        price: (firstItem['price'] as num?)?.toDouble() ?? 0.0,
                        origin: 'Local Farm',
                        harvest: 'Spring 2026',
                        storage: 'Refrigerate',
                      );
                      Get.toNamed('/product_detail', arguments: productInfo);
                    }
                  },
                ),
        ),
      ),
    );
  }
}
