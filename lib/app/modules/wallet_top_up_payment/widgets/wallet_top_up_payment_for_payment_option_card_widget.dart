import 'package:flutter/material.dart';
import 'package:fresh_leaf/core/models/payment_method.dart';
import 'package:fresh_leaf/shared/helpers/responsive_helper.dart';
import 'package:get/get.dart';

class WalletTopUpPaymentForPaymentOptionCardWidget extends StatelessWidget {
  const WalletTopUpPaymentForPaymentOptionCardWidget({
    required this.method,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  final PaymentMethod method;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final typeCode = (method.paymentMethodType?.code ?? '').toLowerCase();
    final isBankChannel = typeCode == 'aba' || typeCode == 'acleda';
    final label = (method.label?.isNotEmpty ?? false)
        ? method.label!
        : (method.paymentMethodType?.name ?? 'payment_method'.tr);
    final number = method.cardNumber.replaceAll(RegExp('[^0-9]'), '');
    final last4 = number.length >= 4
        ? number.substring(number.length - 4)
        : number.padLeft(4, '*');

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
                      '•••• $last4',
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
              isSelected
                  ? Icons.check_circle_rounded
                  : Icons.radio_button_unchecked_rounded,
              color: isSelected ? scheme.primary : scheme.onSurfaceVariant,
              size: 20.scaled,
            ),
          ],
        ),
      ),
    );
  }
}
