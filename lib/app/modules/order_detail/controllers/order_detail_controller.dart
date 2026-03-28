import 'package:get/get.dart';
import 'package:fresh_leaf/app/modules/orders/models/order.dart';
import 'package:fresh_leaf/app/modules/product_detail/models/product_info.dart';

class OrderDetailController extends GetxController {
  final Rxn<Order> order = Rxn<Order>();

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Order) {
      order.value = args;
    } else if (args is Map<String, dynamic>) {
      order.value = Order.fromMap(args);
    } else if (args is Map) {
      order.value = Order.fromMap(args.cast<String, dynamic>());
    }
  }

  ProductInfo toProductInfo(Map<String, dynamic> item) {
    return ProductInfo(
      title: item['name'] as String? ?? 'Product',
      subtitle: 'Fresh from our farms',
      description: 'High-quality organic product from your order history.',
      imageUrl:
          'https://images.unsplash.com/photo-1542838132-92c53300491e?q=80&w=1000',
      tags: const ['Organic', 'Fresh'],
      price: (item['price'] as num?)?.toDouble() ?? 0.0,
      origin: 'Local Farm',
      harvest: 'Spring 2026',
      storage: 'Refrigerate',
    );
  }
}
