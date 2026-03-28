import 'package:flutter/material.dart';
import 'package:fresh_leaf/core/theme/app_colors.dart';

class ProfilePersonalWidget extends StatelessWidget {
  const ProfilePersonalWidget({super.key});

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

class PersonalDetailsField extends StatelessWidget {
  const PersonalDetailsField({
    super.key,
    required this.label,
    this.hint,
    this.keyboard,
  });

  final String label;
  final String? hint;
  final TextInputType? keyboard;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            color: AppColors.textLight,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          keyboardType: keyboard,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.grayBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.darkGreen,
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
