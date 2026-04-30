import 'package:flutter/material.dart';
import 'package:fresh_leaf/core/theme/app_colors.dart';
import 'package:fresh_leaf/shared/helpers/responsive_helper.dart';

class BackgroundHeroWidget extends StatelessWidget {
  const BackgroundHeroWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor = isDark ? Colors.white : AppColors.primaryDarkGreen;
    final subtitleColor = isDark
        ? Colors.white.withValues(alpha: 0.88)
        : AppColors.primaryDarkGreen.withValues(alpha: 0.85);

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
            return ColoredBox(
              color: scheme.surfaceContainerHighest,
              child: Center(
                child: Icon(
                  Icons.broken_image_rounded,
                  color: scheme.onSurfaceVariant,
                  size: 28.scaled,
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
              colors: isDark
                  ? <Color>[
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.2),
                      Colors.black.withValues(alpha: 0.6),
                    ]
                  : <Color>[
                      Colors.transparent,
                      AppColors.backgroundCream.withValues(alpha: 0.4),
                      AppColors.backgroundCream,
                    ],
              stops: const <double>[0, 0.6, 1],
            ),
          ),
        ),
        Positioned(
          bottom: 50.scaled,
          left: 24.scaled,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'FreshLeaf',
                style: TextStyle(
                  fontSize: 48.scaled,
                  fontWeight: FontWeight.w900,
                  color: titleColor,
                  letterSpacing: -1,
                  shadows: isDark
                      ? const <Shadow>[
                          Shadow(
                            color: Color(0x73000000),
                            offset: Offset(0, 1),
                            blurRadius: 6,
                          ),
                        ]
                      : null,
                ),
              ),
              Text(
                'THE DIGITAL LARDER',
                style: TextStyle(
                  fontSize: 14.scaled,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                  color: subtitleColor,
                  shadows: isDark
                      ? const <Shadow>[
                          Shadow(
                            color: Color(0x73000000),
                            offset: Offset(0, 1),
                            blurRadius: 5,
                          ),
                        ]
                      : null,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
