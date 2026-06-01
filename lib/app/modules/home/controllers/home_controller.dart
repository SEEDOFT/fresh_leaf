import 'dart:async';

import 'package:dio/dio.dart' as dio;
import 'package:fresh_leaf/core/models/paginated_response.dart';
import 'package:fresh_leaf/core/models/product_category.dart';
import 'package:fresh_leaf/core/models/vendor_inventory.dart';
import 'package:fresh_leaf/core/repositories/home_repository.dart';
import 'package:fresh_leaf/core/repositories/location_repository.dart';
import 'package:fresh_leaf/core/services/notification_service.dart';
import 'package:fresh_leaf/core/services/permission_service.dart';
import 'package:fresh_leaf/core/services/product_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  HomeController({
    required ProductService productService,
    required NotificationService notificationService,
    required HomeRepository homeRepository,
    required LocationRepository locationRepository,
  }) : _productService = productService,
       _notificationService = notificationService,
       _homeRepository = homeRepository,
       _locationRepository = locationRepository;

  final HomeRepository _homeRepository;
  final LocationRepository _locationRepository;
  final ProductService _productService;
  final NotificationService _notificationService;

  final RxString _searchQuery = ''.obs;
  final RxString locationName = ''.obs;
  final RxString locationRegion = ''.obs;
  final RxBool isResolvingLocation = false.obs;
  final RxBool isLoadingProducts = false.obs;

  final RxList<ProductCategory> categories = <ProductCategory>[].obs;
  final RxList<VendorInventory> pickedThisMorning = <VendorInventory>[].obs;

  String get searchQuery => _searchQuery.value;
  set searchQuery(String value) => _searchQuery.value = value;

  List<VendorInventory> get filteredPickedThisMorning {
    final query = _searchQuery.value.trim().toLowerCase();
    if (query.isEmpty) {
      return pickedThisMorning.toList();
    }

    return pickedThisMorning.where((item) {
      final title = item.displayTitle.toLowerCase();
      final subtitle = item.displaySubtitle.toLowerCase();
      final badge = item.certificationType?.toLowerCase() ?? '';
      return title.contains(query) ||
          subtitle.contains(query) ||
          badge.contains(query);
    }).toList();
  }

  @override
  void onInit() {
    super.onInit();
    unawaited(loadHomeData());
    unawaited(fetchCurrentLocation());
    unawaited(_notificationService.getNotifications());
  }

  Future<void> loadHomeData() async {
    isLoadingProducts.value = true;

    try {
      final results = await Future.wait([
        _homeRepository.getCategories(),
        _productService.getProducts(perPage: 10),
      ]);

      categories.value = results[0] as List<ProductCategory>;
      pickedThisMorning.value =
          (results[1] as PaginatedResponse<VendorInventory>).items;
    } on Exception {
      categories.value = [];
      pickedThisMorning.value = [];
    } finally {
      isLoadingProducts.value = false;
    }
  }

  Future<void> fetchCurrentLocation() async {
    if (isResolvingLocation.value) {
      return;
    }
    isResolvingLocation.value = true;
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        Get.snackbar('location'.tr, 'enable_location_service'.tr);
        return;
      }

      final hasPermission = await PermissionService.requestLocation();
      if (!hasPermission) {
        Get.snackbar('location'.tr, 'location_permission_required'.tr);
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 10),
        ),
      );

      final languageCode = Get.locale?.languageCode ?? 'en';
      final result = await _locationRepository.reverseGeocode(
        position.latitude,
        position.longitude,
        language: languageCode,
      );

      if (result.hasLocation) {
        locationName.value = result.name ?? '';
        locationRegion.value = result.region ?? '';
      }
    } on dio.DioException {
      Get.snackbar('location'.tr, 'unable_load_current_location'.tr);
    } on Exception {
      Get.snackbar('location'.tr, 'unable_detect_current_location'.tr);
    } finally {
      isResolvingLocation.value = false;
    }
  }

  Future<void> refreshHome() async {
    await loadHomeData();
  }
}
