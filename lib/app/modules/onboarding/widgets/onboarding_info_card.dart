import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingInfoCard extends StatelessWidget {
  const OnboardingInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: 98,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          SizedBox(
            height: 48,
            width: 48,
            child: CircleAvatar(
              backgroundColor: isDark
                  ? scheme.primaryContainer
                  : const Color(0xFFC4EEB5),
              child: Icon(
                Icons.eco,
                size: 18,
                color: isDark ? scheme.onPrimaryContainer : scheme.primary,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ethically_sourced'.tr,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: scheme.onSurface,
                ),
              ),
              Text(
                'carbon_neutral_delivery'.tr,
                style: TextStyle(
                  color: scheme.onSurfaceVariant,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
