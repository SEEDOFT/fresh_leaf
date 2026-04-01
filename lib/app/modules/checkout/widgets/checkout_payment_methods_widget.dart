import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CheckoutPaymentMethodsWidget extends StatelessWidget {
  const CheckoutPaymentMethodsWidget({
    required this.methods,
    required this.selectedMethod,
    required this.onSelect,
    super.key,
  });

  final List<String> methods;
  final String selectedMethod;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: scheme.outline.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'payment_method'.tr,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: scheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          ...methods.map(
            (method) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: GestureDetector(
                onTap: () => onSelect(method),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: selectedMethod == method
                        ? scheme.primaryContainer.withValues(alpha: 0.55)
                        : scheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: selectedMethod == method
                          ? scheme.primary
                          : scheme.outline.withValues(alpha: 0.35),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        selectedMethod == method
                            ? Icons.radio_button_checked
                            : Icons.radio_button_unchecked,
                        color: selectedMethod == method
                            ? scheme.primary
                            : scheme.onSurfaceVariant,
                        size: 18,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        _displayLabel(method).tr,
                        style: TextStyle(
                          color: scheme.onSurface,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _displayLabel(String method) {
    switch (method) {
      case 'Cash on Delivery':
        return 'cash_on_delivery';
      case 'Credit/Debit Card':
        return 'credit_debit_card';
      default:
        return method;
    }
  }
}
