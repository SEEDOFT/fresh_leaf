import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:fresh_leaf/app/modules/profile/widgets/profile_widget.dart';
import 'package:fresh_leaf/core/theme/app_colors.dart';
import 'package:get/get.dart';
import '../controllers/profile_addresses_controller.dart';

class AddressesView extends GetView<ProfileAddressesController> {
  const AddressesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundCream,
      appBar: const ProfileAppBar(title: 'Select Address'),
      body: Obx(
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
              child: _SearchBar(controller: controller),
            ),
            if (controller.searchResults.isNotEmpty)
              Positioned(
                top: 74,
                left: 16,
                right: 16,
                child: _SearchResultList(controller: controller),
              ),
            Positioned(
              right: 16,
              bottom: 230,
              child: Material(
                color: Colors.white,
                elevation: 3,
                borderRadius: BorderRadius.circular(18),
                child: IconButton(
                  onPressed: controller.locateUser,
                  icon: controller.isLocating.value
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(
                          Icons.my_location,
                          color: AppColors.darkGreen,
                        ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _LocationSheet(controller: controller),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.controller});

  final ProfileAddressesController controller;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            const Icon(Icons.search, color: AppColors.textLight),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: controller.searchController,
                textInputAction: TextInputAction.search,
                onSubmitted: (_) => controller.searchLocation(),
                decoration: const InputDecoration(
                  hintText: 'Search location',
                  border: InputBorder.none,
                ),
              ),
            ),
            if (controller.isSearching.value)
              const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            else
              IconButton(
                onPressed: controller.searchLocation,
                icon: const Icon(
                  Icons.arrow_forward,
                  color: AppColors.darkGreen,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _SearchResultList extends StatelessWidget {
  const _SearchResultList({required this.controller});

  final ProfileAddressesController controller;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 6,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        constraints: const BoxConstraints(maxHeight: 260),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: ListView.separated(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: controller.searchResults.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final item = controller.searchResults[index];
            return ListTile(
              dense: true,
              leading: const Icon(
                Icons.place_outlined,
                color: AppColors.darkGreen,
              ),
              title: Text(
                item.displayName,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 13, color: AppColors.textDark),
              ),
              onTap: () => controller.pickSearchResult(item),
            );
          },
        ),
      ),
    );
  }
}

class _LocationSheet extends StatelessWidget {
  const _LocationSheet({required this.controller});

  final ProfileAddressesController controller;

  @override
  Widget build(BuildContext context) {
    final point = controller.selectedPoint.value;

    return Container(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Color(0x1F000000),
            blurRadius: 20,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
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
            const Text(
              'Selected Location',
              style: TextStyle(
                color: AppColors.textLight,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 6),
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
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
            const SizedBox(height: 4),
            Text(
              '${point.latitude.toStringAsFixed(5)}, ${point.longitude.toStringAsFixed(5)}',
              style: const TextStyle(
                color: AppColors.textLight,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: controller.saveCurrentAddress,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.darkGreen,
                      minimumSize: const Size(0, 46),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    icon: const Icon(Icons.bookmark_add, color: Colors.white),
                    label: const Text(
                      'Save Address',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Text(
              'Recent',
              style: TextStyle(
                color: AppColors.textLight,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 58,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: controller.savedAddresses.length > 4
                    ? 4
                    : controller.savedAddresses.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final item = controller.savedAddresses[index];
                  return Container(
                    width: 160,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.cardLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          item.line1,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textLight,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
