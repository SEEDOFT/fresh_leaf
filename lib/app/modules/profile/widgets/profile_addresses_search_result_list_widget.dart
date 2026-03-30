import 'package:flutter/material.dart';
import 'package:fresh_leaf/core/theme/app_colors.dart';
import '../controllers/profile_addresses_controller.dart';

class ProfileAddressesSearchResultList extends StatelessWidget {
  const ProfileAddressesSearchResultList({
    super.key,
    required this.controller,
  });

  final ProfileAddressesController controller;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      elevation: 6,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        constraints: const BoxConstraints(maxHeight: 260),
        decoration: BoxDecoration(
          color: scheme.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: ListView.separated(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: controller.searchResults.length,
          separatorBuilder: (_, _) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final item = controller.searchResults[index];
            return ListTile(
              dense: true,
              leading: const Icon(
                Icons.place_outlined,
                color: AppColors.darkGreen,
              ),
              title: Text(
                item.displayName,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 13, color: scheme.onSurface),
              ),
              onTap: () => controller.pickSearchResult(item),
            );
          },
        ),
      ),
    );
  }
}
