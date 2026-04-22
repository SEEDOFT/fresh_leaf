import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/wallet_top_up_payment/controllers/wallet_top_up_payment_controller.dart';
import 'package:fresh_leaf/app/modules/wallet_top_up_payment/widgets/wallet_top_up_payment_for_payment_option_card_widget.dart';
import 'package:fresh_leaf/shared/helpers/responsive_helper.dart';
import 'package:fresh_leaf/shared/widgets/app_empty_state.dart';
import 'package:fresh_leaf/shared/widgets/app_scaffold.dart';
import 'package:fresh_leaf/shared/widgets/custom_app_bar.dart';
import 'package:fresh_leaf/shared/widgets/primary_button.dart';
import 'package:get/get.dart';

class WalletTopUpPaymentView extends GetView<WalletTopUpPaymentController> {
  const WalletTopUpPaymentView({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return AppScaffold(
      scrollable: false,
      appBar: CustomAppBar(title: 'choose_payment_method'.tr),
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: controller.refreshPaymentMethods,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                // padding: EdgeInsets.fromLTRB(
                //   20.scaled,
                //   8.scaled,
                //   20.scaled,
                //   20.scaled,
                // ),
                children: [
                  Container(
                    padding: EdgeInsets.all(16.scaled),
                    decoration: BoxDecoration(
                      color: scheme.surfaceContainerHighest.withValues(
                        alpha: 0.3,
                      ),
                      borderRadius: BorderRadius.circular(16.scaled),
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
                        Obx(
                          () => Text(
                            '${controller.currency.value} • '
                            '${controller.formattedAmount}',
                            style: TextStyle(
                              fontSize: 14.scaled,
                              color: scheme.onSurface,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 14.scaled),
                  Obx(() {
                    if (controller.isLoading.value &&
                        controller.displayMethods.isEmpty) {
                      return Padding(
                        padding: EdgeInsets.only(top: 60.scaled),
                        child: const Center(child: CircularProgressIndicator()),
                      );
                    }

                    if (controller.displayMethods.isEmpty) {
                      return AppEmptyState(
                        icon: Icons.credit_card_off_outlined,
                        title: 'no_payment_methods_yet'.tr,
                        subtitle: 'add_payment_method_to_continue_top_up'.tr,
                        actionLabel: 'add_payment_method'.tr,
                        onActionPressed: controller.openAddPaymentMethod,
                      );
                    }

                    final options = controller.displayMethods;
                    return Column(
                      children: options
                          .map(
                            (method) => Padding(
                              padding: EdgeInsets.only(bottom: 10.scaled),
                              child:
                                  WalletTopUpPaymentForPaymentOptionCardWidget(
                                    method: method,
                                    isSelected:
                                        controller.selectedMethodId.value ==
                                        (method.id ?? 0).toString(),
                                    onTap: () =>
                                        controller.selectMethod(method),
                                  ),
                            ),
                          )
                          .toList(),
                    );
                  }),
                ],
              ),
            ),
          ),
          Obx(
            () => PrimaryButton(
              label: 'pay_amount'.trParams({
                'amount': controller.formattedAmount,
              }),
              onPressed: controller.selectedMethod == null
                  ? null
                  : controller.confirmSelection,
              height: 54.scaled,
            ),
          ),
        ],
      ),
    );
  }
}
