import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:fresh_leaf/app/modules/profile/controllers/profile_address_edit_controller.dart';
import 'package:fresh_leaf/app/modules/profile/widgets/profile_address_edit_widget.dart';
import 'package:fresh_leaf/core/theme/app_colors.dart';
import 'package:fresh_leaf/shared/widgets/custom_app_bar.dart';
import 'package:get/get.dart';

class ProfileAddressEditView extends GetView<ProfileAddressEditController> {
  const ProfileAddressEditView({super.key});

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final scheme = Theme.of(context).colorScheme;
    final scaffoldBg = Theme.of(context).scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: CustomAppBar(
        title: controller.isEditMode ? 'update_address'.tr : 'add_address'.tr,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final viewportHeight = constraints.maxHeight;
          return Obx(() {
            final sheetTop =
                viewportHeight * (1 - controller.sheetExtent.value);
            final buttonTop = (sheetTop - 60).clamp(
              110.0,
              viewportHeight - 90.0,
            );
            return Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: FlutterMap(
                    mapController: controller.mapController,
                    options: MapOptions(
                      initialCenter: controller.selectedPoint.value,
                      initialZoom: 15,
                      minZoom: 4,
                      maxZoom: 19,
                      onTap: (tapPosition, point) => controller.onMapTap(point),
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.freshleaf.app',
                      ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: controller.selectedPoint.value,
                            width: 44,
                            height: 44,
                            child: const Icon(
                              Icons.location_on,
                              size: 40,
                              color: AppColors.error,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 12,
                  left: 16,
                  right: 16,
                  child: Column(
                    children: [
                      Material(
                        borderRadius: BorderRadius.circular(14),
                        color: scheme.surface,
                        elevation: 4,
                        child: TextField(
                          controller: controller.searchController,
                          textInputAction: TextInputAction.search,
                          onChanged: controller.onSearchChanged,
                          onSubmitted: (_) => controller.searchLocation(),
                          decoration: InputDecoration(
                            hintText: 'search_location'.tr,
                            prefixIcon: const Icon(Icons.search_rounded),
                            suffixIcon: controller.isSearching.value
                                ? const Padding(
                                    padding: EdgeInsets.all(14),
                                    child: SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  )
                                : (controller.searchQuery.value.isEmpty
                                      ? null
                                      : IconButton(
                                          onPressed: controller.clearSearch,
                                          icon: const Icon(Icons.close_rounded),
                                        )),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: scheme.surfaceContainerHighest,
                          ),
                        ),
                      ),
                      if (controller.searchResults.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Container(
                          constraints: BoxConstraints(
                            maxHeight: viewportHeight * 0.22,
                          ),
                          decoration: BoxDecoration(
                            color: scheme.surface,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: scheme.outline.withValues(alpha: 0.2),
                            ),
                          ),
                          child: ListView.separated(
                            shrinkWrap: true,
                            itemCount: controller.searchResults.length,
                            separatorBuilder: (_, _) => Divider(
                              height: 1,
                              color: scheme.outline.withValues(alpha: 0.15),
                            ),
                            itemBuilder: (context, index) {
                              final item = controller.searchResults[index];
                              return ListTile(
                                dense: true,
                                leading: Icon(
                                  Icons.place_outlined,
                                  color: scheme.primary,
                                  size: 20,
                                ),
                                title: Text(
                                  item.displayName,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: scheme.onSurface,
                                    fontSize: 13,
                                  ),
                                ),
                                onTap: () => controller.pickSearchResult(item),
                              );
                            },
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Positioned(
                  right: 16,
                  top: buttonTop,
                  child: ProfileAddressCurrentLocationButton(
                    onTap: controller.locateUser,
                    isLoading: controller.isLocating.value,
                  ),
                ),
                NotificationListener<DraggableScrollableNotification>(
                  onNotification: (notification) {
                    controller.onSheetExtentChanged(notification.extent);
                    return false;
                  },
                  child: DraggableScrollableSheet(
                    initialChildSize: 0.54,
                    minChildSize: 0.22,
                    maxChildSize: 0.90,
                    snap: true,
                    snapSizes: const [0.22, 0.54, 0.90],
                    builder: (context, scrollController) {
                      return Container(
                        decoration: BoxDecoration(
                          color: scheme.surface,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(24),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: scheme.shadow.withValues(alpha: 0.18),
                              blurRadius: 18,
                              offset: const Offset(0, -4),
                            ),
                          ],
                        ),
                        child: SafeArea(
                          top: false,
                          child: ListView(
                            controller: scrollController,
                            padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
                            children: [
                              Center(
                                child: Container(
                                  width: 38,
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color: scheme.outline,
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              if (controller.isReverseLoading.value)
                                Row(
                                  children: [
                                    const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text('resolving_address'.tr),
                                  ],
                                )
                              else
                                Text(
                                  controller.selectedLabel.value,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: scheme.onSurfaceVariant,
                                  ),
                                ),
                              const SizedBox(height: 14),
                              ProfileAddressEditField(
                                label: 'address_label'.tr,
                                hintText: 'address_label_home'.tr,
                                controller: controller.labelController,
                              ),
                              const SizedBox(height: 12),
                              ProfileAddressEditField(
                                label: 'recipient_name'.tr,
                                hintText: 'placeholder_name'.tr,
                                controller: controller.recipientNameController,
                              ),
                              const SizedBox(height: 12),
                              ProfileAddressEditField(
                                label: 'phone'.tr,
                                hintText: 'placeholder_phone'.tr,
                                controller: controller.phoneController,
                                keyboardType: TextInputType.phone,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp('[0-9+]'),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              ProfileAddressEditField(
                                label: 'address_line_1'.tr,
                                hintText: 'placeholder_address_line_1'.tr,
                                controller: controller.line1Controller,
                                maxLines: 2,
                              ),
                              const SizedBox(height: 12),
                              ProfileAddressEditField(
                                label: 'address_line_2'.tr,
                                hintText: 'placeholder_address_line_2'.tr,
                                controller: controller.line2Controller,
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: ProfileAddressEditField(
                                      label: 'city'.tr,
                                      hintText: 'placeholder_city'.tr,
                                      controller: controller.cityController,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: ProfileAddressEditField(
                                      label: 'province'.tr,
                                      hintText: 'placeholder_province'.tr,
                                      controller: controller.provinceController,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              ProfileAddressEditField(
                                label: 'postal_code'.tr,
                                hintText: 'placeholder_postal_code'.tr,
                                controller: controller.postalCodeController,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                              ),
                              const SizedBox(height: 18),
                              SizedBox(
                                width: media.size.width,
                                child: FilledButton.icon(
                                  onPressed: controller.isSaving.value
                                      ? null
                                      : controller.save,
                                  icon: controller.isSaving.value
                                      ? const SizedBox(
                                          width: 16,
                                          height: 16,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : Icon(
                                          controller.isEditMode
                                              ? Icons.save_alt
                                              : Icons.add,
                                        ),
                                  label: Text(
                                    controller.isSaving.value
                                        ? 'saving'.tr
                                        : controller.isEditMode
                                        ? 'update_address'.tr
                                        : 'create_address'.tr,
                                  ),
                                ),
                              ),
                              if (controller.isEditMode) ...[
                                const SizedBox(height: 10),
                                SizedBox(
                                  width: media.size.width,
                                  child: OutlinedButton.icon(
                                    onPressed: controller.isDeleting.value
                                        ? null
                                        : controller.deleteAddress,
                                    icon: controller.isDeleting.value
                                        ? const SizedBox(
                                            width: 16,
                                            height: 16,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : const Icon(Icons.delete_outline),
                                    label: Text(
                                      controller.isDeleting.value
                                          ? 'deleting'.tr
                                          : 'delete'.tr,
                                    ),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: scheme.error,
                                      side: BorderSide(
                                        color: scheme.error.withValues(
                                          alpha: 0.55,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          });
        },
      ),
    );
  }
}
