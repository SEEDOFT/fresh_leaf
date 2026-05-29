import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:fresh_leaf/core/constants/api_endpoints.dart';
import 'package:fresh_leaf/core/services/api_client.dart';
import 'package:fresh_leaf/core/services/permission_service.dart';
import 'package:fresh_leaf/shared/helpers/helper.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart' hide Response;
import 'package:latlong2/latlong.dart';

class ProfileAddressEditController extends GetxController {
  static const LatLng _defaultCenter = LatLng(11.5564, 104.9282);
  static const String _nominatimBaseUrl = 'https://nominatim.openstreetmap.org';

  final MapController mapController = MapController();

  final TextEditingController searchController = TextEditingController();
  final TextEditingController labelController = TextEditingController();
  final TextEditingController recipientNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController line1Controller = TextEditingController();
  final TextEditingController line2Controller = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController provinceController = TextEditingController();
  final TextEditingController postalCodeController = TextEditingController();

  final ApiClient _apiClient = Get.find<ApiClient>();
  final Rx<LatLng> selectedPoint = _defaultCenter.obs;
  final RxString selectedLabel = 'default_selected_location'.tr.obs;
  final RxString searchQuery = ''.obs;
  final RxList<LocationSearchItem> searchResults = <LocationSearchItem>[].obs;
  final RxDouble sheetExtent = 0.54.obs;
  final RxBool isReverseLoading = false.obs;
  final RxBool isSearching = false.obs;
  final RxBool isLocating = false.obs;
  final RxBool isSaving = false.obs;
  final RxBool isDeleting = false.obs;

  late final Dio _dio;
  Worker? _searchWorker;
  bool isEditMode = false;
  String addressId = '';

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

