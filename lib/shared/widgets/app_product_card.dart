import 'package:flutter/material.dart';
import 'package:fresh_leaf/shared/helpers/helper.dart';
import 'package:fresh_leaf/shared/helpers/responsive_helper.dart';
import 'package:fresh_leaf/shared/widgets/app_network_image.dart';
import 'package:fresh_leaf/shared/widgets/rating_stars_widget.dart';

enum AppProductCardLayout { grid, list }

class AppProductCard extends StatelessWidget {
  const AppProductCard({
    required this.title,
    required this.imageUrl,
    required this.price,
    this.originalPrice,
    this.priceKhr,
    this.currencySymbol,
    this.subtitle,
    this.averageRating,
    this.ratingsCount,
    this.badge,
    this.onTap,
    this.onActionTap,
    this.layout = AppProductCardLayout.grid,
    this.actionIcon = Icons.add,
    this.actionLabel,
    this.isFavorite = false,
    this.onFavoriteTap,
    super.key,
  });

  final String title;
  final String imageUrl;
  final double price;
  final double? originalPrice;
  final double? priceKhr;
  final String? currencySymbol;
  final String? subtitle;
  final double? averageRating;
  final int? ratingsCount;
  final String? badge;
  final VoidCallback? onTap;
  final VoidCallback? onActionTap;
  final AppProductCardLayout layout;
  final IconData actionIcon;
  final String? actionLabel;
  final bool isFavorite;
  final VoidCallback? onFavoriteTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    if (layout == AppProductCardLayout.list) {
      return _buildListLayout(scheme);
    }
    return _buildGridLayout(context: context, scheme: scheme);
  }

  Widget _buildGridLayout({
    required BuildContext context,
    required ColorScheme scheme,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: scheme.surface,
          borderRadius: BorderRadius.circular(20.scaled),
          boxShadow: [
            BoxShadow(
              color: scheme.shadow.withValues(alpha: 0.12),
              blurRadius: 10.scaled,
              offset: Offset(0, 5.scaled),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  AppNetworkImage(
                    url: imageUrl,
                    width: MediaQuery.of(context).size.width,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20.scaled),
                    ),
                  ),
                  if (badge != null)
                    Positioned(
                      top: 12.scaled,
                      left: 12.scaled,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.scaled,
                          vertical: 4.scaled,
                        ),
                        decoration: BoxDecoration(
                          color: scheme.secondaryContainer,
                          borderRadius: BorderRadius.circular(8.scaled),
                        ),
                        child: Text(
                          badge!,
                          style: TextStyle(
                            fontSize: 9.scaled,
                            fontWeight: FontWeight.bold,
                            color: scheme.onSecondaryContainer,
                          ),
                        ),
                      ),
                    ),
                  Positioned(
                    top: 8.scaled,
                    right: 8.scaled,
                    child: GestureDetector(
                      onTap: onFavoriteTap,
                      child: Container(
                        padding: EdgeInsets.all(6.scaled),
                        decoration: BoxDecoration(
                          color: scheme.surface.withValues(alpha: 0.8),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isFavorite
                              ? Icons.favorite_rounded
                              : Icons.favorite_outline_rounded,
                          size: 18.scaled,
                          color: isFavorite ? scheme.error : scheme.onSurface,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.all(12.scaled),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 15.scaled,
                        fontWeight: FontWeight.bold,
                        color: scheme.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (subtitle != null) ...[
                      SizedBox(height: 2.scaled),
                      Text(
                        subtitle!,
                        style: TextStyle(
                          fontSize: 12.scaled,
                          color: scheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    if (averageRating != null && averageRating! > 0) ...[
                      SizedBox(height: 4.scaled),
                      RatingStarsWidget(
                        rating: averageRating!,
                        size: 12,
                        count: ratingsCount,
                      ),
                    ],
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (originalPrice != null &&
                                  originalPrice! > price)
                                Text(
                                  '${currencySymbol ?? r'$'}'
                                  '${formatPrice(originalPrice!)}',
                                  style: TextStyle(
                                    fontSize: 11.scaled,
                                    decoration: TextDecoration.lineThrough,
                                    color: scheme.onSurfaceVariant.withValues(
                                      alpha: 0.6,
                                    ),
                                  ),
                                  maxLines: 1,
                                ),
                              Text(
                                '${currencySymbol ?? r'$'}'
                                '${formatPrice(price)}',
                                style: TextStyle(
                                  fontSize: 16.scaled,
                                  fontWeight: FontWeight.bold,
                                  color: scheme.primary,
                                ),
                                maxLines: 1,
                              ),
                              if (priceKhr != null)
                                Text(
                                  '${formatPriceNoDecimals(priceKhr!)} ៛',
                                  style: TextStyle(
                                    fontSize: 11.scaled,
                                    fontWeight: FontWeight.w600,
                                    color: scheme.onSurfaceVariant,
                                  ),
                                  maxLines: 1,
                                ),
                            ],
                          ),
                        ),
                        if (onActionTap != null)
                          _CircleActionButton(
                            icon: actionIcon,
                            onTap: onActionTap!,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListLayout(ColorScheme scheme) {
    return Material(
      color: scheme.surface,
      borderRadius: BorderRadius.circular(18.scaled),
      child: InkWell(
        borderRadius: BorderRadius.circular(18.scaled),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(12.scaled),
          child: Row(
            children: [
              AppNetworkImage(
                url: imageUrl,
                width: 72.scaled,
                height: 72.scaled,
                borderRadius: BorderRadius.circular(14.scaled),
              ),
              SizedBox(width: 12.scaled),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: scheme.onSurface,
                      ),
                    ),
                    if (subtitle != null) ...[
                      SizedBox(height: 4.scaled),
                      Text(
                        subtitle!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: scheme.onSurfaceVariant,
                          fontSize: 12.scaled,
                        ),
                      ),
                    ],
                    if (averageRating != null && averageRating! > 0) ...[
                      SizedBox(height: 4.scaled),
                      RatingStarsWidget(
                        rating: averageRating!,
                        size: 12,
                        count: ratingsCount,
                      ),
                    ],
                    SizedBox(height: 8.scaled),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              '${currencySymbol ?? r'$'}${formatPrice(price)}',
                              style: TextStyle(
                                color: scheme.primary,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            if (originalPrice != null &&
                                originalPrice! > price) ...[
                              SizedBox(width: 8.scaled),
                              Text(
                                '${currencySymbol ?? r'$'}'
                                '${formatPrice(originalPrice!)}',
                                style: TextStyle(
                                  fontSize: 11.scaled,
                                  decoration: TextDecoration.lineThrough,
                                  color: scheme.onSurfaceVariant.withValues(
                                    alpha: 0.6,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        if (priceKhr != null)
                          Text(
                            '${formatPriceNoDecimals(priceKhr!)} ៛',
                            style: TextStyle(
                              fontSize: 11.scaled,
                              fontWeight: FontWeight.w600,
                              color: scheme.onSurfaceVariant,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              if (onActionTap != null)
                _CircleActionButton(
                  icon: actionIcon,
                  onTap: onActionTap!,
                )
              else
                Icon(
                  Icons.chevron_right_rounded,
                  color: scheme.onSurfaceVariant,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CircleActionButton extends StatelessWidget {
  const _CircleActionButton({
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8.scaled),
        decoration: BoxDecoration(
          color: scheme.primaryContainer.withValues(alpha: 0.5),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 18.scaled,
          color: scheme.primary,
        ),
      ),
    );
  }
}
