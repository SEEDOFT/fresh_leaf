import 'package:flutter/material.dart';
import 'package:fresh_leaf/core/theme/app_colors.dart';
import 'package:fresh_leaf/shared/helpers/responsive_helper.dart';
import 'package:fresh_leaf/shared/widgets/app_badge.dart';
import 'package:fresh_leaf/shared/widgets/app_network_image.dart';
import 'package:get/get.dart';

class HomeStaplesGridWidget extends StatelessWidget {
  const HomeStaplesGridWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final overlayTop = Colors.black.withValues(alpha: isDark ? 0.52 : 0.36);
    final overlayBottom = Colors.black.withValues(alpha: isDark ? 0.52 : 0.36);
    final chipBackground = isDark
        ? scheme.surfaceContainerHighest.withValues(alpha: 0.82)
        : Colors.white;
    final chipPrimaryText = isDark ? scheme.onSurface : Colors.black;
    final cardPeach = isDark
        ? scheme.secondaryContainer.withValues(alpha: 0.75)
        : AppColors.accentPeach;
    final cardLime = isDark
        ? scheme.primaryContainer.withValues(alpha: 0.65)
        : AppColors.accentLime;
    final ctaDark = isDark ? scheme.surface : Colors.black;
    final ctaDarkText = isDark ? scheme.onSurface : Colors.white;
    final cardText = isDark ? scheme.onSurface : Colors.black;
    final cardSubText = isDark ? scheme.onSurfaceVariant : Colors.black;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.scaled),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              height: 280.scaled,
              decoration: BoxDecoration(
                color: scheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(24.scaled),
              ),
              child: Stack(
                children: [
                  AppNetworkImage(
                    url:
                        'https://images.unsplash.com/photo-1506976785307-8732e854ad03?q=80&w=600',
                    height: 280.scaled,
                    width: media.size.width,
                    borderRadius: BorderRadius.circular(24.scaled),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24.scaled),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          overlayTop,
                          Colors.transparent,
                          overlayBottom,
                        ],
                      ),
                    ),
                    padding: EdgeInsets.all(16.scaled),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'pasture_raised_eggs'.tr,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16.scaled,
                              ),
                            ),
                            Text(
                              'dozen_large'.tr,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.85),
                                fontSize: 12.scaled,
                              ),
                            ),
                          ],
                        ),
                        AppBadge(
                          label: 'reorder'.tr,
                          backgroundColor: chipBackground,
                          foregroundColor: chipPrimaryText,
                          borderRadius: 20.scaled,
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.scaled,
                            vertical: 8.scaled,
                          ),
                          fontSize: 12.scaled,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 16.scaled),
          Expanded(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(16.scaled),
                  decoration: BoxDecoration(
                    color: cardPeach,
                    borderRadius: BorderRadius.circular(24.scaled),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'whole_milk'.tr,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.scaled,
                          color: cardText,
                        ),
                      ),
                      Text(
                        'glass_bottle_1l'.tr,
                        style: TextStyle(
                          fontSize: 12.scaled,
                          color: cardSubText,
                        ),
                      ),
                      SizedBox(height: 24.scaled),
                      AppBadge(
                        label: 'add_price'.trParams({'price': r'$4.20'}),
                        backgroundColor: ctaDark,
                        foregroundColor: ctaDarkText,
                        borderRadius: 16.scaled,
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.scaled,
                          vertical: 8.scaled,
                        ),
                        fontSize: 12.scaled,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.scaled),
                Container(
                  padding: EdgeInsets.all(16.scaled),
                  decoration: BoxDecoration(
                    color: cardLime,
                    borderRadius: BorderRadius.circular(24.scaled),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'sourdough_loaf'.tr,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.scaled,
                          color: cardText,
                        ),
                      ),
                      Text(
                        'artisan_baked'.tr,
                        style: TextStyle(
                          fontSize: 12.scaled,
                          color: cardSubText,
                        ),
                      ),
                      SizedBox(height: 24.scaled),
                      AppBadge(
                        label: 'add_price'.trParams({'price': r'$7.50'}),
                        backgroundColor: ctaDark,
                        foregroundColor: ctaDarkText,
                        borderRadius: 16.scaled,
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.scaled,
                          vertical: 8.scaled,
                        ),
                        fontSize: 12.scaled,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
