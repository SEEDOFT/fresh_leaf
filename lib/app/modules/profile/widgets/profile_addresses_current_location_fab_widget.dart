import 'package:flutter/material.dart';
import 'package:fresh_leaf/core/theme/app_colors.dart';
import '../controllers/profile_addresses_controller.dart';

class ProfileAddressesCurrentLocationFab extends StatelessWidget {
  const ProfileAddressesCurrentLocationFab({
    super.key,
    required this.controller,
  });

  final ProfileAddressesController controller;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: scheme.surface,
      elevation: 5,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: controller.isLocating.value ? null : controller.locateUser,
        child: SizedBox(
          width: 48,
          height: 48,
          child: Center(
            child: controller.isLocating.value
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(
                    Icons.my_location_rounded,
                    color: AppColors.darkGreen,
                    size: 22,
                  ),
          ),
        ),
      ),
    );
  }
}
