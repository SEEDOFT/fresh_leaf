import 'package:flutter/material.dart';
import 'package:fresh_leaf/core/theme/app_colors.dart';

class BackgroundHeroWidget extends StatelessWidget {
  const BackgroundHeroWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.network(
          'https://images.unsplash.com/photo-1597362925123-77861d3fbac7?q=80&w=1000',
          fit: BoxFit.cover,
          loadingBuilder: (context, child, progress) {
            if (progress == null) return child;
            return Container(color: scheme.surfaceContainerHighest);
          },
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: scheme.surfaceContainerHighest,
              child: Center(
                child: Icon(
                  Icons.broken_image_rounded,
                  color: scheme.onSurfaceVariant,
                  size: 28,
                ),
              ),
            );
          },
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                AppColors.backgroundCream.withValues(alpha: 0.4),
                AppColors.backgroundCream,
              ],
              stops: const [0.4, 0.75, 1.0],
            ),
          ),
        ),
        Positioned(
          bottom: 24,
          left: 24,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'FreshLeaf',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primaryDarkGreen,
                  letterSpacing: -1,
                ),
              ),
              Text(
                'THE DIGITAL LARDER',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                  color: AppColors.primaryDarkGreen.withValues(alpha: 0.85),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
