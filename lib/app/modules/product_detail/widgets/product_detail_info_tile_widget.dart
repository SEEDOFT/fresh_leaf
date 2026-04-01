import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InfoTileWidget extends StatelessWidget {
  const InfoTileWidget({
    required this.title,
    required this.value,
    required this.icon,
    super.key,
  });

  final String title;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: scheme.shadow.withValues(alpha: 0.14),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: scheme.onSurface),
              const SizedBox(width: 6),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: scheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value.tr,
            style: TextStyle(
              fontSize: 12,
              color: scheme.onSurfaceVariant,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
