import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/wallet_top_up/controllers/wallet_top_up_controller.dart';
import 'package:fresh_leaf/app/modules/wallet_top_up/widgets/wallet_top_up_amount_input_widget.dart';
import 'package:fresh_leaf/app/modules/wallet_top_up/widgets/wallet_top_up_for_top_up_section_card_widget.dart';
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
      scrollable: false,
      appBar: CustomAppBar(
        title: '${'top_up'.tr} (${controller.selectedCurrency.value})',
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              // padding: EdgeInsets.fromLTRB(
              //   5.scaled,
              //   5.scaled,
              //   5.scaled,
              //   5.scaled,
              // ),
              children: [
                WalletTopUpForTopUpSectionCardWidget(
                  isProminent: true,
                  child: WalletTopUpAmountInputWidget(controller: controller),
                ),
                SizedBox(height: 8.scaled),
                WalletTopUpForTopUpSectionCardWidget(
                  child: WalletTopUpPresetsWidget(controller: controller),
                ),
                SizedBox(height: 8.scaled),
                Obx(
                  () => Container(
                    padding: EdgeInsets.all(14.scaled),
                    decoration: BoxDecoration(
                      color: scheme.surfaceContainerHighest.withValues(
                        alpha: 0.3,
                      ),
                      borderRadius: BorderRadius.circular(14.scaled),
                      border: Border.all(
                        color: scheme.outline.withValues(alpha: 0.14),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'top_up_summary'.tr,
                          style: TextStyle(
                            fontSize: 13.scaled,
                            color: scheme.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${controller.selectedCurrency.value} • '
                          '${controller.formattedAmount}',
                          style: TextStyle(
                            fontSize: 14.scaled,
                            color: scheme.onSurface,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Obx(
                () => PrimaryButton(
                  label: 'continue_to_payment'.tr,
                  onPressed: controller.isAmountValid.value
                      ? controller.openPaymentSelection
                      : null,
                  isLoading: controller.isLoading.value,
                  height: 56.scaled,
                ),
              ),
              SizedBox(height: 10.scaled),
              Text(
                'secure_payment_notice'.tr,
                style: TextStyle(
                  fontSize: 12.scaled,
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
