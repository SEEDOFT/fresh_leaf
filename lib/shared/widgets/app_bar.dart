import 'package:flutter/material.dart';
import 'package:fresh_leaf/core/theme/app_colors.dart';

Widget appBar() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 24),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Icon(
              Icons.location_on,
              color: AppColors.textDark,
              size: 20,
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Organic Farm,',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
                Text(
                  'CA',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textDark.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ],
        ),
        const Column(
          children: [
            Text(
              'FreshLeaf',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: AppColors.textDark,
              ),
            ),
            Text(
              'Organic',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            color: AppColors.cardLight,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.notifications_outlined,
            size: 20,
            color: AppColors.textDark,
          ),
        ),
      ],
    ),
  );
}
