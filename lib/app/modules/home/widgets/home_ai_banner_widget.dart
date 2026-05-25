import 'package:flutter/material.dart';
import 'package:fresh_leaf/core/constants/app_sizes.dart';
import 'package:fresh_leaf/core/theme/app_colors.dart';
import 'package:fresh_leaf/shared/widgets/app_badge.dart';
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
      padding: EdgeInsets.symmetric(horizontal: AppSizes.s24),
      child: Container(
        padding: EdgeInsets.all(AppSizes.s20),
        decoration: BoxDecoration(
          color: bannerColor,
          borderRadius: BorderRadius.circular(AppSizes.s24),
        ),
        child: Row(
          children: [
            AppBadge(
              label: '',
              icon: Icons.auto_awesome,
              backgroundColor: iconBoxColor,
              foregroundColor: iconColor,
              borderRadius: AppSizes.s16,
              padding: EdgeInsets.all(AppSizes.s12),
              fontSize: 0,
            ),
            SizedBox(width: AppSizes.s16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ai_smart_suggestions'.tr,
                    style: TextStyle(
                      color: bannerTextColor,
                      fontWeight: FontWeight.bold,
                      fontSize: AppSizes.s16,
                      height: 1.2,
                    ),
                  ),
                  SizedBox(height: AppSizes.s4),
                  Text(
                    'ai_smart_suggestions_subtitle'.tr,
                    style: TextStyle(
                      color: bannerSubTextColor,
                      fontSize: AppSizes.s12,
                    ),
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
