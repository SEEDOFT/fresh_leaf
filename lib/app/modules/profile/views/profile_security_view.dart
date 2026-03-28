import 'package:flutter/material.dart';
import 'package:fresh_leaf/core/theme/app_colors.dart';
import 'package:get/get.dart';
import '../controllers/profile_security_controller.dart';

class SecuritySettingsView extends GetView<ProfileSecurityController> {
  const SecuritySettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _appBar('Security'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          children: [
            const _PasswordField(label: 'Current Password'),
            const SizedBox(height: 14),
            const _PasswordField(label: 'New Password'),
            const SizedBox(height: 14),
            const _PasswordField(label: 'Confirm New Password'),
            const SizedBox(height: 20),
            const _SwitchTile(
              label: 'Two-Factor Authentication',
              subtitle: 'Protect your account with an extra step',
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.darkGreen,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                ),
                child: const Text(
                  'Update Security',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

PreferredSizeWidget _appBar(String title) {
  return AppBar(
    backgroundColor: AppColors.background,
    elevation: 0,
    leading: IconButton(
      icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: AppColors.textDark),
      onPressed: Get.back,
    ),
    title: Text(
      title,
      style: const TextStyle(color: AppColors.textDark, fontWeight: FontWeight.w700, fontSize: 16),
    ),
  );
}

class _PasswordField extends StatefulWidget {
  const _PasswordField({required this.label});
  final String label;

  @override
  State<_PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<_PasswordField> {
  bool obscure = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label.toUpperCase(),
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            color: AppColors.textLight,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          obscureText: obscure,
          obscuringCharacter: '•',
          decoration: InputDecoration(
            hintText: '••••••••',
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.grayBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.darkGreen, width: 1.5),
            ),
            suffixIcon: IconButton(
              icon: Icon(obscure ? Icons.visibility_off : Icons.visibility, color: AppColors.textLight),
              onPressed: () => setState(() => obscure = !obscure),
            ),
          ),
        ),
      ],
    );
  }
}

class _SwitchTile extends StatefulWidget {
  const _SwitchTile({required this.label, this.subtitle});
  final String label;
  final String? subtitle;

  @override
  State<_SwitchTile> createState() => _SwitchTileState();
}

class _SwitchTileState extends State<_SwitchTile> {
  bool enabled = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.grayBorder),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.label,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
                if (widget.subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    widget.subtitle!,
                    style: const TextStyle(color: AppColors.textLight, fontSize: 12),
                  ),
                ],
              ],
            ),
          ),
          Switch(
            value: enabled,
            activeColor: Colors.white,
            activeTrackColor: AppColors.darkGreen,
            onChanged: (v) => setState(() => enabled = v),
          ),
        ],
      ),
    );
  }
}
