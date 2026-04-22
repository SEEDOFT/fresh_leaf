import 'package:flutter/material.dart';
import 'package:fresh_leaf/shared/helpers/responsive_helper.dart';

class AppTile extends StatelessWidget {
  const AppTile({
    required this.title,
    this.subtitle,
    this.icon,
    this.trailing,
    this.onTap,
    this.contentPadding = EdgeInsets.zero,
    super.key,
  });

  final String title;
  final String? subtitle;
  final IconData? icon;
  final Widget? trailing;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry contentPadding;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return ListTile(
      contentPadding: contentPadding,
      leading: icon != null
          ? Container(
              padding: EdgeInsets.all(10.scaled),
              decoration: BoxDecoration(
                color: scheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(14.scaled),
              ),
              child: Icon(
                icon,
                color: scheme.onSurface,
                size: 20.scaled,
              ),
            )
          : null,
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w700,
          color: scheme.onSurface,
          fontSize: 14.scaled,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: TextStyle(
                color: scheme.onSurfaceVariant,
                fontSize: 12.scaled,
              ),
            )
          : null,
      trailing:
          trailing ??
          Icon(
            Icons.chevron_right_rounded,
            color: scheme.onSurfaceVariant,
            size: 20.scaled,
          ),
      onTap: onTap,
    );
  }
}
