import 'package:flutter/material.dart';

class AppFilterBar<T> extends StatelessWidget {
  const AppFilterBar({
    required this.filters,
    required this.selectedFilter,
    required this.onChanged,
    this.labelBuilder,
    this.iconBuilder,
    this.badgeTextBuilder,
    this.horizontalPadding = 16,
    this.height = 40,
    super.key,
  });

  final List<T> filters;
  final T selectedFilter;
  final ValueChanged<T> onChanged;
  final String Function(T)? labelBuilder;
  final IconData? Function(T)? iconBuilder;
  final String? Function(T)? badgeTextBuilder;
  final double horizontalPadding;
  final double height;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return SizedBox(
      height: height,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        itemCount: filters.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = selectedFilter == filter;
          final label = labelBuilder?.call(filter) ?? filter.toString();
          final icon = iconBuilder?.call(filter);

          return GestureDetector(
            onTap: () => onChanged(filter),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? scheme.primary : scheme.surface,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: isSelected
                          ? scheme.primary
                          : scheme.outline.withValues(alpha: 0.3),
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: scheme.primary.withValues(alpha: 0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : null,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (icon != null) ...[
                        Icon(
                          icon,
                          size: 16,
                          color: isSelected
                              ? scheme.onPrimary
                              : scheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 6),
                      ],
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: isSelected
                              ? scheme.onPrimary
                              : scheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                if (badgeTextBuilder != null)
                  Positioned(
                    right: -6,
                    child: _Badge(text: badgeTextBuilder!(filter)),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.text});

  final String? text;

  @override
  Widget build(BuildContext context) {
    if (text == null || text!.isEmpty) return const SizedBox.shrink();

    return Container(
      constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white),
      ),
      alignment: Alignment.center,
      child: Text(
        text!,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
