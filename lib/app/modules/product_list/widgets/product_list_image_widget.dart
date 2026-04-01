import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/product_list/widgets/product_list_skeleton_box_widget.dart';

class ProductListImageWidget extends StatelessWidget {
  const ProductListImageWidget({
    required this.url,
    required this.width,
    this.borderRadius,
    this.fit = BoxFit.cover,
    super.key,
  });

  final String url;
  final double width;
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
        width: width,
        fit: fit,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return ProductListSkeletonBoxWidget(
            width: width,
            borderRadius: radius,
            color: scheme.surfaceContainerHighest,
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return ProductListSkeletonBoxWidget(
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
