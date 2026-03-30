import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:fresh_leaf/app/routes/app_routes.dart';
import 'package:fresh_leaf/core/constants/api_endpoints.dart';
import 'package:fresh_leaf/core/models/api_response.dart';
import 'package:fresh_leaf/core/models/user_profile.dart';
import 'package:fresh_leaf/core/models/user_address.dart';
import 'package:fresh_leaf/core/services/api_client.dart';
import 'package:fresh_leaf/core/services/permission_service.dart';
import 'package:fresh_leaf/core/services/storage_service.dart';
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
  final RxBool isSavingAddress = false.obs;
  final RxBool isLoadingAddresses = false.obs;

  final RxList<LocationSearchItem> searchResults = <LocationSearchItem>[].obs;
  final RxList<UserAddress> savedAddresses = <UserAddress>[].obs;

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
    fetchSavedAddresses(showError: false);
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
    if (isSavingAddress.value) return;
    isSavingAddress.value = true;

    final point = selectedPoint.value;
    try {
      final payload = _buildAddressPayload(point);
      final api = Get.find<ApiClient>();
      final response = await api.postRequest(
        ApiEndpoints.userAddresses,
        data: payload,
      );

      final apiResponse = ApiResponse.fromResponse<dynamic>(
        response.data,
        (json) => json,
      );

      if (!apiResponse.isSuccess && response.statusCode != 201) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Unable to save address',
        );
      }

      await fetchSavedAddresses(showError: false);

      Get.snackbar(
        'Address saved',
        apiResponse.status.message.isNotEmpty
            ? apiResponse.status.message
            : 'Selected location added to your address list',
      );
    } catch (e) {
      final message = e is DioException
          ? e.response?.data?['status']?['message']?.toString() ??
                'Unable to save address'
          : 'Unable to save address';
      Get.snackbar('Save failed', message);
    } finally {
      isSavingAddress.value = false;
    }
  }

  Future<void> fetchSavedAddresses({bool showError = true}) async {
    if (isLoadingAddresses.value) return;
    isLoadingAddresses.value = true;

    try {
      final api = Get.find<ApiClient>();
      final response = await api.getRequest(ApiEndpoints.userAddresses);
      final apiResponse = ApiResponse.fromResponse<dynamic>(
        response.data,
        (json) => json,
      );

      if (!apiResponse.isSuccess && response.statusCode != 200) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Unable to fetch addresses',
        );
      }

      final items = _extractAddressMaps(apiResponse.data)
          .map(UserAddress.fromMap)
          .toList();
      savedAddresses.assignAll(items);
    } catch (e) {
      if (showError) {
        final message = e is DioException
            ? e.response?.data?['status']?['message']?.toString() ??
                  'Unable to load addresses'
            : 'Unable to load addresses';
        Get.snackbar('Fetch failed', message);
      }
    } finally {
      isLoadingAddresses.value = false;
    }
  }

  Future<void> openEditAddress(int index) async {
    if (index < 0 || index >= savedAddresses.length) return;
    final current = savedAddresses[index];

    final result = await Get.toNamed(
      AppRoutes.addressesEdit,
      arguments: {
        'index': index,
        'label': current.label,
        'line1': current.line1,
        'line2': current.line2,
        'phone': current.phone,
        'latitude': current.latitude,
        'longitude': current.longitude,
      },
    );

    if (result is Map<String, dynamic>) {
      savedAddresses[index] = current.copyWith(
        label: result['label']?.toString(),
        addressLine1: result['line1']?.toString(),
        addressLine2: result['line2']?.toString(),
        phone: result['phone']?.toString(),
        lat: _toDouble(result['latitude']),
        long: _toDouble(result['longitude']),
      );
      savedAddresses.refresh();
      Get.snackbar('Updated', 'Address updated successfully');
    }
  }

  double? _toDouble(Object? value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '');
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

  Map<String, dynamic> _buildAddressPayload(LatLng point) {
    final labelText = selectedLabel.value.trim();
    final parts = labelText
        .split(',')
        .map((part) => part.trim())
        .where((part) => part.isNotEmpty)
        .toList();

    final storage = Get.find<StorageService>();
    final profile = storage.userProfile;
    final recipientName = _resolveRecipientName(profile);
    final city = _resolveCity(parts);
    final province = _resolveProvince(parts);
    final postalCode = _resolvePostalCode(labelText);

    return {
      'label': parts.isNotEmpty ? 'Home' : 'Pinned Location',
      'recipient_name': recipientName,
      'phone': _resolvePhone(profile),
      'address_line_1': parts.isNotEmpty ? parts.first : 'Selected location',
      'address_line_2': parts.length > 1 ? parts[1] : '',
      'city': city,
      'province': province,
      'postal_code': postalCode,
      'lat': point.latitude,
      'long': point.longitude,
    };
  }

  String _resolveRecipientName(UserProfile? profile) {
    if (profile == null) return 'Fresh Leaf User';
    final value = '${profile.firstName} ${profile.lastName}'.trim();
    return value.isEmpty ? 'Fresh Leaf User' : value;
  }

  String _resolvePhone(UserProfile? profile) {
    final value = profile?.phoneNumber.trim() ?? '';
    if (value.isEmpty) return '0000000000';
    return value;
  }

  String _resolveCity(List<String> parts) {
    if (parts.length >= 3) return parts[parts.length - 3];
    if (parts.length >= 2) return parts[parts.length - 2];
    return 'Phnom Penh';
  }

  String _resolveProvince(List<String> parts) {
    if (parts.length >= 2) return parts[parts.length - 2];
    return 'Phnom Penh';
  }

  String _resolvePostalCode(String value) {
    final match = RegExp(r'\b\d{4,6}\b').firstMatch(value);
    return match?.group(0) ?? '12000';
  }

  List<Map<String, dynamic>> _extractAddressMaps(dynamic data) {
    if (data is List) {
      return data.whereType<Map>().map((e) => e.cast<String, dynamic>()).toList();
    }

    if (data is Map<String, dynamic>) {
      final nested = data['items'] ?? data['addresses'] ?? data['data'];
      if (nested is List) {
        return nested
            .whereType<Map>()
            .map((e) => e.cast<String, dynamic>())
            .toList();
      }
    }

    return const <Map<String, dynamic>>[];
  }
}

class LocationSearchItem {
  const LocationSearchItem({
    required this.displayName,
    required this.point,
  });

  final String displayName;
  final LatLng point;
}


