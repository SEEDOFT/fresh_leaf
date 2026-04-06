import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ProfileHelpContactCard extends StatelessWidget {
  const ProfileHelpContactCard({
    required this.companyName,
    required this.supportEmail,
    required this.supportPhone,
    required this.officeAddress,
    super.key,
  });

  final String companyName;
  final String supportEmail;
  final String supportPhone;
  final String officeAddress;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final media = MediaQuery.of(context);

    return Container(
      width: media.size.width,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: scheme.outline.withValues(alpha: 0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Contact $companyName',
            style: TextStyle(
              color: scheme.onSurface,
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          _ContactRow(
            icon: Icons.email_outlined,
            title: 'Email',
            value: supportEmail,
            onTap: () => _copyValue(
              label: 'email',
              value: supportEmail,
            ),
          ),
          const SizedBox(height: 8),
          _ContactRow(
            icon: Icons.phone_outlined,
            title: 'Phone',
            value: supportPhone,
            onTap: () => _copyValue(
              label: 'phone',
              value: supportPhone,
            ),
          ),
          const SizedBox(height: 8),
          _ContactRow(
            icon: Icons.location_on_outlined,
            title: 'Address',
            value: officeAddress,
          ),
        ],
      ),
    );
  }

  Future<void> _copyValue({
    required String label,
    required String value,
  }) async {
    await Clipboard.setData(ClipboardData(text: value));
    Get.snackbar(
      'Copied',
      '$label copied to clipboard',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 1),
    );
  }
}

class _ContactRow extends StatelessWidget {
  const _ContactRow({
    required this.icon,
    required this.title,
    required this.value,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
        child: Row(
          children: [
            Icon(icon, size: 18, color: scheme.primary),
            const SizedBox(width: 8),
            Text(
              '$title:',
              style: TextStyle(
                color: scheme.onSurfaceVariant,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                value,
                style: TextStyle(
                  color: scheme.onSurface,
                  fontSize: 13.5,
                ),
              ),
            ),
            if (onTap != null)
              Icon(
                Icons.copy_outlined,
                size: 16,
                color: scheme.onSurfaceVariant,
              ),
          ],
        ),
      ),
    );
  }
}
