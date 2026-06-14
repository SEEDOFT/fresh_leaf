import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeAppDescriptionWidget extends StatelessWidget {
  const HomeAppDescriptionWidget({super.key});

  static const _version = '0.1.0';

  String _getOrdinalSuffix(int day) {
    if (day >= 11 && day <= 13) return 'th';
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final now = DateTime.now();
    final suffix = _getOrdinalSuffix(now.day);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        children: [
          const SizedBox(height: 40),
          Text(
            'FreshLeaf',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: scheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'v$_version',
            style: TextStyle(
              fontSize: 12,
              color: scheme.onSurfaceVariant.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(width: 4),
          Text.rich(
            TextSpan(
              style: TextStyle(
                fontSize: 12,
                color: scheme.onSurfaceVariant.withValues(alpha: 0.7),
              ),
              children: [
                TextSpan(text: DateFormat('EEEE d').format(now)),
                WidgetSpan(
                  child: Transform.translate(
                    offset: const Offset(0, -3),
                    child: Text(
                      suffix,
                      style: TextStyle(
                        fontSize: 9,
                        color: scheme.onSurfaceVariant.withValues(alpha: 0.7),
                      ),
                    ),
                  ),
                ),
                TextSpan(text: DateFormat(' MMMM, yyyy').format(now)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
