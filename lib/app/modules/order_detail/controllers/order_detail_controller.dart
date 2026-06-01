import 'dart:async';

import 'package:fresh_leaf/core/models/order.dart';
import 'package:fresh_leaf/core/services/order_service.dart';
import 'package:fresh_leaf/core/services/pin_security_service.dart';
import 'package:fresh_leaf/core/services/storage_service.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

class OrderDetailController extends GetxController {
  OrderDetailController({
    required OrderService orderService,
    required StorageService storageService,
  }) : _orderService = orderService,
       _storageService = storageService;

  final OrderService _orderService;
  final StorageService _storageService;

  final Rxn<Order> order = Rxn<Order>();
  final RxBool isCheckingAccess = false.obs;
  final RxBool isUpdating = false.obs;
  final RxBool isLoadingDetails = true.obs;
  int? _orderIdToLoad;

  @override
  void onInit() {
    super.onInit();
    isCheckingAccess.value = _storageService.pinOrderVerification;

    final args = Get.arguments;
    if (args is Order) {
      order.value = args;
      _orderIdToLoad = args.id;
    } else if (args is Map) {
      final id = args['id'] ?? args['order_id'];
      if (id is int) {
        _orderIdToLoad = id;
      } else if (id is String) {
        _orderIdToLoad = int.tryParse(id);
      }
    }
    unawaited(reloadOrder());
  }

  @override
  Future<void> onReady() async {
    super.onReady();
    await _verifyAccess();
  }

  Future<void> _verifyAccess() async {
    if (!_storageService.pinOrderVerification) {
      isCheckingAccess.value = false;
      return;
    }

    isCheckingAccess.value = true;
    final canOpen = await PinSecurityService.verifyOrderAccess();
    isCheckingAccess.value = false;
    if (!canOpen) {
      Get.back<void>();
    }
  }

  Future<void> reloadOrder() async {
    final idToLoad = _orderIdToLoad ?? order.value?.id;
    if (idToLoad == null) return;

    final hasItems = order.value?.items.isNotEmpty ?? false;
    if (!hasItems) {
      isLoadingDetails.value = true;
    } else {
      isUpdating.value = true;
    }

    final updatedOrder = await _orderService.getOrder(idToLoad);
    if (updatedOrder != null) {
      order.value = updatedOrder;
    }
    isLoadingDetails.value = false;
    isUpdating.value = false;
  }

  Future<void> cancelOrder() async {
    if (order.value?.id == null) return;

    isUpdating.value = true;
    final success = await _orderService.cancelOrder(order.value!.id);
    if (success) {
      Get.snackbar('success'.tr, 'order_cancel_success'.tr);
      await reloadOrder();
    } else {
      Get.snackbar('error'.tr, 'failed_cancel_order'.tr);
    }
    isUpdating.value = false;
  }

  Future<void> confirmReceipt() async {
    if (order.value?.id == null) return;

    isUpdating.value = true;
    final success = await _orderService.confirmReceipt(order.value!.id);
    if (success) {
      Get.snackbar('success'.tr, 'order_receipt_confirmed'.tr);
      await reloadOrder();
    } else {
      Get.snackbar('error'.tr, 'failed_confirm_receipt'.tr);
    }
    isUpdating.value = false;
  }

  Future<void> downloadInvoice() async {
    if (order.value?.id == null) return;

    isUpdating.value = true;
    final url = await _orderService.getInvoiceUrl(order.value!.id);
    if (url != null) {
      final uri = Uri.parse(url);
      if (await url_launcher.canLaunchUrl(uri)) {
        await url_launcher.launchUrl(
          uri,
          mode: url_launcher.LaunchMode.externalApplication,
        );
      } else {
        Get.snackbar('error'.tr, 'Could not open invoice URL');
      }
    } else {
      Get.snackbar('error'.tr, 'failed_fetch_invoice_url'.tr);
    }
    isUpdating.value = false;
  }
}
