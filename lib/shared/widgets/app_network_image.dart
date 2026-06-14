import 'package:flutter/material.dart';
import 'package:fresh_leaf/core/config/app_config.dart';

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

    if (url.isEmpty) {
      return _ImageSkeleton(
        height: height,
        width: width,
        borderRadius: radius,
        color: scheme.surfaceContainerHighest,
      );
    }

    var displayUrl = url;
    if (!displayUrl.startsWith('http') && !displayUrl.startsWith('data:')) {
      if (displayUrl.startsWith('/')) {
        displayUrl = '${AppConfig.apiUrl}$displayUrl';
      } else {
        displayUrl = '${AppConfig.apiUrl}/storage/$displayUrl';
      }
    }

    return ClipRRect(
      borderRadius: radius,
      child: Image.network(
        displayUrl,
        key: ValueKey(displayUrl),
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
  });

  final double? height;
  final double? width;
  final BorderRadius? borderRadius;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: color,
        borderRadius: borderRadius ?? BorderRadius.zero,
      ),
    );
  }
}
