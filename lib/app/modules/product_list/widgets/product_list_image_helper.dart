import 'package:flutter/material.dart';

class ProductListImageHelper {
  static Widget buildNetworkImage({
    required String url,
    required double width,
    BorderRadius? borderRadius,
    BoxFit fit = BoxFit.cover,
  }) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: Image.network(
        url,
        width: width,
        fit: fit,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return skeletonBox(
            context: context,
            width: width,
            borderRadius: borderRadius,
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return skeletonBox(
            context: context,
            width: width,
            borderRadius: borderRadius,
            child: Icon(
              Icons.broken_image,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          );
        },
      ),
    );
  }

  static Widget skeletonBox({
    required BuildContext context,
    required double width,
    BorderRadius? borderRadius,
    Widget? child,
  }) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: borderRadius ?? BorderRadius.zero,
      ),
      child: child == null ? null : Center(child: child),
    );
  }
}
