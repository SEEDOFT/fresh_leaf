import 'package:flutter/material.dart';
import 'package:fresh_leaf/core/theme/app_colors.dart';
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
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              height: 280,
              decoration: BoxDecoration(
                color: scheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Stack(
                children: [
                  AppNetworkImage(
                    url:
                        'https://images.unsplash.com/photo-1506976785307-8732e854ad03?q=80&w=600',
                    height: 280,
                    width: media.size.width,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
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
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'pasture_raised_eggs'.tr,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              'dozen_large'.tr,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.85),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        AppBadge(
                          label: 'reorder'.tr,
                          backgroundColor: chipBackground,
                          foregroundColor: chipPrimaryText,
                          borderRadius: 20,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          fontSize: 12,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: cardPeach,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'whole_milk'.tr,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: cardText,
                        ),
                      ),
                      Text(
                        'glass_bottle_1l'.tr,
                        style: TextStyle(
                          fontSize: 12,
                          color: cardSubText,
                        ),
                      ),
                      const SizedBox(height: 24),
                      AppBadge(
                        label: 'add_price'.trParams({'price': r'$4.20'}),
                        backgroundColor: ctaDark,
                        foregroundColor: ctaDarkText,
                        borderRadius: 16,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        fontSize: 12,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: cardLime,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'sourdough_loaf'.tr,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: cardText,
                        ),
                      ),
                      Text(
                        'artisan_baked'.tr,
                        style: TextStyle(
                          fontSize: 12,
                          color: cardSubText,
                        ),
                      ),
                      const SizedBox(height: 24),
                      AppBadge(
                        label: 'add_price'.trParams({'price': r'$7.50'}),
                        backgroundColor: ctaDark,
                        foregroundColor: ctaDarkText,
                        borderRadius: 16,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        fontSize: 12,
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
