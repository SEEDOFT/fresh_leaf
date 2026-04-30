import 'dart:async';

import 'package:dio/dio.dart';
import 'package:fresh_leaf/core/models/payment_session.dart';
import 'package:fresh_leaf/core/services/payment_session_service.dart';
import 'package:fresh_leaf/shared/helpers/helper.dart';
import 'package:get/get.dart';

class PaymentQrController extends GetxController {
  final Rxn<PaymentSession> session = Rxn<PaymentSession>();
  final RxBool isChecking = false.obs;
  final RxInt remainingSeconds = 0.obs;

  Timer? _countdownTimer;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map<String, dynamic>) {
      final raw = args['session'];
      if (raw is PaymentSession) {
        session.value = raw;
      } else if (raw is Map<String, dynamic>) {
        session.value = PaymentSession.fromMap(raw);
      }
    }
    _syncRemaining();
    _countdownTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => _syncRemaining(),
    );
  }

  bool get isExpired => remainingSeconds.value <= 0;

  Future<void> refreshStatus() async {
    final current = session.value;
    if (current == null || current.sessionId.isEmpty || isChecking.value) {
      return;
    }
    isChecking.value = true;
    try {
      final service = Get.find<PaymentSessionService>();
      final latest = await service.getSessionStatus(current.sessionId);
      session.value = latest;
      _syncRemaining();
      if (latest.isPaid) {
        Get.back<bool>(result: true);
      }
    } on DioException catch (error) {
      Get.snackbar(
        'fetch_failed'.tr,
        parseApiErrorMessage(
          error,
          fallback: 'unable_check_payment_status'.tr,
        ),
      );
    } on Exception {
      Get.snackbar('fetch_failed'.tr, 'unable_check_payment_status'.tr);
    } finally {
      isChecking.value = false;
    }
  }

  void _syncRemaining() {
    final expiresAt = session.value?.expiresAt;
    if (expiresAt == null) {
      remainingSeconds.value = 0;
      return;
    }
    final diff = expiresAt.difference(DateTime.now()).inSeconds;
    remainingSeconds.value = diff > 0 ? diff : 0;
  }

  @override
  void onClose() {
    _countdownTimer?.cancel();
    super.onClose();
  }
}
