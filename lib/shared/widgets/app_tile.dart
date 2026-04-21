import 'package:flutter/material.dart';

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
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: scheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: scheme.onSurface),
            )
          : null,
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w700,
          color: scheme.onSurface,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 12),
            )
          : null,
      trailing:
          trailing ??
          Icon(
            Icons.chevron_right_rounded,
            color: scheme.onSurfaceVariant,
            size: 20,
          ),
      onTap: onTap,
    );
  }
}