    _loadArguments();
    _searchWorker = debounce<String>(
      searchQuery,
      (_) => searchLocation(),
      time: const Duration(milliseconds: 350),
    );
  }

  @override
  void onReady() {
    super.onReady();
    mapController.move(selectedPoint.value, 15);
  }

  @override
  void onClose() {
    _searchWorker?.dispose();
    searchController.dispose();
    labelController.dispose();
    recipientNameController.dispose();
    phoneController.dispose();
    line1Controller.dispose();
    line2Controller.dispose();
    cityController.dispose();
    provinceController.dispose();
    postalCodeController.dispose();
    super.onClose();
  }

  void _loadArguments() {
    final args = Get.arguments;
    if (args is! Map<String, dynamic>) {
      _applyDefaults();
      return;
    }

    final map = args;
    isEditMode = map['mode']?.toString() == 'edit';
    addressId = map['id']?.toString() ?? '';

    labelController.text = _resolve(
      map,
      'label',
      fallback: 'address_label_home'.tr,
    );
    recipientNameController.text = _resolve(map, 'recipient_name');
    phoneController.text = _resolve(map, 'phone');
    line1Controller.text = _resolve(map, 'address_line_1', alias: 'line1');
    line2Controller.text = _resolve(map, 'address_line_2', alias: 'line2');
    cityController.text = _resolve(map, 'city');
    provinceController.text = _resolve(map, 'province');
    postalCodeController.text = _resolve(map, 'postal_code');

    final lat = _toDouble(map['lat'] ?? map['latitude']);
    final lng = _toDouble(map['long'] ?? map['longitude']);
    if (lat != null && lng != null) {
      selectedPoint.value = LatLng(lat, lng);
    }

    final readable = line1Controller.text.trim();
    if (readable.isNotEmpty) {
      selectedLabel.value = readable;
    }

    _applyDefaults();
  }

  String _resolve(
    Map<String, dynamic> map,
    String key, {
    String alias = '',
    String fallback = '',
  }) {
    final first = map[key]?.toString().trim() ?? '';
    if (first.isNotEmpty) return first;
    if (alias.isNotEmpty) {
      final second = map[alias]?.toString().trim() ?? '';
      if (second.isNotEmpty) return second;
    }
    return fallback;
  }

  void _applyDefaults() {
    if (labelController.text.trim().isEmpty) {
      labelController.text = 'address_label_home'.tr;
    }
  }

  Future<void> onMapTap(LatLng point) async {
    selectedPoint.value = point;
    clearSearchResults();
    await _reverseGeocode(point);
  }

  void onSearchChanged(String value) {
    searchQuery.value = value.trim();
  }

  Future<void> searchLocation() async {
    final query = searchQuery.value;
    if (query.isEmpty) {
      searchResults.clear();
      return;
    }

    isSearching.value = true;
    try {
      final response = await _dio.get<dynamic>(
        '$_nominatimBaseUrl/search',
        queryParameters: {
          'q': query,
          'format': 'jsonv2',
          'addressdetails': 1,
          'limit': 8,
          'accept-language': _nominatimLanguage(),
        },
      );

      final data = response.data;
      if (data is List) {
        final parsed = data
            .whereType<Map<String, dynamic>>()
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
    } on DioException {
      searchResults.clear();
      Get.snackbar('search_failed'.tr, 'unable_search_location'.tr);
    } finally {
      isSearching.value = false;
    }
  }

  Future<void> pickSearchResult(LocationSearchItem item) async {
    selectedPoint.value = item.point;
    selectedLabel.value = item.displayName;
    searchController.text = item.displayName;
    searchQuery.value = item.displayName;
    searchResults.clear();
    mapController.move(item.point, 16);
    await _reverseGeocode(item.point);
  }

  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';
    clearSearchResults();
  }

  void clearSearchResults() {
    searchResults.clear();
  }

  // ignore: use_setters_to_change_properties, document why: used as callback setter from sheet extent
  void onSheetExtentChanged(double extent) {
    sheetExtent.value = extent;
  }

  Future<void> locateUser() async {
    if (isLocating.value) return;
    isLocating.value = true;

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        Get.snackbar('location_off'.tr, 'enable_location_services'.tr);
        return;
      }

      final granted = await PermissionService.requestLocation();
      if (!granted) {
        Get.snackbar(
          'permission_required'.tr,
          'location_permission_needed'.tr,
        );
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );

      final point = LatLng(position.latitude, position.longitude);
      selectedPoint.value = point;
      mapController.move(point, 16);
      await _reverseGeocode(point);
    } on Exception {
      Get.snackbar('location_error'.tr, 'unable_get_current_location'.tr);
    } finally {
      isLocating.value = false;
    }
  }

  Future<void> save() async {
    if (isSaving.value) return;
    FocusManager.instance.primaryFocus?.unfocus();

    final validationMessage = _validate();
    if (validationMessage != null) {
      Get.snackbar('missing_data'.tr, validationMessage);
      return;
    }

    isSaving.value = true;
    try {
      final payload = _buildPayload();

      final response = isEditMode && addressId.isNotEmpty
          ? await _updateAddress(payload)
          : await _apiClient.postRequest(
              ApiEndpoints.addresses,
              data: payload,
            );

      final statusCode = response.statusCode ?? 0;
      final isHttpSuccess = statusCode == 200 || statusCode == 201;
      if (!isHttpSuccess) {
        Get.snackbar('save_failed'.tr, 'unable_save_address'.tr);
        return;
      }

      var successMessage = isEditMode
          ? 'address_updated_success'.tr
          : 'address_created_success'.tr;

      final body = response.data;
      if (body is Map<String, dynamic>) {
        final status = body['status'];
        if (status is Map<String, dynamic>) {
          final message = status['message']?.toString().trim() ?? '';
          if (message.isNotEmpty) {
            successMessage = message;
          }
        }
      }

      Get.back<bool?>(result: true);
      unawaited(
        Future<void>.microtask(
          () => Get.snackbar('success'.tr, successMessage),
        ),
      );
    } on DioException catch (e) {
      Get.snackbar(
        'save_failed'.tr,
        parseApiErrorMessage(
          e,
          fallback: 'unable_save_address'.tr,
        ),
      );
    } on Exception {
      Get.snackbar('save_failed'.tr, 'unable_save_address'.tr);
    } finally {
      isSaving.value = false;
    }
  }

  Future<Response<dynamic>> _updateAddress(Map<String, dynamic> payload) async {
    final path = ApiEndpoints.address.replaceFirst('{id}', addressId);
    try {
      return await _apiClient.putRequest(path, data: payload);
    } on DioException catch (e) {
      final code = e.response?.statusCode ?? 0;
      if (code == 404 || code == 405) {
        return _apiClient.patchRequest(path, data: payload);
      }
      rethrow;
    }
  }

  Future<void> deleteAddress() async {
    if (!isEditMode || addressId.isEmpty || isDeleting.value) return;

    final confirmed =
        await Get.dialog<bool>(
          AlertDialog(
            title: Text('delete_address_title'.tr),
            content: Text('delete_address_body'.tr),
            actions: [
              TextButton(
                onPressed: () => Get.back(result: false),
                child: Text('cancel'.tr),
              ),
              FilledButton(
                onPressed: () => Get.back(result: true),
                style: FilledButton.styleFrom(
                  backgroundColor: Get.theme.colorScheme.error,
                ),
                child: Text('delete'.tr),
              ),
            ],
          ),
        ) ??
        false;

    if (!confirmed) return;

    isDeleting.value = true;
    try {
      final path = ApiEndpoints.address.replaceFirst('{id}', addressId);
      final response = await _apiClient.deleteRequest(path);
      final statusCode = response.statusCode ?? 0;

      if (statusCode != 200 && statusCode != 204) {
        Get.snackbar('delete_failed'.tr, 'unable_delete_address'.tr);
        return;
      }

      var message = 'deleted'.tr;
      final body = response.data;
      if (body is Map<String, dynamic>) {
        final status = body['status'];
        if (status is Map<String, dynamic>) {
          final fromApi = status['message']?.toString() ?? '';
          if (fromApi.isNotEmpty) {
            message = fromApi;
          }
        }
      }

      Get
        ..snackbar('deleted'.tr, message)
        ..back<bool?>(result: true);
    } on DioException catch (e) {
      Get.snackbar(
        'delete_failed'.tr,
        parseApiErrorMessage(
          e,
          fallback: 'unable_delete_address'.tr,
        ),
      );
    } on Exception {
      Get.snackbar('delete_failed'.tr, 'unable_delete_address'.tr);
    } finally {
      isDeleting.value = false;
    }
  }

  Map<String, dynamic> _buildPayload() {
    final point = selectedPoint.value;
    return {
      'label': labelController.text.trim(),
      'recipient_name': recipientNameController.text.trim(),
      'phone': _sanitizePhone(phoneController.text),
      'address_line_1': line1Controller.text.trim(),
      'address_line_2': line2Controller.text.trim(),
      'city': cityController.text.trim(),
      'province': provinceController.text.trim(),
      'postal_code': postalCodeController.text.trim(),
      'lat': point.latitude,
      'long': point.longitude,
    };
  }

  String? _validate() {
    if (labelController.text.trim().isEmpty) {
      return 'enter_label'.tr;
    }
    if (recipientNameController.text.trim().isEmpty) {
      return 'enter_recipient_name'.tr;
    }
    if (_sanitizePhone(phoneController.text).isEmpty) {
      return 'enter_valid_phone'.tr;
    }
    if (line1Controller.text.trim().isEmpty) {
      return 'enter_address_line_1'.tr;
    }
    if (cityController.text.trim().isEmpty) {
      return 'enter_city'.tr;
    }
    if (provinceController.text.trim().isEmpty) {
      return 'enter_province'.tr;
    }
    if (postalCodeController.text.trim().isEmpty) {
      return 'enter_postal_code'.tr;
    }
    return null;
  }

  String _sanitizePhone(String value) {
    final normalized = value.trim().replaceAll(RegExp('[^0-9+]'), '');
    if (normalized.startsWith('+')) {
      return '+${normalized.substring(1).replaceAll(RegExp('[^0-9]'), '')}';
    }
    return normalized.replaceAll(RegExp('[^0-9]'), '');
  }

  Future<void> _reverseGeocode(LatLng point) async {
    isReverseLoading.value = true;
    try {
      final response = await _dio.get<dynamic>(
        '$_nominatimBaseUrl/reverse',
        queryParameters: {
          'lat': point.latitude,
          'lon': point.longitude,
          'format': 'jsonv2',
          'addressdetails': 1,
          'accept-language': _nominatimLanguage(),
        },
      );

      final data = response.data;
      if (data is Map<String, dynamic>) {
        final displayName =
            data['display_name']?.toString() ?? _formatCoords(point);
        selectedLabel.value = displayName;

        final address = data['address'];
        if (address is Map<String, dynamic>) {
          final line1 = _buildLine1(address, displayName);
          line1Controller.text = line1;
          line2Controller.text = _buildLine2(address);
          cityController.text = _resolveCity(address);
          provinceController.text = _resolveProvince(address);
          postalCodeController.text = address['postcode']?.toString() ?? '';
        } else {
          line1Controller.text = displayName;
        }
      } else {
        selectedLabel.value = _formatCoords(point);
      }
    } on Exception {
      selectedLabel.value = _formatCoords(point);
    } finally {
      isReverseLoading.value = false;
    }
  }

  String _buildLine1(Map<String, dynamic> address, String fallback) {
    final house = address['house_number']?.toString() ?? '';
    final road =
        address['road']?.toString() ??
        address['street']?.toString() ??
        address['pedestrian']?.toString() ??
        '';
    final joined = [
      house,
      road,
    ].where((value) => value.trim().isNotEmpty).join(' ').trim();
    if (joined.isNotEmpty) return joined;
    final firstPart = fallback.split(',').first.trim();
    return firstPart.isEmpty ? fallback : firstPart;
  }

  String _buildLine2(Map<String, dynamic> address) {
    final values = [
      address['suburb']?.toString() ?? '',
      address['neighbourhood']?.toString() ?? '',
      address['quarter']?.toString() ?? '',
    ].where((value) => value.trim().isNotEmpty).toList();
    return values.join(', ');
  }

  String _resolveCity(Map<String, dynamic> address) {
    return address['city']?.toString() ??
        address['town']?.toString() ??
        address['municipality']?.toString() ??
        address['county']?.toString() ??
        '';
  }

  String _resolveProvince(Map<String, dynamic> address) {
    return address['state']?.toString() ??
        address['province']?.toString() ??
        address['region']?.toString() ??
        '';
  }

  String _formatCoords(LatLng point) {
    final latText = point.latitude.toStringAsFixed(5);
    final lonText = point.longitude.toStringAsFixed(5);
    return '$latText, $lonText';
  }

  double? _toDouble(Object? value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '');
  }

  String _nominatimLanguage() {
    return Get.locale?.languageCode == 'km' ? 'km' : 'en';
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
