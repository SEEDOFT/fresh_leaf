import 'package:flutter/material.dart';
import 'package:fresh_leaf/core/theme/app_colors.dart';
import 'package:fresh_leaf/shared/helpers/responsive_helper.dart';
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
      padding: EdgeInsets.symmetric(horizontal: 24.scaled),
      child: SizedBox(
        height: 240.scaled,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24.scaled),
          child: Stack(
            children: [
              AppNetworkImage(
                url:
                    'https://images.unsplash.com/photo-1595841696677-6489ff3f8cd1?q=80&w=1000',
                height: 240.scaled,
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
                padding: EdgeInsets.all(16.scaled),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.scaled,
                        vertical: 4.scaled,
                      ),
                      decoration: BoxDecoration(
                        color: tagBackground,
                        borderRadius: BorderRadius.circular(12.scaled),
                      ),
                      child: Text(
                        'limited_edition'.tr,
                        style: TextStyle(
                          fontSize: 10.scaled,
                          fontWeight: FontWeight.bold,
                          color: tagForeground,
                        ),
                      ),
                    ),
                    SizedBox(height: 12.scaled),
                    Text(
                      'seasonal_organic_harvest'.tr,
                      style: TextStyle(
                        fontSize: 32.scaled,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        height: 1.1,
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.scaled,
                            vertical: 10.scaled,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(20.scaled),
                          ),
                          child: Row(
                            children: [
                              Text(
                                'explore_selection'.tr,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13.scaled,
                                ),
                              ),
                              SizedBox(width: 8.scaled),
                              Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                                size: 16.scaled,
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
