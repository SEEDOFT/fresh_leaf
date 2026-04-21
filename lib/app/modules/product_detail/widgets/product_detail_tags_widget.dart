import 'package:flutter/material.dart';
import 'package:fresh_leaf/shared/widgets/app_badge.dart';
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
            (tag) => AppBadge(
              label: tag.tr,
              backgroundColor: scheme.surfaceContainerHighest,
              foregroundColor: scheme.onSurface,
              borderRadius: 16,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          )
          .toList(),
    );
  }
}
