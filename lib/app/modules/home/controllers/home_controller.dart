import 'dart:async';

import 'package:dio/dio.dart';
import 'package:fresh_leaf/core/models/home_category.dart';
import 'package:fresh_leaf/core/models/home_product.dart';
import 'package:fresh_leaf/core/services/permission_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final Dio _dio = Dio();
  final RxString _searchQuery = ''.obs;
  final RxString locationName = ''.obs;
  final RxString locationRegion = ''.obs;
  final RxBool isResolvingLocation = false.obs;

  String get searchQuery => _searchQuery.value;
  set searchQuery(String value) => _searchQuery.value = value;

  // Mock Data
  final RxList<HomeCategory> categories = <HomeCategory>[
    const HomeCategory(
      icon: HomeCategoryIcon.leaf,
      titleKey: 'home_category_leafy_greens',
    ),
    const HomeCategory(
      icon: HomeCategoryIcon.rootAndTuber,
      titleKey: 'home_category_root_veg',
    ),
    const HomeCategory(
      icon: HomeCategoryIcon.bulmAndStem,
      titleKey: 'home_category_mushrooms',
    ),
    const HomeCategory(
      icon: HomeCategoryIcon.legume,
      titleKey: 'home_category_citrus',
    ),
    const HomeCategory(
      icon: HomeCategoryIcon.indigenousAndWild,
      titleKey: 'home_category_indigenous_and_wild',
    ),
  ].obs;

  final RxList<HomeProduct> pickedThisMorning = <HomeProduct>[
    const HomeProduct(
      image:
          'https://images.unsplash.com/photo-1598170845058-32b9d6a5da37?q=80&w=600',
      title: 'home_product_heritage_carrots_title',
      subtitle: 'home_product_heritage_carrots_subtitle',
      priceText: r'$4.50',
      badge: 'home_product_heritage_carrots_badge',
      description: 'seasonal_pick_description',
      tags: ['organic', 'fresh'],
      origin: 'local_farm',
      harvest: 'harvested_this_week',
      storage: 'refrigerate_extend_freshness',
      shareSlug: 'heritage-carrots',
    ),
    const HomeProduct(
      image:
          'https://images.unsplash.com/photo-1604544025999-4c8d550e0d5a?q=80&w=600',
      title: 'home_product_golden_oysters_title',
      subtitle: 'home_product_golden_oysters_subtitle',
      priceText: r'$8.00',
      badge: 'home_product_golden_oysters_badge',
      description: 'seasonal_pick_description',
      tags: ['organic', 'fresh'],
      origin: 'local_farm',
      harvest: 'harvested_this_week',
      storage: 'refrigerate_extend_freshness',
      shareSlug: 'golden-oysters',
    ),
  ].obs;

  List<HomeProduct> get filteredPickedThisMorning {
    final query = _searchQuery.value.trim().toLowerCase();
    if (query.isEmpty) {
      return pickedThisMorning.toList();
    }

    return pickedThisMorning.where((item) {
      final title = item.title.toLowerCase();
      final subtitle = item.subtitle.toLowerCase();
      final badge = item.badge.toLowerCase();
      return title.contains(query) ||
          subtitle.contains(query) ||
          badge.contains(query);
    }).toList();
  }

  @override
  void onInit() {
    super.onInit();
    unawaited(fetchCurrentLocation());
  }

  Future<void> fetchCurrentLocation() async {
    if (isResolvingLocation.value) {
      return;
    }
    isResolvingLocation.value = true;
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        Get.snackbar('Location', 'Please turn on location service.');
        return;
      }

      final hasPermission = await PermissionService.requestLocation();
      if (!hasPermission) {
        Get.snackbar('Location', 'Location permission is required.');
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
        ),
      );

      final response = await _dio.get<Map<String, dynamic>>(
        'https://nominatim.openstreetmap.org/reverse',
        queryParameters: <String, dynamic>{
          'format': 'jsonv2',
          'lat': position.latitude,
          'lon': position.longitude,
          'zoom': 18,
          'addressdetails': 1,
          'accept-language': (Get.locale?.languageCode == 'km') ? 'km' : 'en',
        },
        options: Options(
          headers: <String, String>{
            'User-Agent': 'FreshLeaf/1.0',
          },
        ),
      );

      final data = response.data;
      final address = data?['address'];
      if (address is Map<String, dynamic>) {
        final primary = _firstNonEmpty(<String?>[
          address['suburb']?.toString(),
          address['village']?.toString(),
          address['town']?.toString(),
          address['city']?.toString(),
          address['municipality']?.toString(),
          address['state_district']?.toString(),
        ]);
        final region = _firstNonEmpty(<String?>[
          address['state']?.toString(),
          address['country']?.toString(),
        ]);

        locationName.value = primary ?? '';
        locationRegion.value = region ?? '';
      }
    } on DioException {
      Get.snackbar('Location', 'Unable to load current location.');
    } on Exception {
      Get.snackbar('Location', 'Unable to detect your current location.');
    } finally {
      isResolvingLocation.value = false;
    }
  }

  String? _firstNonEmpty(List<String?> values) {
    for (final value in values) {
      if (value != null && value.trim().isNotEmpty) {
        return value.trim();
      }
    }
    return null;
  }

  Future<void> refreshHome() async {}
}
