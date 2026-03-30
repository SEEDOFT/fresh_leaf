import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:fresh_leaf/app/modules/profile/widgets/profile_addresses_widget.dart';
import 'package:fresh_leaf/app/modules/profile/widgets/profile_widget.dart';
import 'package:fresh_leaf/core/theme/app_colors.dart';
import 'package:get/get.dart';
import '../controllers/profile_addresses_controller.dart';

class AddressesView extends GetView<ProfileAddressesController> {
  const AddressesView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final fabBottom = screenHeight * 0.34;
    final scaffoldBg = Theme.of(context).scaffoldBackgroundColor;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: scaffoldBg,
        appBar: const ProfileAppBar(title: 'Select Address'),
        body: SafeArea(
          child: Obx(
            () => Stack(
              children: [
                Positioned.fill(
                  child: FlutterMap(
                    mapController: controller.mapController,
                    options: MapOptions(
                      initialCenter: controller.selectedPoint.value,
                      initialZoom: 14,
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
                            width: 48,
                            height: 48,
                            child: const Icon(
                              Icons.location_on,
                              size: 44,
                              color: AppColors.error,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 14,
                  left: 16,
                  right: 16,
                  child: ProfileAddressesSearchBar(controller: controller),
                ),
                if (controller.searchResults.isNotEmpty)
                  Positioned(
                    top: 74,
                    left: 16,
                    right: 16,
                    child: ProfileAddressesSearchResultList(
                      controller: controller,
                    ),
                  ),
                Positioned(
                  right: 16,
                  bottom: fabBottom,
                  child: ProfileAddressesCurrentLocationFab(
                    controller: controller,
                  ),
                ),
                DraggableScrollableSheet(
                  initialChildSize: 0.30,
                  minChildSize: 0.24,
                  maxChildSize: 0.78,
                  snap: true,
                  snapSizes: const [0.30, 0.55, 0.78],
                  builder: (context, scrollController) {
                    return ProfileAddressesLocationSheet(
                      controller: controller,
                      scrollController: scrollController,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
