import 'package:flutter/material.dart';
import 'package:fresh_leaf/shared/widgets/app_badge.dart';

class HomeFarmerCardWidget extends StatelessWidget {
  const HomeFarmerCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: scheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(32),
        ),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(
                'https://images.unsplash.com/photo-1506976785307-8732e854ad03?q=80&w=600',
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'FEATURED FARMER',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
                color: scheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Meet Miller's Organic",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: scheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Supplying our community with pesticide-free heirloom '
              'produce since 1994. Every bunch of kale helps support'
              ' local biodiversity.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: scheme.onSurfaceVariant,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppBadge(
                  label: 'Carbon Neutral',
                  icon: Icons.check_circle,
                  backgroundColor: scheme.surface,
                  foregroundColor: scheme.onSurface,
                  borderRadius: 20,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
                const SizedBox(width: 8),
                AppBadge(
                  label: '12 Miles Away',
                  icon: Icons.local_shipping,
                  backgroundColor: scheme.surface,
                  foregroundColor: scheme.onSurface,
                  borderRadius: 20,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
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
