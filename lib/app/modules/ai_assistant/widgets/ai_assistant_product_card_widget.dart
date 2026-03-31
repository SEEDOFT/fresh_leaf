import 'package:flutter/material.dart';

class AiAssistantProductCard extends StatelessWidget {
  const AiAssistantProductCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.items,
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
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              imageUrl,
              height: 90,
              width: screenWidth,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return Container(
                  height: 90,
                  width: screenWidth,
                  color: scheme.surfaceContainerHighest,
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 90,
                  width: screenWidth,
                  color: scheme.surfaceContainerHighest,
                  child: Icon(
                    Icons.broken_image_rounded,
                    color: scheme.onSurfaceVariant,
                  ),
                );
              },
            ),
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
