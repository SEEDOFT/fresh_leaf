import 'package:flutter/material.dart';
import 'package:fresh_leaf/shared/helpers/responsive_helper.dart';
import 'package:get/get.dart';

class WishlistEmptyStateWidget extends StatelessWidget {
  const WishlistEmptyStateWidget({required this.scheme, super.key});

  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border_rounded,
            size: 64.scaled,
            color: scheme.onSurfaceVariant.withValues(alpha: 0.3),
          ),
          SizedBox(height: 16.scaled),
          Text(
            'wishlist_empty_title'.tr,
            style: TextStyle(
              fontSize: 18.scaled,
              fontWeight: FontWeight.bold,
              color: scheme.onSurface,
            ),
          ),
          SizedBox(height: 8.scaled),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 48.scaled),
            child: Text(
              'wishlist_empty_subtitle'.tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.scaled,
                color: scheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
