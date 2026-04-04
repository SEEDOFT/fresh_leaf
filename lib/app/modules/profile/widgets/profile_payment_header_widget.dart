import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/profile/widgets/profile_primary_action_button_widget.dart';
import 'package:get/get.dart';

class ProfilePaymentHeader extends StatelessWidget {
  const ProfilePaymentHeader({
    required this.onAddTap,
    required this.isLoading,
    super.key,
  });

  static const double _gap12 = 12;

  final VoidCallback onAddTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final media = MediaQuery.of(context);

    return Container(
      width: media.size.width,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.primaryContainer.withValues(alpha: 0.28),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: scheme.primary.withValues(alpha: 0.25),
        ),
        gradient: LinearGradient(
          colors: [
            scheme.primaryContainer.withValues(alpha: 0.55),
            scheme.surface,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: scheme.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              Icons.credit_card,
              color: scheme.primary,
            ),
          ),
          const SizedBox(width: _gap12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'your_payment_methods'.tr,
                  style: TextStyle(
                    color: scheme.onSurface,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: _gap12),
                Text(
                  'manage_cards_wallets_checkout'.tr,
                  style: TextStyle(
                    color: scheme.onSurfaceVariant,
                    fontSize: 13,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: _gap12),
                ProfilePrimaryActionButton(
                  label: 'add_payment_method'.tr,
                  icon: Icons.add,
                  onPressed: onAddTap,
                  isLoading: isLoading,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
