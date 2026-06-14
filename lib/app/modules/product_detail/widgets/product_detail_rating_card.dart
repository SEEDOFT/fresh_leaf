import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/product_detail/controllers/product_detail_controller.dart';
import 'package:fresh_leaf/shared/widgets/rating_stars_widget.dart';
import 'package:get/get.dart';

class ProductDetailRatingCard extends StatelessWidget {
  const ProductDetailRatingCard({this.tag, super.key});

  final String? tag;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return GetBuilder<ProductDetailController>(
      tag: tag,
      builder: (controller) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'ratings'.tr,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: scheme.onSurface,
                  ),
                ),
                const SizedBox(width: 8),
                RatingStarsWidget(rating: controller.averageRating.value),
                const SizedBox(width: 6),
                Text(
                  '(${controller.ratingsCount.value})',
                  style: TextStyle(
                    fontSize: 14,
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...controller.ratings.map(
              (rating) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _RatingReviewTile(
                  userName: rating.userName,
                  rating: rating.rating.toDouble(),
                  review: rating.review,
                  createdAt: rating.createdAt,
                ),
              ),
            ),
            if (controller.isLoadingRatings.value)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (controller.hasMoreRatings.value)
              Center(
                child: TextButton(
                  onPressed: controller.loadRatings,
                  child: Text('load_more'.tr),
                ),
              ),
          ],
        );
      },
    );
  }
}

String _formatDate(DateTime date) {
  final now = DateTime.now();
  final diff = now.difference(date);
  if (diff.inMinutes < 1) return 'just_now'.tr;
  if (diff.inHours < 1) return '${diff.inMinutes}m ${'ago'.tr}';
  if (diff.inDays < 1) return '${diff.inHours}h ${'ago'.tr}';
  if (diff.inDays < 7) return '${diff.inDays}d ${'ago'.tr}';
  return '${date.month}/${date.day}/${date.year}';
}

class _RatingReviewTile extends StatelessWidget {
  const _RatingReviewTile({
    required this.userName,
    required this.rating,
    required this.createdAt,
    this.review,
  });

  final String userName;
  final double rating;
  final String? review;
  final DateTime createdAt;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: scheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: scheme.primaryContainer,
                child: Text(
                  userName.isNotEmpty ? userName[0].toUpperCase() : '?',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: scheme.onPrimaryContainer,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  userName,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: scheme.onSurface,
                  ),
                ),
              ),
              RatingStarsWidget(rating: rating),
            ],
          ),
          if (review != null && review!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              review!,
              style: TextStyle(
                fontSize: 13,
                color: scheme.onSurfaceVariant,
                height: 1.4,
              ),
            ),
          ],
          const SizedBox(height: 4),
          Text(
            _formatDate(createdAt),
            style: TextStyle(
              fontSize: 11,
              color: scheme.onSurfaceVariant.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}
