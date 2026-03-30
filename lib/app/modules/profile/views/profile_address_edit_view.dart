import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:fresh_leaf/app/modules/profile/widgets/profile_address_edit_widget.dart';
import 'package:fresh_leaf/app/modules/profile/widgets/profile_widget.dart';
import 'package:fresh_leaf/core/theme/app_colors.dart';
import 'package:get/get.dart';

import '../controllers/profile_address_edit_controller.dart';

class ProfileAddressEditView extends GetView<ProfileAddressEditController> {
  const ProfileAddressEditView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final scheme = Theme.of(context).colorScheme;
    final scaffoldBg = Theme.of(context).scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: const ProfileAppBar(title: 'Update Address'),
      body: Obx(
        () => Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: screenHeight * 0.43,
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
              right: 16,
              top: screenHeight * 0.34,
              child: ProfileAddressCurrentLocationButton(
                onTap: controller.locateUser,
                isLoading: controller.isLocating.value,
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              top: screenHeight * 0.37,
              child: Container(
                decoration: BoxDecoration(
                  color: scheme.surface,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x1F000000),
                      blurRadius: 18,
                      offset: Offset(0, -4),
                    ),
                  ],
                ),
                child: SafeArea(
                  top: false,
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
                    children: [
                      Center(
                        child: Container(
                          width: 38,
                          height: 4,
                          decoration: BoxDecoration(
                            color: AppColors.grayBorder,
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (controller.isReverseLoading.value)
                        const Row(
                          children: [
                            SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                            SizedBox(width: 8),
                            Text('Resolving address...'),
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
                        label: 'Label',
                        controller: controller.labelController,
                      ),
                      const SizedBox(height: 12),
                      ProfileAddressEditField(
                        label: 'Address',
                        controller: controller.line1Controller,
                        maxLines: 2,
                      ),
                      const SizedBox(height: 12),
                      ProfileAddressEditField(
                        label: 'Phone',
                        controller: controller.phoneController,
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: screenWidth,
                        child: ElevatedButton.icon(
                          onPressed: controller.save,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.darkGreen,
                            minimumSize: Size(screenWidth, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 0,
                          ),
                          icon: const Icon(Icons.save_alt, color: Colors.white),
                          label: const Text(
                            'Update Address',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
