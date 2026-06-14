import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fresh_leaf/core/constants/app_sizes.dart';
import 'package:fresh_leaf/core/theme/app_colors.dart';
import 'package:fresh_leaf/shared/widgets/app_network_image.dart';
import 'package:get/get.dart';

class HomePromotionCarouselWidget extends StatefulWidget {
  const HomePromotionCarouselWidget({super.key});

  @override
  State<HomePromotionCarouselWidget> createState() =>
      _HomePromotionCarouselWidgetState();
}

class _HomePromotionCarouselWidgetState
    extends State<HomePromotionCarouselWidget> {
  final PageController _pageController = PageController();
  late final Timer _timer;
  int _activePage = 0;
  int _activeIndex = 0;

  static final List<_PromotionPoster> _posters = [
    const _PromotionPoster(
      badgeKey: 'promo_poster_badge_1',
      titleKey: 'promo_poster_title_1',
      subtitleKey: 'promo_poster_subtitle_1',
      imageUrl:
          'https://images.unsplash.com/photo-1542838132-92c53300491e?q=80&w=1000',
      accentColor: AppColors.accentLime,
    ),
    const _PromotionPoster(
      badgeKey: 'promo_poster_badge_2',
      titleKey: 'promo_poster_title_2',
      subtitleKey: 'promo_poster_subtitle_2',
      imageUrl:
          'https://images.unsplash.com/photo-1506368249639-73a05d6f6488?q=80&w=1000',
      accentColor: AppColors.accentPeach,
    ),
    const _PromotionPoster(
      badgeKey: 'promo_poster_badge_3',
      titleKey: 'promo_poster_title_3',
      subtitleKey: 'promo_poster_subtitle_3',
      imageUrl:
          'https://images.unsplash.com/photo-1488459716781-31db52582fe9?q=80&w=1000',
      accentColor: AppColors.warning,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!mounted || !_pageController.hasClients) {
        return;
      }

      final nextPage = _activePage + 1;
      unawaited(
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 450),
          curve: Curves.easeOutCubic,
        ),
      );
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSizes.s24),
      child: Column(
        children: [
          SizedBox(
            height: AppSizes.s200,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppSizes.s24),
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _activePage = index;
                    _activeIndex = index % _posters.length;
                  });
                },
                itemBuilder: (context, index) {
                  return _PromotionPosterCard(
                    poster: _posters[index % _posters.length],
                  );
                },
              ),
            ),
          ),
          SizedBox(height: AppSizes.s10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _posters.length,
              (index) => _PromotionIndicator(
                isActive: index == _activeIndex,
              ),
            ),
          ),
          SizedBox(height: AppSizes.s20),
          const _PromotionPerksSection(),
        ],
      ),
    );
  }
}

class _PromotionPosterCard extends StatelessWidget {
  const _PromotionPosterCard({required this.poster});

  final _PromotionPoster poster;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final foregroundColor = isDark ? scheme.onSurface : Colors.white;
    final mutedForegroundColor = foregroundColor.withValues(alpha: 0.82);

    return Stack(
      children: [
        AppNetworkImage(
          url: poster.imageUrl,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black.withValues(alpha: 0.76),
                Colors.black.withValues(alpha: 0.42),
                Colors.black.withValues(alpha: 0.08),
              ],
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(AppSizes.s18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSizes.s10,
                    vertical: AppSizes.s6,
                  ),
                  decoration: BoxDecoration(
                    color: poster.accentColor,
                    borderRadius: BorderRadius.circular(AppSizes.s20),
                  ),
                  child: Text(
                    poster.badgeKey.tr,
                    style: TextStyle(
                      color: AppColors.primaryDark,
                      fontSize: AppSizes.s10,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 230),
                      child: Text(
                        poster.titleKey.tr,
                        style: TextStyle(
                          color: foregroundColor,
                          fontSize: AppSizes.s24,
                          fontWeight: FontWeight.w900,
                          height: 1.05,
                        ),
                      ),
                    ),
                    SizedBox(height: AppSizes.s8),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 250),
                      child: Text(
                        poster.subtitleKey.tr,
                        style: TextStyle(
                          color: mutedForegroundColor,
                          fontSize: AppSizes.s13,
                          fontWeight: FontWeight.w600,
                          height: 1.25,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _PromotionIndicator extends StatelessWidget {
  const _PromotionIndicator({required this.isActive});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      margin: EdgeInsets.symmetric(horizontal: AppSizes.s4),
      width: isActive ? AppSizes.s20 : AppSizes.s8,
      height: AppSizes.s8,
      decoration: BoxDecoration(
        color: isActive ? scheme.primary : scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppSizes.s8),
      ),
    );
  }
}

class _PromotionPerksSection extends StatelessWidget {
  const _PromotionPerksSection();

  static const List<_PromotionPerk> _perks = [
    _PromotionPerk(
      icon: Icons.local_shipping_outlined,
      titleKey: 'promo_perk_delivery_title',
      subtitleKey: 'promo_perk_delivery_subtitle',
    ),
    _PromotionPerk(
      icon: Icons.verified_outlined,
      titleKey: 'promo_perk_verified_title',
      subtitleKey: 'promo_perk_verified_subtitle',
    ),
    _PromotionPerk(
      icon: Icons.eco_outlined,
      titleKey: 'promo_perk_fresh_title',
      subtitleKey: 'promo_perk_fresh_subtitle',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'promo_perks_title'.tr,
              style: TextStyle(
                color: scheme.onSurface,
                fontSize: AppSizes.s18,
                fontWeight: FontWeight.w900,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.stars_outlined,
              color: scheme.primary,
              size: AppSizes.s20,
            ),
          ],
        ),
        SizedBox(height: AppSizes.s12),
        Row(
          children: _perks
              .map(
                (perk) => Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: perk == _perks.last ? 0 : AppSizes.s8,
                    ),
                    child: _PromotionPerkCard(perk: perk),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _PromotionPerkCard extends StatelessWidget {
  const _PromotionPerkCard({required this.perk});

  final _PromotionPerk perk;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      constraints: BoxConstraints(minHeight: AppSizes.s110),
      padding: EdgeInsets.all(AppSizes.s12),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppSizes.s16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            perk.icon,
            color: scheme.primary,
            size: AppSizes.s22,
          ),
          SizedBox(height: AppSizes.s10),
          Text(
            perk.titleKey.tr,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: scheme.onSurface,
              fontSize: AppSizes.s12,
              fontWeight: FontWeight.w800,
              height: 1.15,
            ),
          ),
          SizedBox(height: AppSizes.s4),
          Text(
            perk.subtitleKey.tr,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: scheme.onSurfaceVariant,
              fontSize: AppSizes.s10,
              fontWeight: FontWeight.w600,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _PromotionPoster {
  const _PromotionPoster({
    required this.badgeKey,
    required this.titleKey,
    required this.subtitleKey,
    required this.imageUrl,
    required this.accentColor,
  });

  final String badgeKey;
  final String titleKey;
  final String subtitleKey;
  final String imageUrl;
  final Color accentColor;
}

class _PromotionPerk {
  const _PromotionPerk({
    required this.icon,
    required this.titleKey,
    required this.subtitleKey,
  });

  final IconData icon;
  final String titleKey;
  final String subtitleKey;
}
