import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fresh_leaf/core/constants/svg_assets.dart';
import 'package:fresh_leaf/core/models/payment_method.dart';
import 'package:fresh_leaf/shared/widgets/app_badge.dart';
import 'package:get/get.dart';

class ProfilePaymentMethodCard extends StatelessWidget {
  const ProfilePaymentMethodCard({
    required this.paymentMethod,
    required this.isProcessing,
    required this.onEdit,
    required this.onRemove,
    super.key,
  });

  final PaymentMethod paymentMethod;
  final bool isProcessing;
  final VoidCallback onEdit;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final month = paymentMethod.expiryMonth;
    final year = paymentMethod.expiryYear % 100;
    final label = paymentMethod.label != null && paymentMethod.label!.isNotEmpty
        ? paymentMethod.label
        : paymentMethod.paymentMethodType?.name;
    final hasCardNumber = paymentMethod.cardNumber.trim().isNotEmpty;
    final last4 = _resolveLast4(paymentMethod.cardNumber);
    final maskedNumber = _resolveMaskedNumber(paymentMethod.cardNumber);
    final statusName = paymentMethod.paymentMethodStatus?.name;
    final brandAsset = _resolveBrandAsset(
      paymentMethod.paymentMethodType?.code,
    );
    final topColor = isDark
        ? scheme.primaryContainer.withValues(alpha: 0.55)
        : scheme.primary.withValues(alpha: 0.11);
    final bottomColor = isDark
        ? scheme.surfaceContainerHighest.withValues(alpha: 0.35)
        : scheme.surface;

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[topColor, bottomColor],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: scheme.outline.withValues(alpha: 0.18)),
        boxShadow: [
          BoxShadow(
            color: scheme.shadow.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _PaymentBrandBadge(
                brandAsset: brandAsset,
                fallbackLabel: label ?? 'payment_method'.tr,
              ),
              const SizedBox(width: 12),
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
                    if (hasCardNumber) ...[
                      const SizedBox(height: 2),
                      Text(
                        '•••• $last4',
                        style: TextStyle(
                          color: scheme.onSurfaceVariant.withValues(alpha: 0.9),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          if (hasCardNumber)
            Text(
              maskedNumber,
              style: TextStyle(
                color: scheme.onSurface,
                fontWeight: FontWeight.w700,
                fontSize: 18,
                letterSpacing: 1.3,
              ),
            ),
          SizedBox(height: hasCardNumber ? 12 : 0),
          Row(
            children: [
              if (hasCardNumber && month > 0)
                _InfoTag(
                  icon: Icons.calendar_month,
                  text:
                      '${'exp'.tr} ${month.toString().padLeft(2, '0')}/'
                      '${year.toString().padLeft(2, '0')}',
                ),
              if (hasCardNumber && month > 0) const SizedBox(width: 8),
              Expanded(
                child: _InfoTag(
                  icon: Icons.shield_outlined,
                  text: statusName != null
                      ? statusName.tr
                      : 'status_unknown'.tr,
                  alignEnd: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: isProcessing ? null : onEdit,
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(44),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'edit'.tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: scheme.primary,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: isProcessing ? null : onRemove,
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(44),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'remove'.tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: scheme.error,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PaymentBrandBadge extends StatelessWidget {
  const _PaymentBrandBadge({
    required this.brandAsset,
    required this.fallbackLabel,
  });

  final String? brandAsset;
  final String fallbackLabel;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final initials = fallbackLabel.isNotEmpty ? fallbackLabel[0] : 'P';

    return Container(
      width: 52,
      height: 34,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: scheme.surface.withValues(alpha: 0.82),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: scheme.outline.withValues(alpha: 0.22),
        ),
      ),
      child: brandAsset != null
          ? SvgPicture.asset(brandAsset!)
          : Center(
              child: Text(
                initials.toUpperCase(),
                style: TextStyle(
                  color: scheme.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
    );
  }
}

class _InfoTag extends StatelessWidget {
  const _InfoTag({
    required this.icon,
    required this.text,
    this.alignEnd = false,
  });

  final IconData icon;
  final String text;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: alignEnd
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      children: [
        AppBadge(
          label: text,
          icon: icon,
          backgroundColor: Colors.transparent,
          foregroundColor: scheme.onSurfaceVariant,
          padding: EdgeInsets.zero,
          fontSize: 12.5,
          fontWeight: FontWeight.w500,
        ),
      ],
    );
  }
}

String _resolveMaskedNumber(String cardNumber) {
  final digits = cardNumber.replaceAll(RegExp('[^0-9]'), '');
  if (digits.isEmpty) {
    return '•••• •••• •••• ••••';
  }

  final cleaned = digits.padLeft(16, '•');
  final group1 = cleaned.substring(0, 4);
  final group2 = cleaned.substring(4, 8);
  final group3 = cleaned.substring(8, 12);
  final group4 = cleaned.substring(12, 16);
  return '$group1 $group2 $group3 $group4';
}

String _resolveLast4(String cardNumber) {
  final digits = cardNumber.replaceAll(RegExp('[^0-9]'), '');
  if (digits.isEmpty) return '****';
  if (digits.length <= 4) return digits;
  return digits.substring(digits.length - 4);
}

String? _resolveBrandAsset(String? typeCode) {
  final code = (typeCode ?? '').trim().toLowerCase();
  switch (code) {
    case 'visa':
      return SvgAssets.visa;
    case 'mastercard':
    case 'master_card':
      return SvgAssets.mastercard;
    case 'unionpay':
    case 'union_pay':
      return SvgAssets.unionPay;
    default:
      return null;
  }
}
