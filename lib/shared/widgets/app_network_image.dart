import 'package:flutter/material.dart';

class AppNetworkImage extends StatelessWidget {
  const AppNetworkImage({
    required this.url,
    super.key,
    this.height,
    this.width,
    this.borderRadius,
    this.fit = BoxFit.cover,
  });

  final String url;
  final double? height;
  final double? width;
  final BorderRadius? borderRadius;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? BorderRadius.zero;
    final scheme = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: radius,
      child: Image.network(
        url,
        height: height,
        width: width,
        fit: fit,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return _ImageSkeleton(
            height: height,
            width: width,
            borderRadius: radius,
            color: scheme.surfaceContainerHighest,
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return _ImageSkeleton(
            height: height,
            width: width,
            borderRadius: radius,
            color: scheme.surfaceContainerHighest,
            child: Icon(
              Icons.broken_image,
              color: scheme.onSurfaceVariant,
            ),
          );
        },
      ),
    );
  }
}

class _ImageSkeleton extends StatelessWidget {
  const _ImageSkeleton({
    this.height,
    this.width,
    this.borderRadius,
    this.color,
    this.child,
  });

  final double? height;
  final double? width;
  final BorderRadius? borderRadius;
  final Color? color;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: color,
        borderRadius: borderRadius ?? BorderRadius.zero,
      ),
      child: child != null ? Center(child: child) : null,
    );
  }
}
