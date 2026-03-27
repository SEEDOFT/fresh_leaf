import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/product_detail/models/product_info.dart';
import 'package:fresh_leaf/core/theme/app_colors.dart';

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
          return skeletonBox(width: width, borderRadius: borderRadius);
        },
        errorBuilder: (context, error, stackTrace) {
          return skeletonBox(
            width: width,
            borderRadius: borderRadius,
            child: const Icon(
              Icons.broken_image,
              color: AppColors.textLight,
            ),
          );
        },
      ),
    );
  }

  static Widget skeletonBox({
    required double width,
    BorderRadius? borderRadius,
    Widget? child,
  }) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: AppColors.cardLight,
        borderRadius: borderRadius ?? BorderRadius.zero,
      ),
      child: child == null ? null : Center(child: child),
    );
  }
}

// Product List Item Widget
class ProductListItemWidget extends StatelessWidget {
  final ProductInfo product;
  final VoidCallback onTap;

  const ProductListItemWidget({
    super.key,
    required this.product,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final textScale = MediaQuery.of(context).textScaler.scale(1.0);
    final bool compact = screenWidth < 360;

    return GestureDetector(
      onTap: onTap,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final cardWidth = constraints.maxWidth;

          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image
                Expanded(
                  flex: 3,
                  child: ProductListImageHelper.buildNetworkImage(
                    url: product.imageUrl,
                    width: cardWidth,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                ),
                // Content
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: EdgeInsets.all(compact ? 10 : 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.title,
                          style: TextStyle(
                            fontSize: compact ? 14 : 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                            height: textScale > 1.1 ? 1.25 : 1.2,
                          ),
                          maxLines: compact ? 2 : 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          product.subtitle,
                          style: TextStyle(
                            fontSize: compact ? 11 : 12,
                            color: AppColors.textLight,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                '\$${product.price.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: compact ? 14 : 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryGreen,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.accentLime,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth: cardWidth * 0.38,
                                ),
                                child: Text(
                                  product.tags.isNotEmpty
                                      ? product.tags.first
                                      : '',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: compact ? 9 : 10,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.accentLime,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
