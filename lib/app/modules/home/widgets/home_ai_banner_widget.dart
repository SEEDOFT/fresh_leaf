import 'package:flutter/material.dart';
import 'package:fresh_leaf/core/theme/app_colors.dart';
import 'package:fresh_leaf/shared/helpers/responsive_helper.dart';
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
      padding: EdgeInsets.symmetric(horizontal: 24.scaled),
      child: Container(
        padding: EdgeInsets.all(20.scaled),
        decoration: BoxDecoration(
          color: bannerColor,
          borderRadius: BorderRadius.circular(24.scaled),
        ),
        child: Row(
          children: [
            AppBadge(
              label: '',
              icon: Icons.auto_awesome,
              backgroundColor: iconBoxColor,
              foregroundColor: iconColor,
              borderRadius: 16.scaled,
              padding: EdgeInsets.all(12.scaled),
              fontSize: 0,
            ),
            SizedBox(width: 16.scaled),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ai_smart_suggestions'.tr,
                    style: TextStyle(
                      color: bannerTextColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.scaled,
                      height: 1.2,
                    ),
                  ),
                  SizedBox(height: 4.scaled),
                  Text(
                    'ai_smart_suggestions_subtitle'.tr,
                    style: TextStyle(
                      color: bannerSubTextColor,
                      fontSize: 12.scaled,
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
