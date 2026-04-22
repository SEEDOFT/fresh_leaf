import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/wallet_top_up/controllers/wallet_top_up_controller.dart';
import 'package:fresh_leaf/app/modules/wallet_top_up/widgets/wallet_top_up_amount_input_widget.dart';
import 'package:fresh_leaf/app/modules/wallet_top_up/widgets/wallet_top_up_presets_widget.dart';
import 'package:fresh_leaf/shared/helpers/responsive_helper.dart';
import 'package:fresh_leaf/shared/widgets/app_scaffold.dart';
import 'package:fresh_leaf/shared/widgets/custom_app_bar.dart';
import 'package:fresh_leaf/shared/widgets/primary_button.dart';
import 'package:get/get.dart';

class WalletTopUpView extends GetView<WalletTopUpController> {
  const WalletTopUpView({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return AppScaffold(
      appBar: CustomAppBar(
        title: '${'top_up'.tr} (${controller.selectedCurrency.value})',
      ),
      body: Padding(
        padding: EdgeInsets.all(20.scaled),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            WalletTopUpAmountInputWidget(controller: controller),
            SizedBox(height: 24.scaled),
            WalletTopUpPresetsWidget(controller: controller),
            const Spacer(),
            Obx(
              () => PrimaryButton(
                label: 'proceed_to_payment'.tr,
                onPressed: controller.proceedToPayment,
                isLoading: controller.isLoading.value,
                height: 56.scaled,
              ),
            ),
            SizedBox(height: 12.scaled),
            Center(
              child: Text(
                'secure_payment_notice'.tr,
                style: TextStyle(
                  fontSize: 12.scaled,
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
