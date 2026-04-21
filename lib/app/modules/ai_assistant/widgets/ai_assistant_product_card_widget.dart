import 'package:flutter/material.dart';
import 'package:fresh_leaf/shared/widgets/app_network_image.dart';

class AiAssistantProductCard extends StatelessWidget {
  const AiAssistantProductCard({
    required this.imageUrl,
    required this.title,
    required this.items,
    super.key,
  });

  final String imageUrl;
  final String title;
  final String items;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final scheme = Theme.of(context).colorScheme;

    return Container(
      width: 140,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: scheme.shadow.withValues(alpha: 0.14),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppNetworkImage(
            url: imageUrl,
            height: 90,
            width: screenWidth,
            borderRadius: BorderRadius.circular(12),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 13,
              color: scheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            items,
            style: TextStyle(
              fontSize: 11,
              color: scheme.onSurfaceVariant,
              height: 1.3,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
