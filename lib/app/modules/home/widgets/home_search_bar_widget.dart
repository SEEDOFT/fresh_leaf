import 'package:flutter/material.dart';
import 'package:fresh_leaf/shared/helpers/responsive_helper.dart';
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
      padding: EdgeInsets.symmetric(horizontal: 24.scaled),
      child: Material(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(18.scaled),
        child: InkWell(
          borderRadius: BorderRadius.circular(18.scaled),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 14.scaled,
              vertical: 14.scaled,
            ),
            child: Row(
              children: [
                Icon(Icons.search_rounded, color: scheme.onSurfaceVariant),
                SizedBox(width: 10.scaled),
                Expanded(
                  child: Text(
                    'search_hint'.tr,
                    style: TextStyle(
                      color: scheme.onSurfaceVariant,
                      fontSize: 14.scaled,
                    ),
                  ),
                ),
                Icon(
                  Icons.trending_up_rounded,
                  size: 18.scaled,
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
