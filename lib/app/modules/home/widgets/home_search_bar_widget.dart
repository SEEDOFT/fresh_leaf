import 'package:flutter/material.dart';
import 'package:fresh_leaf/core/constants/app_sizes.dart';
import 'package:get/get.dart';

class HomeSearchBarWidget extends StatelessWidget {
  const HomeSearchBarWidget({
    required this.onTap,
    super.key,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSizes.s24),
      child: Material(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(AppSizes.s18),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppSizes.s18),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.s14,
              vertical: AppSizes.s14,
            ),
            child: Row(
              children: [
                Icon(Icons.search_rounded, color: scheme.onSurfaceVariant),
                SizedBox(width: AppSizes.s10),
                Expanded(
                  child: Text(
                    'search_hint'.tr,
                    style: TextStyle(
                      color: scheme.onSurfaceVariant,
                      fontSize: AppSizes.s14,
                    ),
                  ),
                ),
                Icon(
                  Icons.trending_up_rounded,
                  size: AppSizes.s18,
                  color: scheme.primary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
