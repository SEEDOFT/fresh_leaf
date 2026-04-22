import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/wallet_top_up/controllers/wallet_top_up_controller.dart';
import 'package:fresh_leaf/shared/helpers/responsive_helper.dart';
import 'package:get/get.dart';

class WalletTopUpPresetsWidget extends StatelessWidget {
  const WalletTopUpPresetsWidget({
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
          'select_preset_amount'.tr,
          style: TextStyle(
            fontSize: 14.scaled,
            color: scheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 12.scaled),
        Wrap(
          spacing: 12.scaled,
          runSpacing: 12.scaled,
          children:
              (controller.selectedCurrency.value == 'USD'
                      ? controller.usdPresets
                      : controller.khrPresets)
                  .map((amount) {
                    final amountLabel =
                        controller.selectedCurrency.value == 'USD'
                        ? '\$$amount'
                        : '${amount.toInt()} ៛';
                    return Obx(
                      () => ChoiceChip(
                        label: Text(amountLabel),
                        selected: controller.selectedAmount.value == amount,
                        onSelected: (selected) {
                          if (selected) controller.selectPreset(amount);
                        },
                        selectedColor: scheme.primary.withValues(alpha: 0.2),
                        labelStyle: TextStyle(
                          color: controller.selectedAmount.value == amount
                              ? scheme.primary
                              : scheme.onSurface,
                          fontWeight: controller.selectedAmount.value == amount
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                        backgroundColor: scheme.surface,
                        side: BorderSide(
                          color: controller.selectedAmount.value == amount
                              ? scheme.primary
                              : scheme.outline.withValues(alpha: 0.2),
                        ),
                      ),
                    );
                  })
                  .toList(),
        ),
      ],
    );
  }
}
