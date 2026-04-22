import 'package:flutter/material.dart';
import 'package:fresh_leaf/shared/helpers/responsive_helper.dart';

Widget appBar() {
  return Builder(
    builder: (context) {
      final scheme = Theme.of(context).colorScheme;
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.scaled),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: scheme.onSurface,
                  size: 20.scaled,
                ),
                SizedBox(width: 8.scaled),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Organic Farm,',
                      style: TextStyle(
                        fontSize: 12.scaled,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'CA',
                      style: TextStyle(
                        fontSize: 12.scaled,
                        color: scheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  'FreshLeaf',
                  style: TextStyle(
                    fontSize: 16.scaled,
                    fontWeight: FontWeight.w900,
                    color: scheme.onSurface,
                  ),
                ),
                Text(
                  'Organic',
                  style: TextStyle(
                    fontSize: 14.scaled,
                    fontWeight: FontWeight.w600,
                    color: scheme.onSurface,
                  ),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.all(8.scaled),
              decoration: BoxDecoration(
                color: scheme.surfaceContainerHighest,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.notifications_outlined,
                size: 20.scaled,
                color: scheme.onSurface,
              ),
            ),
          ],
        ),
      );
    },
  );
}
