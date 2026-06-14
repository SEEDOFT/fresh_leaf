import 'package:flutter/material.dart';
import 'package:fresh_leaf/shared/helpers/responsive_helper.dart';

class AppAvatar extends StatelessWidget {
  const AppAvatar({
    this.imageUrl,
    this.name,
    this.fallbackIcon,
    this.radius = 24,
    this.backgroundColor,
    this.foregroundColor,
    this.borderWidth,
    this.borderColor,
    this.imageProvider,
    super.key,
  });

  final String? imageUrl;
  final ImageProvider? imageProvider;
  final String? name;
  final IconData? fallbackIcon;
  final double radius;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? borderWidth;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final effectiveRadius = radius.scaled;

    Widget content;
    final hasImage = imageUrl != null && imageUrl!.isNotEmpty;

    if (imageProvider != null) {
      content = CircleAvatar(
        radius: effectiveRadius,
        backgroundColor: backgroundColor ?? scheme.surfaceContainerHighest,
        backgroundImage: imageProvider,
      );
    } else if (hasImage) {
      content = CircleAvatar(
        radius: effectiveRadius,
        backgroundColor: backgroundColor ?? scheme.surfaceContainerHighest,
        backgroundImage: NetworkImage(imageUrl!),
      );
    } else if (name != null && name!.trim().isNotEmpty) {
      content = CircleAvatar(
        radius: effectiveRadius,
        backgroundColor: backgroundColor ?? scheme.primaryContainer,
        child: Text(
          _getInitials(name!),
          style: TextStyle(
            fontSize: effectiveRadius * 0.7,
            color: foregroundColor ?? scheme.onPrimaryContainer,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    } else {
      content = CircleAvatar(
        radius: effectiveRadius,
        backgroundColor: backgroundColor ?? scheme.primaryContainer,
        child: Icon(
          fallbackIcon ?? Icons.person_outline_rounded,
          size: effectiveRadius * 1.1,
          color: foregroundColor ?? scheme.onPrimaryContainer,
        ),
      );
    }

    if (borderWidth != null && borderWidth! > 0) {
      return Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: borderColor ?? scheme.outline,
            width: borderWidth!.scaled,
          ),
        ),
        child: content,
      );
    }

    return content;
  }

  String _getInitials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return '';
    if (parts.length == 1) {
      return parts[0]
          .substring(0, parts[0].length > 1 ? 1 : parts[0].length)
          .toUpperCase();
    }
    return (parts[0][0] + parts[parts.length - 1][0]).toUpperCase();
  }
}
