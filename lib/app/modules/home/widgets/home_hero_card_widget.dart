import 'package:flutter/material.dart';
import 'package:fresh_leaf/core/constants/app_sizes.dart';
import 'package:fresh_leaf/core/theme/app_colors.dart';
import 'package:fresh_leaf/shared/widgets/app_network_image.dart';
import 'package:get/get.dart';

class HomeHeroCardWidget extends StatelessWidget {
  const HomeHeroCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tagBackground = isDark
        ? scheme.secondaryContainer
        : AppColors.accentLime;
    final tagForeground = isDark ? scheme.onSecondaryContainer : Colors.black;
    final heroOverlayStart = isDark
        ? Colors.black.withValues(alpha: 0.32)
        : Colors.black12;
    final heroOverlayEnd = isDark
        ? scheme.surface.withValues(alpha: 0.88)
        : AppColors.primaryGreen.withValues(alpha: 0.9);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSizes.s24),
      child: SizedBox(
        height: AppSizes.s240,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppSizes.s24),
          child: Stack(
            children: [
              AppNetworkImage(
                url:
                    'https://images.unsplash.com/photo-1595841696677-6489ff3f8cd1?q=80&w=1000',
                height: AppSizes.s240,
                width: media.size.width,
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      heroOverlayStart,
                      heroOverlayEnd,
                    ],
                  ),
                ),
                padding: EdgeInsets.all(AppSizes.s16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSizes.s10,
                        vertical: AppSizes.s4,
                      ),
                      decoration: BoxDecoration(
                        color: tagBackground,
                        borderRadius: BorderRadius.circular(AppSizes.s12),
                      ),
                      child: Text(
                        'limited_edition'.tr,
                        style: TextStyle(
                          fontSize: AppSizes.s10,
                          fontWeight: FontWeight.bold,
                          color: tagForeground,
                        ),
                      ),
                    ),
                    SizedBox(height: AppSizes.s12),
                    Text(
                      'seasonal_organic_harvest'.tr,
                      style: TextStyle(
                        fontSize: AppSizes.s32,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        height: 1.1,
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSizes.s16,
                            vertical: AppSizes.s10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(AppSizes.s20),
                          ),
                          child: Row(
                            children: [
                              Text(
                                'explore_selection'.tr,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: AppSizes.s13,
                                ),
                              ),
                              SizedBox(width: AppSizes.s8),
                              Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                                size: AppSizes.s16,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
