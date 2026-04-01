import 'package:flutter/material.dart';
import 'package:fresh_leaf/core/models/user_address.dart';
import 'package:get/get.dart';

class ProfileAddressesListItem extends StatelessWidget {
  const ProfileAddressesListItem({
    required this.address,
    required this.isDeleting,
    required this.onEdit,
    required this.onDelete,
    super.key,
  });

  final UserAddress address;
  final bool isDeleting;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final scheme = Theme.of(context).colorScheme;
    final subtitle = [
      address.city,
      address.province,
      address.postalCode,
    ].where((value) => value.trim().isNotEmpty).join(', ');

    return Container(
      width: media.size.width,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: scheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: scheme.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  address.label.isEmpty ? 'address'.tr : address.label,
                  style: TextStyle(
                    color: scheme.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
              const Spacer(),
              Icon(
                Icons.location_on_outlined,
                color: scheme.primary,
                size: 18,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            address.recipientName.isEmpty
                ? 'recipient_not_set'.tr
                : address.recipientName,
            style: TextStyle(
              color: scheme.onSurface,
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),
          if (address.phone.trim().isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              address.phone,
              style: TextStyle(
                color: scheme.onSurfaceVariant,
                fontSize: 13,
              ),
            ),
          ],
          const SizedBox(height: 8),
          Text(
            address.addressLine1,
            style: TextStyle(
              color: scheme.onSurface,
              fontSize: 13.5,
              height: 1.3,
            ),
          ),
          if (address.addressLine2.trim().isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(
              address.addressLine2,
              style: TextStyle(
                color: scheme.onSurfaceVariant,
                fontSize: 13,
              ),
            ),
          ],
          if (subtitle.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(
                color: scheme.onSurfaceVariant,
                fontSize: 12.5,
              ),
            ),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit_location_alt_outlined, size: 18),
                  label: Text('update'.tr),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FilledButton.tonalIcon(
                  onPressed: isDeleting ? null : onDelete,
                  icon: isDeleting
                      ? const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.delete_outline, size: 18),
                  label: Text(isDeleting ? 'deleting'.tr : 'delete'.tr),
                  style: FilledButton.styleFrom(
                    foregroundColor: scheme.error,
                    backgroundColor: scheme.error.withValues(alpha: 0.12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
