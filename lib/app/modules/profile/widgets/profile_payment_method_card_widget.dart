import 'package:flutter/material.dart';
import 'package:fresh_leaf/core/models/payment_method.dart';
import 'package:get/get.dart';

class ProfilePaymentMethodCard extends StatelessWidget {
  const ProfilePaymentMethodCard({
    required this.paymentMethod,
    required this.isProcessing,
    required this.onEdit,
    required this.onSetDefault,
    required this.onRemove,
    super.key,
  });

  final PaymentMethod paymentMethod;
  final bool isProcessing;
  final VoidCallback onEdit;
  final VoidCallback onSetDefault;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final media = MediaQuery.of(context);
    final month = paymentMethod.expiryMonth.clamp(1, 12);
    final year = paymentMethod.expiryYear % 100;
    final label = paymentMethod.label != null && paymentMethod.label!.isNotEmpty
        ? paymentMethod.label
        : paymentMethod.paymentMethodType?.name;
    final last4 = _resolveLast4(paymentMethod.cardNumber);
    final statusName = paymentMethod.paymentMethodStatus?.name;

    return Container(
      width: media.size.width,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: scheme.outline.withValues(alpha: 0.12)),
        boxShadow: [
          BoxShadow(
            color: scheme.shadow.withValues(alpha: 0.06),
            blurRadius: 14,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _PaymentBrandAvatar(
                brand: label.toString(),
                color: scheme.primary,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label ?? 'payment_method'.tr,
                      style: TextStyle(
                        color: scheme.onSurface,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '•••• $last4',
                      style: TextStyle(
                        color: scheme.onSurfaceVariant,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              if (paymentMethod.isDefault ?? false)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: scheme.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'default'.tr,
                    style: TextStyle(
                      color: scheme.primary,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(
                Icons.calendar_month,
                color: scheme.onSurfaceVariant,
                size: 18,
              ),
              const SizedBox(width: 6),
              Text(
                '${'exp'.tr} ${month.toString().padLeft(2, '0')}/'
                '${year.toString().padLeft(2, '0')}',
                style: TextStyle(
                  color: scheme.onSurfaceVariant,
                  fontSize: 13,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.shield_outlined,
                size: 18,
                color: scheme.onSurfaceVariant,
              ),
              const SizedBox(width: 6),
              Text(
                statusName != null ? statusName.tr : 'status_unknown'.tr,
                style: TextStyle(
                  color: scheme.onSurfaceVariant,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: isProcessing ? null : onEdit,
                  child: Text('edit'.tr),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed:
                      (isProcessing || (paymentMethod.isDefault ?? false))
                      ? null
                      : onSetDefault,
                  child: isProcessing
                      ? SizedBox(
                          height: 14,
                          width: 14,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: scheme.primary,
                          ),
                        )
                      : Text('set_as_default'.tr),
                ),
              ),
              const SizedBox(width: 6),
              TextButton(
                onPressed: isProcessing ? null : onRemove,
                style: TextButton.styleFrom(
                  foregroundColor: scheme.error,
                ),
                child: Text('remove'.tr),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PaymentBrandAvatar extends StatelessWidget {
  const _PaymentBrandAvatar({
    required this.brand,
    required this.color,
  });

  final String brand;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final initials = brand.isNotEmpty ? brand[0] : 'P';
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          initials.toUpperCase(),
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

String _resolveLast4(String cardNumber) {
  final digits = cardNumber.replaceAll(RegExp('[^0-9]'), '');
  if (digits.isEmpty) return '****';
  if (digits.length <= 4) return digits;
  return digits.substring(digits.length - 4);
}
