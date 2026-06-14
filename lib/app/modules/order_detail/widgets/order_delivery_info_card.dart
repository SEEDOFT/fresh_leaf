import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fresh_leaf/core/models/order.dart';
import 'package:fresh_leaf/shared/widgets/app_card.dart';
import 'package:get/get.dart';

class OrderDeliveryInfoCard extends StatelessWidget {
  const OrderDeliveryInfoCard({
    required this.order,
    required this.width,
    super.key,
  });

  final Order order;
  final double width;

  @override
  Widget build(BuildContext context) {
    if (order.deliveryCompanyName == null &&
        order.preparationProofPhoto == null) {
      return const SizedBox.shrink();
    }

    final scheme = Theme.of(context).colorScheme;

    return AppCard(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'delivery_information'.tr,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: scheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          if (order.deliveryCompanyName != null) ...[
            _buildInfoRow(
              context,
              'delivery_company'.tr,
              order.deliveryCompanyName!,
            ),
          ],
          if (order.deliveryTrackingInfo != null &&
              order.deliveryTrackingInfo!.isNotEmpty) ...[
            const SizedBox(height: 8),
            _buildInfoRow(
              context,
              'tracking_info'.tr,
              order.deliveryTrackingInfo!,
            ),
          ],
          if (order.preparationProofPhoto != null) ...[
            const SizedBox(height: 16),
            Text(
              'proof_of_preparation'.tr,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: scheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: order.preparationProofPhoto!,
                width: MediaQuery.of(context).size.width,
                height: 200,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  height: 200,
                  color: scheme.surfaceContainerHighest,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: scheme.primary,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  height: 200,
                  color: scheme.surfaceContainerHighest,
                  child: Icon(
                    Icons.broken_image_rounded,
                    color: scheme.onSurfaceVariant,
                    size: 48,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: scheme.onSurfaceVariant,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: scheme.onSurface,
            ),
          ),
        ),
      ],
    );
  }
}
