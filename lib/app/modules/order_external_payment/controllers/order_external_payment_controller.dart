import 'dart:async';

import 'package:dio/dio.dart';
import 'package:fresh_leaf/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:fresh_leaf/app/routes/app_routes.dart';
import 'package:fresh_leaf/core/services/api_client.dart';
import 'package:fresh_leaf/shared/helpers/helper.dart';
import 'package:get/get.dart';

class OrderExternalPaymentController extends GetxController {
  final RxInt orderId = 0.obs;
  final RxInt remainingSeconds = 300.obs; // 5 minutes
  final RxBool isProcessing = false.obs;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null && args is Map<String, dynamic>) {
      orderId.value = args['order_id'] as int? ?? 0;
    }
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds.value > 0) {
        remainingSeconds.value--;
      } else {
        _timer?.cancel();
        _handleTimeout();
      }
    });
  }

  Future<void> simulatePaymentSuccess() async {
    if (orderId.value == 0 || isProcessing.value) return;

    isProcessing.value = true;
    _timer?.cancel();

    try {
      final apiClient = Get.find<ApiClient>();
      await apiClient.postRequest(
        '/orders/${orderId.value}/simulate-external-payment',
      );

      Get.snackbar(
        'success'.tr,
        'order_on_the_way_one'.trParams({'count': '1'}),
      );

      if (Get.isRegistered<DashboardController>()) {
        unawaited(Get.offAllNamed<void>(AppRoutes.dashboard));
        Get.find<DashboardController>().currentIndex = 3; // Orders tab
      } else {
        unawaited(Get.offAllNamed<void>(AppRoutes.orders));
      }
    } on DioException catch (error) {
      Get.snackbar(
        'payment_failed'.tr,
        parseApiErrorMessage(
          error,
          fallback: 'unable_to_process_payment'.tr,
        ),
      );
      isProcessing.value = false;
      _startTimer(); // resume timer on failure
    } on Exception {
      Get.snackbar('payment_failed'.tr, 'unable_to_process_payment'.tr);
      isProcessing.value = false;
      _startTimer();
    }
  }

  void _handleTimeout() {
    Get.snackbar(
      'payment_timeout'.tr,
      'order_cancelled_due_to_timeout'.tr,
      snackPosition: SnackPosition.TOP,
    );
    if (Get.isRegistered<DashboardController>()) {
      unawaited(Get.offAllNamed<void>(AppRoutes.dashboard));
    } else {
      unawaited(Get.offAllNamed<void>(AppRoutes.home));
    }
  }

  void cancelPayment() {
    _timer?.cancel();
    Get.back<void>();
  }

  String get formattedTime {
    final minutes = (remainingSeconds.value / 60).floor();
    final seconds = remainingSeconds.value % 60;
    final minsStr = minutes.toString().padLeft(2, '0');
    final secsStr = seconds.toString().padLeft(2, '0');
    return '$minsStr:$secsStr';
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
