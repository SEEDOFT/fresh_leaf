import 'package:flutter/material.dart';
import 'package:fresh_leaf/core/constants/app_sizes.dart';
import 'package:fresh_leaf/shared/widgets/app_badge.dart';

class HomeFarmerCardWidget extends StatelessWidget {
  const HomeFarmerCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSizes.s24),
      child: Container(
        padding: EdgeInsets.all(AppSizes.s24),
        decoration: BoxDecoration(
          color: scheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppSizes.s32),
        ),
        child: Column(
          children: [
            CircleAvatar(
              radius: AppSizes.s40,
              backgroundImage: const NetworkImage(
                'https://images.unsplash.com/photo-1506976785307-8732e854ad03?q=80&w=600',
              ),
            ),
            SizedBox(height: AppSizes.s16),
            Text(
              'FEATURED FARMER',
              style: TextStyle(
                fontSize: AppSizes.s10,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
                color: scheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: AppSizes.s4),
            Text(
              "Meet Miller's Organic",
              style: TextStyle(
                fontSize: AppSizes.s20,
                fontWeight: FontWeight.w900,
                color: scheme.onSurface,
              ),
            ),
            SizedBox(height: AppSizes.s12),
            Text(
              'Supplying our community with pesticide-free heirloom '
              'produce since 1994. Every bunch of kale helps support'
              ' local biodiversity.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: AppSizes.s13,
                color: scheme.onSurfaceVariant,
                height: 1.5,
              ),
            ),
            SizedBox(height: AppSizes.s20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppBadge(
                  label: 'Carbon Neutral',
                  icon: Icons.check_circle,
                  backgroundColor: scheme.surface,
                  foregroundColor: scheme.onSurface,
                  borderRadius: AppSizes.s20,
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSizes.s12,
                    vertical: AppSizes.s8,
                  ),
                ),
                SizedBox(width: AppSizes.s8),
                AppBadge(
                  label: '12 Miles Away',
                  icon: Icons.local_shipping,
                  backgroundColor: scheme.surface,
                  foregroundColor: scheme.onSurface,
                  borderRadius: AppSizes.s20,
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSizes.s12,
                    vertical: AppSizes.s8,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
