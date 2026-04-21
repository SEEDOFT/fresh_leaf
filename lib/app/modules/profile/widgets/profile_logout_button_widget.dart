import 'package:flutter/material.dart';
import 'package:fresh_leaf/shared/widgets/primary_button.dart';
import 'package:get/get.dart';

class ProfileLogoutButton extends StatelessWidget {
  const ProfileLogoutButton({
    required this.onTap,
    required this.isLoading,
    super.key,
  });
  final VoidCallback onTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return PrimaryButton(
      label: 'log_out'.tr,
      onPressed: onTap,
      isLoading: isLoading,
      borderRadius: 16,
    );
  }
}
