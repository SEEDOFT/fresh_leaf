import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/wallet_top_up_success/controllers/wallet_top_up_success_controller.dart';
import 'package:fresh_leaf/shared/helpers/helper.dart';
import 'package:fresh_leaf/shared/helpers/responsive_helper.dart';
import 'package:fresh_leaf/shared/widgets/primary_button.dart';
import 'package:get/get.dart';

class WalletTopUpSuccessView extends GetView<WalletTopUpSuccessController> {
  const WalletTopUpSuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.theme.colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.scaled),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              // Success Icon
              Container(
                width: 120.scaled,
                height: 120.scaled,
                decoration: BoxDecoration(
                  color: Get.theme.colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_rounded,
                  size: 64.scaled,
                  color: Get.theme.colorScheme.primary,
                ),
              ),
              SizedBox(height: 32.scaled),
              Text(
                'top_up_successful'.tr,
                style: Get.theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Get.theme.colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 16.scaled),
              Text(
                'wallet_seeded_successfully'.tr,
                textAlign: TextAlign.center,
                style: Get.theme.textTheme.bodyLarge?.copyWith(
                  color: Get.theme.colorScheme.onSurfaceVariant,
                ),
              ),
              SizedBox(height: 48.scaled),
              Container(
                padding: EdgeInsets.all(24.scaled),
                decoration: BoxDecoration(
                  color: Get.theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(16.scaled),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'amount'.tr,
                      style: Get.theme.textTheme.titleMedium?.copyWith(
                        color: Get.theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Obx(() {
                      final amount = controller.topUpAmount.value;
                      final isUsd = controller.currency.value == 'USD';
                      final formatted = isUsd
                          ? '\$${formatPrice(amount)}'
                          : '${formatPrice(amount)} ៛';
                      return Text(
                        formatted,
                        style: Get.theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Get.theme.colorScheme.primary,
                        ),
                      );
                    }),
                  ],
                ),
              ),
              const Spacer(),
              PrimaryButton(
                onPressed: controller.done,
                label: 'done'.tr,
              ),
              SizedBox(height: 16.scaled),
            ],
          ),
        ),
      ),
    );
  }
}
