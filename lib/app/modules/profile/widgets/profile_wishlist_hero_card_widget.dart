import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WishlistHeroCard extends StatelessWidget {
  const WishlistHeroCard({super.key, required this.itemCount});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? scheme.onPrimaryContainer : Colors.white;
    final subtitleColor = isDark
        ? scheme.onPrimaryContainer.withValues(alpha: 0.78)
        : const Color(0xFFD9E6D3);
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: isDark
              ? <Color>[
                  scheme.primaryContainer,
                  scheme.surfaceContainerHighest,
                ]
              : const <Color>[
                  Color(0xFF2E5321),
                  Color(0xFF1E3616),
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'my_wishlist'.tr,
            style: TextStyle(
              color: textColor,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            (itemCount == 1
                    ? 'wishlist_saved_one'
                    : 'wishlist_saved_other')
                .trParams({'count': '$itemCount'}),
            style: TextStyle(
              color: subtitleColor,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
