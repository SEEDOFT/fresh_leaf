import 'dart:async';

import 'package:fresh_leaf/core/models/order.dart';
import 'package:fresh_leaf/core/services/order_service.dart';
import 'package:fresh_leaf/core/services/pin_security_service.dart';
import 'package:get/get.dart';

class OrderDetailController extends GetxController {
  final OrderService _orderService = Get.find<OrderService>();

  final Rxn<Order> order = Rxn<Order>();
  final RxBool isCheckingAccess = true.obs;
  final RxBool isUpdating = false.obs;

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
    unawaited(reloadOrder());
  }

  @override
  Future<void> onReady() async {
    super.onReady();
    await _verifyAccess();
  }

  Future<void> _verifyAccess() async {
    isCheckingAccess.value = true;
    final canOpen = await PinSecurityService.verifyOrderAccess();
    isCheckingAccess.value = false;
    if (!canOpen) {
      Get.back<void>();
    }
  }

  Future<void> reloadOrder() async {
    if (order.value?.id == null) return;

    isUpdating.value = true;
    final updatedOrder = await _orderService.getOrder(order.value!.id);
    if (updatedOrder != null) {
      order.value = updatedOrder;
    }
    isUpdating.value = false;
  }

  Future<void> cancelOrder() async {
    if (order.value?.id == null) return;

    isUpdating.value = true;
    final success = await _orderService.cancelOrder(order.value!.id);
    if (success) {
      Get.snackbar('Success', 'Order cancelled successfully');
      await reloadOrder();
    } else {
      Get.snackbar('Error', 'Failed to cancel order');
    }
    isUpdating.value = false;
  }

  Future<void> confirmReceipt() async {
    if (order.value?.id == null) return;

    isUpdating.value = true;
    final success = await _orderService.confirmReceipt(order.value!.id);
    if (success) {
      Get.snackbar('Success', 'Order receipt confirmed');
      await reloadOrder();
    } else {
      Get.snackbar('Error', 'Failed to confirm receipt');
    }
    isUpdating.value = false;
  }
}
