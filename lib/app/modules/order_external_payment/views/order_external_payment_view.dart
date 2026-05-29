import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/order_external_payment/controllers/order_external_payment_controller.dart';
import 'package:get/get.dart';

class OrderExternalPaymentView extends GetView<OrderExternalPaymentController> {
  const OrderExternalPaymentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('complete_payment'.tr),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: controller.cancelPayment,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Icon(
                Icons.payment,
                size: 80,
                color: Colors.blue,
              ),
              const SizedBox(height: 24),
              Text(
                'waiting_for_payment'.tr,
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'please_complete_payment_within'.tr,
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Obx(
                () => Text(
                  controller.formattedTime,
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: controller.remainingSeconds.value < 60
                        ? Colors.red
                        : Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 48),
              Obx(
                () => SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: controller.isProcessing.value
                        ? null
                        : controller.simulatePayment,
                    child: controller.isProcessing.value
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text('simulate_payment_success'.tr),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: controller.cancelPayment,
                child: Text('cancel_order'.tr),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
