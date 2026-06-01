import 'dart:async';

import 'package:dio/dio.dart';
import 'package:fresh_leaf/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:fresh_leaf/app/routes/app_routes.dart';
import 'package:fresh_leaf/core/services/api_client.dart';
import 'package:fresh_leaf/shared/helpers/helper.dart';
import 'package:get/get.dart';

class OrderExternalPaymentController extends GetxController {
  OrderExternalPaymentController({
    required ApiClient apiClient,
    required DashboardController dashboardController,
  }) : _apiClient = apiClient,
       _dashboardController = dashboardController;

  final ApiClient _apiClient;
  final DashboardController _dashboardController;
  final RxList<int> orderIds = <int>[].obs;
  final RxInt remainingSeconds = 300.obs; // 5 minutes
  final RxBool isProcessing = false.obs;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null && args is Map<String, dynamic>) {
      if (args['order_ids'] != null) {
        orderIds.assignAll(args['order_ids'] as List<int>);
      } else if (args['order_id'] != null) {
        orderIds.add(args['order_id'] as int);
      }
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

  Future<void> simulatePayment() async {
    if (orderIds.isEmpty || isProcessing.value) return;

    isProcessing.value = true;
    _timer?.cancel();

    try {
      for (final id in orderIds) {
        await _apiClient.postRequest(
          '/orders/$id/simulate-external-payment',
        );
      }

      Get.snackbar(
        'success'.tr,
        orderIds.length == 1
            ? 'order_on_the_way_one'.trParams({'count': '1'})
            : 'order_on_the_way_other'.trParams({
                'count': orderIds.length.toString(),
              }),
      );

      unawaited(Get.offAllNamed<void>(AppRoutes.dashboard));
      _dashboardController.currentIndex = 3; // Orders tab
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
