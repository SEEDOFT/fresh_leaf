import 'package:flutter/material.dart';

class HomeNetworkImageWidget extends StatelessWidget {
  const HomeNetworkImageWidget({
    super.key,
    required this.url,
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

    return ClipRRect(
      borderRadius: radius,
      child: Image.network(
        url,
        height: height,
        width: width,
        fit: fit,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return HomeImageSkeleton(
            height: height,
            width: width,
            borderRadius: radius,
          );
        },
        errorBuilder: (context, error, stackTrace) {
          final scheme = Theme.of(context).colorScheme;
          return HomeImageSkeleton(
            height: height,
            width: width,
            borderRadius: radius,
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

class HomeImageSkeleton extends StatelessWidget {
  const HomeImageSkeleton({
    super.key,
    this.height,
    this.width,
    this.borderRadius,
    this.child,
  });

  final double? height;
  final double? width;
  final BorderRadius? borderRadius;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: borderRadius ?? BorderRadius.zero,
      ),
      child: child == null ? null : Center(child: child),
    );
  }
}
