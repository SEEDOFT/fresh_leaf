import 'package:flutter/material.dart';
import 'package:fresh_leaf/shared/helpers/responsive_helper.dart';

class AppPhonePrefix extends StatelessWidget {
  const AppPhonePrefix({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      margin: EdgeInsets.only(right: 8.scaled),
      padding: EdgeInsets.symmetric(horizontal: 12.scaled),
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(
            color: scheme.outline.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '🇰🇭',
            style: TextStyle(fontSize: 18.scaled),
          ),
          SizedBox(width: 4.scaled),
          Text(
            '+855',
            style: TextStyle(
              color: scheme.onSurface,
              fontWeight: FontWeight.bold,
              fontSize: 14.scaled,
            ),
          ),
        ],
      ),
    );
  }
}
