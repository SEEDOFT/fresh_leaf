import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:fresh_leaf/core/services/permission_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

class ProfileAddressesController extends GetxController {
  static const LatLng _defaultCenter = LatLng(11.5564, 104.9282);
  static const String _nominatimBaseUrl = 'https://nominatim.openstreetmap.org';

  final MapController mapController = MapController();
  final TextEditingController searchController = TextEditingController();

  final Rx<LatLng> selectedPoint = _defaultCenter.obs;
  final RxString selectedLabel = 'Phnom Penh, Cambodia'.obs;
  final RxBool isSearching = false.obs;
  final RxBool isReverseLoading = false.obs;
  final RxBool isLocating = false.obs;

  final RxList<LocationSearchItem> searchResults = <LocationSearchItem>[].obs;
  final RxList<AddressItem> savedAddresses = <AddressItem>[
    const AddressItem(
      label: 'Home',
      line1: '123 Riverside St',
      line2: 'Phnom Penh',
      phone: '+855 12 345 678',
    ),
    const AddressItem(
      label: 'Farm Hub',
      line1: '45 Organic Way',
      line2: 'Siem Reap',
      phone: '+855 98 765 432',
    ),
  ].obs;

  late final Dio _dio;

  @override
  void onInit() {
    super.onInit();
    _dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 20),
        headers: const {
          'User-Agent': 'fresh_leaf/1.0 (mobile-app)',
          'Accept': 'application/json',
        },
      ),
    );
  }

  @override
  void onReady() {
    super.onReady();
    // Ask permission and center map on first open if available.
    locateUser(silent: true);
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  Future<void> onMapTap(LatLng point) async {
    selectedPoint.value = point;
    await _reverseGeocode(point);
  }

  Future<void> searchLocation() async {
    final query = searchController.text.trim();
    if (query.isEmpty) {
      searchResults.clear();
      return;
    }

    isSearching.value = true;
    try {
      final response = await _dio.get(
        '$_nominatimBaseUrl/search',
        queryParameters: {
          'q': query,
          'format': 'jsonv2',
          'addressdetails': 1,
          'limit': 8,
        },
      );

      final list = response.data;
      if (list is List) {
        final parsed = list
            .whereType<Map>()
            .map((raw) => raw.cast<String, dynamic>())
            .map((item) {
              final lat = double.tryParse(item['lat']?.toString() ?? '');
              final lon = double.tryParse(item['lon']?.toString() ?? '');
              if (lat == null || lon == null) return null;
              return LocationSearchItem(
                displayName:
                    item['display_name']?.toString() ??
                    _formatCoords(LatLng(lat, lon)),
                point: LatLng(lat, lon),
              );
            })
            .whereType<LocationSearchItem>()
            .toList();
        searchResults.assignAll(parsed);
      } else {
        searchResults.clear();
      }
    } catch (_) {
      searchResults.clear();
      Get.snackbar('Search failed', 'Unable to search location right now');
    } finally {
      isSearching.value = false;
    }
  }

  Future<void> pickSearchResult(LocationSearchItem item) async {
    selectedPoint.value = item.point;
    selectedLabel.value = item.displayName;
    searchController.text = item.displayName;
    searchResults.clear();
    mapController.move(item.point, 16);
  }

  void clearSearchResults() {
    searchResults.clear();
  }

  Future<void> centerOnSelected() async {
    mapController.move(selectedPoint.value, 16);
  }

  Future<void> locateUser({bool silent = false}) async {
    if (isLocating.value) return;
    isLocating.value = true;

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (!silent) {
          Get.snackbar('Location off', 'Please enable location services');
        }
        return;
      }

      final granted = await PermissionService.requestLocation();
      if (!granted) {
        if (!silent) {
          Get.snackbar('Permission required', 'Location permission is needed');
        }
        return;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever ||
          permission == LocationPermission.denied) {
        if (!silent) {
          Get.snackbar('Permission denied', 'Unable to access your location');
        }
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final point = LatLng(position.latitude, position.longitude);
      selectedPoint.value = point;
      mapController.move(point, 16);
      await _reverseGeocode(point);
    } catch (_) {
      if (!silent) {
        Get.snackbar('Location error', 'Unable to get current location');
      }
    } finally {
      isLocating.value = false;
    }
  }

  Future<void> saveCurrentAddress() async {
    final point = selectedPoint.value;
    final label = selectedLabel.value.trim();

    savedAddresses.insert(
      0,
      AddressItem(
        label: 'Pinned Location',
        line1: label.isEmpty ? 'Selected location' : label,
        line2: _formatCoords(point),
        phone: '+855 12 345 678',
      ),
    );

    Get.snackbar(
      'Address saved',
      'Selected location added to your address list',
    );
  }

  Future<void> _reverseGeocode(LatLng point) async {
    isReverseLoading.value = true;
    try {
      final response = await _dio.get(
        '$_nominatimBaseUrl/reverse',
        queryParameters: {
          'lat': point.latitude,
          'lon': point.longitude,
          'format': 'jsonv2',
        },
      );

      final data = response.data;
      if (data is Map && data['display_name'] != null) {
        selectedLabel.value = data['display_name'].toString();
      } else {
        selectedLabel.value = _formatCoords(point);
      }
    } catch (_) {
      selectedLabel.value = _formatCoords(point);
    } finally {
      isReverseLoading.value = false;
    }
  }

  String _formatCoords(LatLng point) {
    return '${point.latitude.toStringAsFixed(5)}, ${point.longitude.toStringAsFixed(5)}';
  }
}

class AddressItem {
  const AddressItem({
    required this.label,
    required this.line1,
    required this.line2,
    required this.phone,
  });

  final String label;
  final String line1;
  final String line2;
  final String phone;
}

class LocationSearchItem {
  const LocationSearchItem({
    required this.displayName,
    required this.point,
  });

  final String displayName;
  final LatLng point;
}
