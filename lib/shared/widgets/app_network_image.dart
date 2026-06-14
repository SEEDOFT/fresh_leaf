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
      // Remove leading slash if present to avoid double slashes
      final cleanPath = displayUrl.startsWith('/')
          ? displayUrl.substring(1)
          : displayUrl;

      // If it doesn't look like it's in public/images or public/assets, assume it's in storage
      if (!cleanPath.startsWith('images/') &&
          !cleanPath.startsWith('assets/')) {
        displayUrl = '${AppConfig.baseAssetUrl}/storage/$cleanPath';
      } else {
        displayUrl = '${AppConfig.baseAssetUrl}/$cleanPath';
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
