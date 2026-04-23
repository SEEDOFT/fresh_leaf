import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/wallet_top_up_payment/controllers/wallet_top_up_payment_controller.dart';
import 'package:fresh_leaf/core/constants/payment_method_type_codes.dart';
import 'package:fresh_leaf/shared/helpers/responsive_helper.dart';
import 'package:get/get.dart';

class WalletTopUpPaymentForPaymentOptionCardWidget extends StatelessWidget {
  const WalletTopUpPaymentForPaymentOptionCardWidget({
    required this.option,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  final WalletTopUpChannelOption option;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final typeCode = option.typeCode.toLowerCase();
    final isBankChannel = typeCode == PaymentMethodTypeCodes.aba ||
        typeCode == PaymentMethodTypeCodes.acleda;
    final isCreditDebit = option.isCreditDebit;
    final label = option.label;

    return InkWell(
      borderRadius: BorderRadius.circular(14.scaled),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsets.all(14.scaled),
        decoration: BoxDecoration(
          color: isSelected
              ? scheme.primary.withValues(alpha: 0.12)
              : scheme.surfaceContainerHighest.withValues(alpha: 0.25),
          borderRadius: BorderRadius.circular(14.scaled),
          border: Border.all(
            color: isSelected
                ? scheme.primary.withValues(alpha: 0.9)
                : scheme.outline.withValues(alpha: 0.14),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40.scaled,
              height: 40.scaled,
              decoration: BoxDecoration(
                color: isSelected
                    ? scheme.primary.withValues(alpha: 0.2)
                    : scheme.surface,
                borderRadius: BorderRadius.circular(10.scaled),
              ),
              child: Icon(
                isBankChannel ? Icons.account_balance : Icons.credit_card,
                color: isSelected ? scheme.primary : scheme.onSurfaceVariant,
                size: 20.scaled,
              ),
            ),
            SizedBox(width: 12.scaled),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 14.scaled,
                      fontWeight: FontWeight.w700,
                      color: scheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 2.scaled),
                  if (!isBankChannel)
                    Text(
                      isCreditDebit
                          ? 'your_payment_methods'.tr
                          : 'credit_debit_card'.tr,
                      style: TextStyle(
                        fontSize: 12.scaled,
                        color: scheme.onSurfaceVariant,
                      ),
                    )
                  else
                    Text(
                      'bank_app_redirect'.tr,
                      style: TextStyle(
                        fontSize: 12.scaled,
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                ],
              ),
            ),
            Icon(
              isCreditDebit
                  ? Icons.chevron_right_rounded
                  : (isSelected
                        ? Icons.check_circle_rounded
                        : Icons.radio_button_unchecked_rounded),
              color: isSelected ? scheme.primary : scheme.onSurfaceVariant,
              size: 20.scaled,
            ),
          ],
        ),
      ),
    );
  }
}
