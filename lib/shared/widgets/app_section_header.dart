import 'package:flutter/material.dart';

enum AppSectionHeaderStyle {
  large,
  medium,
  small,
  divider,
}

class AppSectionHeader extends StatelessWidget {
  const AppSectionHeader({
    required this.title,
    this.subtitle,
    this.style = AppSectionHeaderStyle.large,
    this.trailing,
    this.horizontalPadding = 24,
    super.key,
  });

  final String title;
  final String? subtitle;
  final AppSectionHeaderStyle style;
  final Widget? trailing;
  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    if (style == AppSectionHeaderStyle.divider) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: Row(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: scheme.onSurface,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Divider(
                thickness: 1,
                color: scheme.outline.withValues(alpha: 0.35),
              ),
            ),
          ],
        ),
      );
    }

    final double titleSize;
    final double subtitleSize;
    final FontWeight titleWeight;

    switch (style) {
      case AppSectionHeaderStyle.large:
        titleSize = 22;
        subtitleSize = 14;
        titleWeight = FontWeight.bold;
      case AppSectionHeaderStyle.medium:
        titleSize = 20;
        subtitleSize = 13;
        titleWeight = FontWeight.bold;
      case AppSectionHeaderStyle.small:
        titleSize = 14;
        subtitleSize = 12;
        titleWeight = FontWeight.w700;
      case AppSectionHeaderStyle.divider:
        // Handled above
        titleSize = 16;
        subtitleSize = 12;
        titleWeight = FontWeight.w800;
    }

    final rowChildren = <Widget>[
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: titleSize,
                fontWeight: titleWeight,
                color: scheme.onSurface,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 4),
              Text(
                subtitle!,
                style: TextStyle(
                  fontSize: subtitleSize,
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
      ),
    ];

    if (trailing != null) {
      rowChildren.add(trailing!);
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: rowChildren,
      ),
    );
  }
}
