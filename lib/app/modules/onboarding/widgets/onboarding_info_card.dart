import 'package:flutter/material.dart';
import 'package:fresh_leaf/shared/helpers/responsive_helper.dart';
import 'package:get/get.dart';

class OnboardingInfoCard extends StatelessWidget {
  const OnboardingInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: 98.scaled,
      padding: EdgeInsets.all(16.scaled),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          SizedBox(
            height: 48.scaled,
            width: 48.scaled,
            child: CircleAvatar(
              backgroundColor: isDark
                  ? scheme.primaryContainer
                  : const Color(0xFFC4EEB5),
              child: Icon(
                Icons.eco,
                size: 18.scaled,
                color: isDark ? scheme.onPrimaryContainer : scheme.primary,
              ),
            ),
          ),
          SizedBox(width: 16.scaled),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ethically_sourced'.tr,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.scaled,
                  color: scheme.onSurface,
                ),
              ),
              Text(
                'carbon_neutral_delivery'.tr,
                style: TextStyle(
                  color: scheme.onSurfaceVariant,
                  fontSize: 13.scaled,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
