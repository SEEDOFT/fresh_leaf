import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:fresh_leaf/core/services/permission_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

class ProfileAddressEditController extends GetxController {
  static const LatLng _defaultCenter = LatLng(11.5564, 104.9282);
  static const String _nominatimBaseUrl = 'https://nominatim.openstreetmap.org';

  final MapController mapController = MapController();
  final TextEditingController labelController = TextEditingController();
  final TextEditingController line1Controller = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  final Rx<LatLng> selectedPoint = _defaultCenter.obs;
  final RxString selectedLabel = 'Phnom Penh, Cambodia'.obs;
  final RxBool isReverseLoading = false.obs;
  final RxBool isLocating = false.obs;

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

    final args = Get.arguments;
    if (args is Map) {
      labelController.text = args['label']?.toString() ?? '';
      line1Controller.text = args['line1']?.toString() ?? '';
      phoneController.text = args['phone']?.toString() ?? '';
      selectedLabel.value = args['line1']?.toString() ?? selectedLabel.value;

      final lat = _toDouble(args['latitude']);
      final lng = _toDouble(args['longitude']);
      if (lat != null && lng != null) {
        selectedPoint.value = LatLng(lat, lng);
      }
    }
  }

  @override
  void onReady() {
    super.onReady();
    mapController.move(selectedPoint.value, 15);
  }

  @override
  void onClose() {
    labelController.dispose();
    line1Controller.dispose();
    phoneController.dispose();
    super.onClose();
  }

  Future<void> onMapTap(LatLng point) async {
    selectedPoint.value = point;
    await _reverseGeocode(point);
  }

  Future<void> locateUser() async {
    if (isLocating.value) return;
    isLocating.value = true;

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        Get.snackbar('Location off', 'Please enable location services');
        return;
      }

      final granted = await PermissionService.requestLocation();
      if (!granted) {
        Get.snackbar('Permission required', 'Location permission is needed');
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
      Get.snackbar('Location error', 'Unable to get current location');
    } finally {
      isLocating.value = false;
    }
  }

  void save() {
    final label = labelController.text.trim();
    final line1 = line1Controller.text.trim();

    if (label.isEmpty || line1.isEmpty) {
      Get.snackbar('Missing data', 'Please fill address label and details');
      return;
    }

    final point = selectedPoint.value;

    Get.back(
      result: {
        'label': label,
        'line1': line1,
        'line2': _formatCoords(point),
        'phone': phoneController.text.trim(),
        'latitude': point.latitude,
        'longitude': point.longitude,
      },
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
        line1Controller.text = selectedLabel.value;
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

  double? _toDouble(Object? value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '');
  }
}
