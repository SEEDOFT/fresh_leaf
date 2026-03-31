import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/profile/widgets/profile_addresses_list_item_widget.dart';
import 'package:fresh_leaf/app/modules/profile/widgets/profile_widget.dart';
import 'package:fresh_leaf/core/models/user_address.dart';
import 'package:get/get.dart';
import '../controllers/profile_addresses_controller.dart';

class AddressesView extends GetView<ProfileAddressesController> {
  const AddressesView({super.key});

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final scheme = Theme.of(context).colorScheme;
    final scaffoldBg = Theme.of(context).scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: ProfileAppBar(title: 'my_addresses'.tr),
      body: SafeArea(
        child: Obx(
          () => RefreshIndicator(
            onRefresh: () async {
              await Future.delayed(const Duration(milliseconds: 1500));

              return controller.refreshAddresses();
            },
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 20),
              children: [
                Container(
                  width: media.size.width,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: scheme.surface,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: scheme.outline.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: scheme.primary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.location_on_outlined,
                          color: scheme.primary,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'delivery_locations'.tr,
                              style: TextStyle(
                                color: scheme.onSurface,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'delivery_locations_subtitle'.tr,
                              style: TextStyle(
                                color: scheme.onSurfaceVariant,
                                fontSize: 13,
                                height: 1.3,
                              ),
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: media.size.width,
                              child: FilledButton.icon(
                                onPressed: controller.openCreateAddress,
                                icon: const Icon(
                                  Icons.add_location_alt_outlined,
                                ),
                                label: Text('add_new_address'.tr),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                _buildContent(
                  context: context,
                  addresses: controller.savedAddresses,
                  isLoading: controller.isLoadingAddresses.value,
                  deletingId: controller.deletingAddressId.value,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent({
    required BuildContext context,
    required List<UserAddress> addresses,
    required bool isLoading,
    required String deletingId,
  }) {
    final media = MediaQuery.of(context);
    final scheme = Theme.of(context).colorScheme;

    if (isLoading && addresses.isEmpty) {
      return SizedBox(
        width: media.size.width,
        height: media.size.height * 0.35,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (addresses.isEmpty) {
      return Container(
        width: media.size.width,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 22),
        decoration: BoxDecoration(
          color: scheme.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: scheme.outline.withValues(alpha: 0.18),
          ),
        ),
        child: Column(
          children: [
            Icon(
              Icons.location_off_outlined,
              color: scheme.onSurfaceVariant,
              size: 40,
            ),
            const SizedBox(height: 8),
            Text(
              'no_addresses_yet'.tr,
              style: TextStyle(
                color: scheme.onSurface,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'add_first_delivery_location'.tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: scheme.onSurfaceVariant,
                fontSize: 13,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        for (final item in addresses) ...[
          ProfileAddressesListItem(
            address: item,
            isDeleting: deletingId == item.id,
            onEdit: () => controller.openEditAddress(item),
            onDelete: () => controller.requestDeleteAddress(item),
          ),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}
