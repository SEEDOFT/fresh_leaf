import 'package:flutter/material.dart';
import 'package:fresh_leaf/core/models/payment_method.dart';

class ProfilePaymentMethodCard extends StatelessWidget {
  const ProfilePaymentMethodCard({
    required this.method,
    required this.isProcessing,
    required this.onEdit,
    required this.onSetDefault,
    required this.onRemove,
    super.key,
  });

  final PaymentMethod method;
  final bool isProcessing;
  final VoidCallback onEdit;
  final VoidCallback onSetDefault;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final media = MediaQuery.of(context);
    final month = method.expiryMonth.clamp(1, 12);
    final year = method.expiryYear % 100;

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
              _PaymentBrandAvatar(brand: method.brand, color: scheme.primary),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      method.brand.isNotEmpty ? method.brand : 'Card',
                      style: TextStyle(
                        color: scheme.onSurface,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '•••• ${method.last4}',
                      style: TextStyle(
                        color: scheme.onSurfaceVariant,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              if (method.isDefault)
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
                    'Default',
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
                'Exp ${month.toString().padLeft(2, '0')}/${year.toString().padLeft(2, '0')}',
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
                method.type.isNotEmpty ? method.type : 'Secure',
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
                  child: const Text('Edit'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: (isProcessing || method.isDefault)
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
                      : const Text('Set as default'),
                ),
              ),
              const SizedBox(width: 6),
              TextButton(
                onPressed: isProcessing ? null : onRemove,
                style: TextButton.styleFrom(
                  foregroundColor: scheme.error,
                ),
                child: const Text('Remove'),
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
