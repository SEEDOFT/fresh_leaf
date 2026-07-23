import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fresh_leaf/core/services/rating_service.dart';
import 'package:fresh_leaf/shared/widgets/rating_stars_widget.dart';
import 'package:get/get.dart';

class RatingBottomSheet extends StatefulWidget {
  const RatingBottomSheet({
    required this.orderItemId,
    required this.productName,
    super.key,
  });

  final int orderItemId;
  final String productName;

  @override
  State<RatingBottomSheet> createState() => _RatingBottomSheetState();
}

class _RatingBottomSheetState extends State<RatingBottomSheet> {
  final RatingService _ratingService = Get.find<RatingService>();
  double _selectedRating = 0;
  final TextEditingController _reviewController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_selectedRating == 0) {
      Get.snackbar(
        'error'.tr,
        'please_select_rating'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    setState(() => _isSubmitting = true);

    final success = await _ratingService.submitRating(
      orderItemId: widget.orderItemId,
      rating: _selectedRating.toInt(),
      review: _reviewController.text.isNotEmpty ? _reviewController.text : null,
    );

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (success) {
      Get
        ..back<bool>(result: true)
        ..snackbar(
          'success'.tr,
          'rating_submitted'.tr,
          snackPosition: SnackPosition.BOTTOM,
        );
    } else {
      Get.snackbar(
        'error'.tr,
        'failed_submit_rating'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(20, 20, 20, bottomPadding + 24),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.productName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: scheme.onSurface,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: scheme.onSurface),
                  onPressed: Get.back<void>,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'your_rating'.tr,
              style: TextStyle(
                fontSize: 14,
                color: scheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            InteractiveRatingStars(
              initialRating: _selectedRating.toInt(),
              onChanged: (rating) =>
                  setState(() => _selectedRating = rating.toDouble()),
              size: 40,
            ),
            const SizedBox(height: 20),
            Text(
              'write_a_review'.tr,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: scheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _reviewController,
              maxLines: 4,
              maxLength: 500,
              decoration: InputDecoration(
                hintText: 'review_placeholder'.tr,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: scheme.surfaceContainerHighest.withValues(
                  alpha: 0.5,
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton(
                onPressed: _isSubmitting ? null : _submit,
                style: FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(
                        'submit'.tr,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<bool?> showRatingBottomSheet({
  required int orderItemId,
  required String productName,
}) {
  return Get.bottomSheet<bool>(
    RatingBottomSheet(orderItemId: orderItemId, productName: productName),
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
  );
}
