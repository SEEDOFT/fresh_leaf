import 'package:flutter/material.dart';
import 'package:fresh_leaf/shared/widgets/primary_button.dart';

class ProfilePrimaryActionButton extends StatelessWidget {
  const ProfilePrimaryActionButton({
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return PrimaryButton(
      label: label,
      onPressed: onPressed,
      isLoading: isLoading,
      icon: icon,
    );
  }
}
