import 'package:flutter/material.dart';
import 'package:fresh_leaf/shared/helpers/responsive_helper.dart';
import 'package:fresh_leaf/shared/widgets/app_badge.dart';

class HomeFarmerCardWidget extends StatelessWidget {
  const HomeFarmerCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.scaled),
      child: Container(
        padding: EdgeInsets.all(24.scaled),
        decoration: BoxDecoration(
          color: scheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(32.scaled),
        ),
        child: Column(
          children: [
            CircleAvatar(
              radius: 40.scaled,
              backgroundImage: const NetworkImage(
                'https://images.unsplash.com/photo-1506976785307-8732e854ad03?q=80&w=600',
              ),
            ),
            SizedBox(height: 16.scaled),
            Text(
              'FEATURED FARMER',
              style: TextStyle(
                fontSize: 10.scaled,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
                color: scheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 4.scaled),
            Text(
              "Meet Miller's Organic",
              style: TextStyle(
                fontSize: 20.scaled,
                fontWeight: FontWeight.w900,
                color: scheme.onSurface,
              ),
            ),
            SizedBox(height: 12.scaled),
            Text(
              'Supplying our community with pesticide-free heirloom '
              'produce since 1994. Every bunch of kale helps support'
              ' local biodiversity.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.scaled,
                color: scheme.onSurfaceVariant,
                height: 1.5,
              ),
            ),
            SizedBox(height: 20.scaled),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppBadge(
                  label: 'Carbon Neutral',
                  icon: Icons.check_circle,
                  backgroundColor: scheme.surface,
                  foregroundColor: scheme.onSurface,
                  borderRadius: 20.scaled,
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.scaled,
                    vertical: 8.scaled,
                  ),
                ),
                SizedBox(width: 8.scaled),
                AppBadge(
                  label: '12 Miles Away',
                  icon: Icons.local_shipping,
                  backgroundColor: scheme.surface,
                  foregroundColor: scheme.onSurface,
                  borderRadius: 20.scaled,
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.scaled,
                    vertical: 8.scaled,
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
