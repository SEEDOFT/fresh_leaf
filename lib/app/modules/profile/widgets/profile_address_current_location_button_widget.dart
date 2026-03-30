import 'package:flutter/material.dart';
import 'package:fresh_leaf/core/theme/app_colors.dart';

class ProfileAddressCurrentLocationButton extends StatelessWidget {
  const ProfileAddressCurrentLocationButton({
    super.key,
    required this.onTap,
    required this.isLoading,
  });

  final VoidCallback onTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: scheme.surface,
      elevation: 5,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: isLoading ? null : onTap,
        child: SizedBox(
          width: 48,
          height: 48,
          child: Center(
            child: isLoading
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
