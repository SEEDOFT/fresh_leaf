import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TagsWidget extends StatelessWidget {
  const TagsWidget({
    required this.tags,
    super.key,
  });

  final List<String> tags;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: tags
          .map(
            (tag) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: scheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                tag.tr,
                style: TextStyle(
                  fontSize: 12,
                  color: scheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
