import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/wallet_top_up/controllers/wallet_top_up_controller.dart';
import 'package:fresh_leaf/shared/helpers/responsive_helper.dart';
import 'package:fresh_leaf/shared/widgets/app_text_field.dart';
import 'package:get/get.dart';

class WalletTopUpAmountInputWidget extends StatelessWidget {
  const WalletTopUpAmountInputWidget({
    required this.controller,
    super.key,
  });

  final WalletTopUpController controller;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'enter_amount'.tr,
          style: TextStyle(
            fontSize: 16.scaled,
            fontWeight: FontWeight.bold,
            color: scheme.onSurface,
          ),
        ),
        SizedBox(height: 16.scaled),
        AppTextField(
          label: 'amount'.tr,
          controller: controller.amountController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          hintText: controller.selectedCurrency.value == 'USD' ? '0.00' : '0',
          prefixIcon: Icon(
            controller.selectedCurrency.value == 'USD'
                ? Icons.attach_money
                : Icons.money,
            color: scheme.primary,
          ),
        ),
      ],
    );
  }
}
