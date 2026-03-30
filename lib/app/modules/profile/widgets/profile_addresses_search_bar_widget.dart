import 'package:flutter/material.dart';
import 'package:fresh_leaf/core/theme/app_colors.dart';
import '../controllers/profile_addresses_controller.dart';

class ProfileAddressesSearchBar extends StatelessWidget {
  const ProfileAddressesSearchBar({super.key, required this.controller});

  final ProfileAddressesController controller;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: scheme.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            Icon(Icons.search, color: scheme.onSurfaceVariant),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: controller.searchController,
                textInputAction: TextInputAction.search,
                onSubmitted: (_) => controller.searchLocation(),
                decoration: const InputDecoration(
                  hintText: 'Search location',
                  border: InputBorder.none,
                ),
              ),
            ),
            if (controller.isSearching.value)
              const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            else
              IconButton(
                onPressed: controller.searchLocation,
                icon: const Icon(
                  Icons.arrow_forward,
                  color: AppColors.darkGreen,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
