import 'package:get/get.dart';
import 'package:fresh_leaf/app/modules/orders/models/order.dart';
import 'package:fresh_leaf/app/modules/product_detail/models/product_info.dart';
import 'package:fresh_leaf/core/services/pin_security_service.dart';

class OrderDetailController extends GetxController {
  final Rxn<Order> order = Rxn<Order>();
  final RxBool isCheckingAccess = true.obs;

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

  @override
  void onReady() {
    super.onReady();
    _verifyAccess();
  }

  Future<void> _verifyAccess() async {
    isCheckingAccess.value = true;
    final canOpen = await PinSecurityService.verifyOrderAccess();
    isCheckingAccess.value = false;
    if (!canOpen) {
      Get.back();
    }
  }

  ProductInfo toProductInfo(Map<String, dynamic> item) {
    return ProductInfo(
      title: item['name'] as String? ?? 'product'.tr,
      subtitle: 'order_product_subtitle'.tr,
      description: 'order_product_description'.tr,
      imageUrl:
          'https://images.unsplash.com/photo-1542838132-92c53300491e?q=80&w=1000',
      tags: ['organic'.tr, 'fresh'.tr],
      price: (item['price'] as num?)?.toDouble() ?? 0.0,
      origin: 'local_farm'.tr,
      harvest: 'harvest_spring_2026'.tr,
      storage: 'refrigerate'.tr,
    );
  }
}
