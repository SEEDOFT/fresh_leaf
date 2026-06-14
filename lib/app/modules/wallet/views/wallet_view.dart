import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/wallet/controllers/wallet_controller.dart';
import 'package:fresh_leaf/app/modules/wallet/widgets/wallet_tab_content_widget.dart';
import 'package:fresh_leaf/shared/helpers/responsive_helper.dart';
import 'package:fresh_leaf/shared/widgets/app_scaffold.dart';
import 'package:fresh_leaf/shared/widgets/custom_app_bar.dart';
import 'package:get/get.dart';

class WalletView extends GetView<WalletController> {
  const WalletView({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return AppScaffold(
      scrollable: false,
      padding: EdgeInsets.zero,
      appBar: CustomAppBar(
        title: 'my_wallet'.tr,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(
              20.scaled,
              0,
              20.scaled,
              12.scaled,
            ),
            padding: EdgeInsets.all(4.scaled),
            decoration: BoxDecoration(
              color: scheme.surfaceContainerHighest.withValues(alpha: 0.55),
              borderRadius: BorderRadius.circular(16.scaled),
              border: Border.all(
                color: scheme.outline.withValues(alpha: 0.12),
              ),
            ),
            child: Obx(
              () => Row(
                children: WalletController.supportedCurrencies.map((currency) {
                  final isSelected =
                      controller.selectedCurrency.value == currency;
                  return Expanded(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeOutCubic,
                      margin: EdgeInsets.symmetric(horizontal: 2.scaled),
                      decoration: BoxDecoration(
                        gradient: isSelected
                            ? LinearGradient(
                                colors: [
                                  scheme.primary,
                                  scheme.primary.withValues(alpha: 0.78),
                                ],
                              )
                            : null,
                        color: isSelected ? null : Colors.transparent,
                        borderRadius: BorderRadius.circular(12.scaled),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: scheme.primary.withValues(alpha: 0.16),
                                  blurRadius: 10.scaled,
                                  offset: Offset(0, 4.scaled),
                                ),
                              ]
                            : null,
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12.scaled),
                          onTap: () => controller.setCurrency(currency),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 9.scaled,
                            ),
                            child: Text(
                              currency,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13.scaled,
                                fontWeight: FontWeight.w700,
                                color: isSelected
                                    ? Colors.white
                                    : scheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const Expanded(
            child: WalletTabContentWidget(),
          ),
        ],
      ),
    );
  }
}
