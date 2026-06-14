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
  final RxString selectedFilter = 'all'.obs;

  final RxString clockWeekday = ''.obs;
  final RxString clockDay = ''.obs;
  final RxString clockOrdinal = ''.obs;
  final RxString clockMonthYear = ''.obs;
  final RxString clockTime = ''.obs;
  Timer? _clockTimer;

  final RxList<ProductCategory> categories = <ProductCategory>[].obs;
  final RxList<VendorInventory> pickedThisMorning = <VendorInventory>[].obs;

  final RxInt currentPage = 1.obs;
  final RxInt lastPage = 1.obs;
  final RxBool isPaginating = false.obs;

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

  List<VendorInventory> get filteredProductsByTab {
    // Note: We now filter on the server,
    // but we keep this helper for local search over the results
    return filteredPickedThisMorning;
  }

  @override
  void onInit() {
    super.onInit();
    _updateClock();
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateClock();
    });

    // Reset pagination and reload when filter changes
    ever(selectedFilter, (_) => loadHomeData());

    unawaited(loadHomeData());
    unawaited(fetchCurrentLocation());
    unawaited(_notificationService.getNotifications());
    unawaited(_notificationService.fetchUnreadChatCount());
  }

  @override
  void onClose() {
    _clockTimer?.cancel();
    super.onClose();
  }

  String _capitalize(String s) => '${s[0].toUpperCase()}${s.substring(1)}';

  void _updateClock() {
    final now = DateTime.now().toLocal();
    const weekdays = [
      'monday',
      'tuesday',
      'wednesday',
      'thursday',
      'friday',
      'saturday',
      'sunday',
    ];
    final months = [
      'january',
      'february',
      'march',
      'april',
      'may',
      'june',
      'july',
      'august',
      'september',
      'october',
      'november',
      'december',
    ];
    final day = now.day;
    final suffix = switch (day) {
      1 || 21 || 31 => 'st',
      2 || 22 => 'nd',
      3 || 23 => 'rd',
      _ => 'th',
    };
    final hour12 = now.hour == 0
        ? 12
        : now.hour > 12
        ? now.hour - 12
        : now.hour;
    final amPm = now.hour < 12 ? 'AM' : 'PM';
    final minute = now.minute.toString().padLeft(2, '0');
    final second = now.second.toString().padLeft(2, '0');
    clockWeekday.value = _capitalize(weekdays[now.weekday - 1]);
    clockDay.value = day.toString();
    clockOrdinal.value = suffix;
    clockMonthYear.value = '${_capitalize(months[now.month - 1])}, ${now.year}';
    clockTime.value = '$hour12:$minute:$second $amPm';
  }

  Future<void> loadHomeData() async {
    isLoadingProducts.value = true;
    currentPage.value = 1;

    try {
      final results = await Future.wait([
        _homeRepository.getCategories(),
        _productService.getProducts(
          perPage: 10,
          filter: selectedFilter.value == 'all' ? null : selectedFilter.value,
        ),
      ]);

      categories.value = results[0] as List<ProductCategory>;

      final paginatedProducts =
          results[1] as PaginatedResponse<VendorInventory>;
      pickedThisMorning.value = paginatedProducts.items;
      currentPage.value = paginatedProducts.currentPage;
      lastPage.value = paginatedProducts.hasMore
          ? paginatedProducts.currentPage + 1
          : paginatedProducts.currentPage;
    } on Exception {
      categories.value = [];
      pickedThisMorning.value = [];
    } finally {
      isLoadingProducts.value = false;
    }
  }

  Future<void> loadMoreProducts() async {
    if (isPaginating.value || currentPage.value >= lastPage.value) return;
    isPaginating.value = true;

    try {
      final nextPage = currentPage.value + 1;
      final response = await _productService.getProducts(
        perPage: 10,
        page: nextPage,
        filter: selectedFilter.value == 'all' ? null : selectedFilter.value,
      );
      pickedThisMorning.addAll(response.items);
      currentPage.value = response.currentPage;
      lastPage.value = response.hasMore
          ? response.currentPage + 1
          : response.currentPage;
    } on Exception {
      // ignore
    } finally {
      isPaginating.value = false;
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
