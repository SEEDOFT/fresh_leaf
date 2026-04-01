import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WishlistEmptyWidget extends StatelessWidget {
  const WishlistEmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width - 56,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: scheme.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: scheme.outline),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.favorite_border,
              color: scheme.onSurfaceVariant,
              size: 36,
            ),
            const SizedBox(height: 12),
            Text(
              'wishlist_empty_title'.tr,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: scheme.onSurface,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'wishlist_empty_subtitle'.tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: scheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
