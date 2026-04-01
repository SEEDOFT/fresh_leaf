import 'package:flutter/material.dart';
import 'package:fresh_leaf/core/theme/app_colors.dart';
import 'package:get/get.dart';

class HomeAIBannerWidget extends StatelessWidget {
  const HomeAIBannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bannerColor = isDark
        ? scheme.primaryContainer
        : AppColors.primaryGreen;
    final bannerTextColor = isDark ? scheme.onPrimaryContainer : Colors.white;
    final bannerSubTextColor = isDark
        ? scheme.onPrimaryContainer.withValues(alpha: 0.82)
        : Colors.white70;
    final iconBoxColor = isDark
        ? scheme.secondaryContainer
        : AppColors.accentLime;
    final iconColor = isDark
        ? scheme.onSecondaryContainer
        : AppColors.primaryGreen;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: bannerColor,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: iconBoxColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.auto_awesome,
                color: iconColor,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ai_smart_suggestions'.tr,
                    style: TextStyle(
                      color: bannerTextColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'ai_smart_suggestions_subtitle'.tr,
                    style: TextStyle(color: bannerSubTextColor, fontSize: 12),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: bannerTextColor),
          ],
        ),
      ),
    );
  }
}
