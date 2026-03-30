import 'package:flutter/material.dart';
import 'package:fresh_leaf/core/theme/app_colors.dart';

class CheckoutPaymentMethodsWidget extends StatelessWidget {
  const CheckoutPaymentMethodsWidget({
    super.key,
    required this.methods,
    required this.selectedMethod,
    required this.onSelect,
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
        border: Border.all(color: AppColors.grayBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment Method',
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
                        ? AppColors.accentLime.withValues(alpha: 0.22)
                        : scheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: selectedMethod == method
                          ? AppColors.primaryDarkGreen
                          : AppColors.grayBorder,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        selectedMethod == method
                            ? Icons.radio_button_checked
                            : Icons.radio_button_unchecked,
                        color: selectedMethod == method
                            ? AppColors.primaryDarkGreen
                            : scheme.onSurfaceVariant,
                        size: 18,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        method,
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
}
