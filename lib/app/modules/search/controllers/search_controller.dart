import 'dart:async';
import 'package:flutter/material.dart' hide SearchController;
import 'package:fresh_leaf/app/modules/home/controllers/home_controller.dart';
import 'package:fresh_leaf/app/routes/app_routes.dart';
import 'package:fresh_leaf/core/models/product_category.dart';
import 'package:fresh_leaf/core/models/vendor_inventory.dart';
import 'package:fresh_leaf/core/services/product_service.dart';
import 'package:get/get.dart';

class SearchController extends GetxController {
  SearchController({
    required HomeController homeController,
    required ProductService productService,
  }) : _homeController = homeController,
       _productService = productService;

  final textController = TextEditingController();
  final RxString _query = ''.obs;
  final RxString _activeTag = 'All'.obs;
  final RxString selectedProvince = 'All'.obs;
  final RxnInt selectedCategoryId = RxnInt();

  final RxList<VendorInventory> results = <VendorInventory>[].obs;
  final RxBool _isLoading = false.obs;
  Timer? _debounce;

  String get query => _query.value;
  set query(String value) {
    _query.value = value;
    _debouncedSearch();
  }

  String get activeTag => _activeTag.value;
  set activeTag(String value) {
    _activeTag.value = value;
    unawaited(_performSearch());
  }

  bool get isLoading => _isLoading.value;

  final quickTags = const <String>[
    'All',
    'Organic',
    'Fresh',
    'Limited',
    'Local',
  ];

  final HomeController _homeController;
  final ProductService _productService;

  List<ProductCategory> get categories => _homeController.categories;

  @override
  Future<void> onInit() async {
    super.onInit();
    final args = Get.arguments;
    if (args is int) {
      selectedCategoryId.value = args;
    }

    ever(selectedProvince, (_) => _performSearch());
    ever(selectedCategoryId, (_) => _performSearch());

    await _performSearch();
  }

  void _debouncedSearch() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), _performSearch);
  }

  Future<void> _performSearch() async {
    _isLoading.value = true;
    try {
      final searchStr = _query.value.trim().isEmpty
          ? null
          : _query.value.trim();
      final prov = selectedProvince.value == 'All'
          ? null
          : selectedProvince.value;
      final catId = selectedCategoryId.value;

      final response = await _productService.getProducts(
        query: searchStr,
        province: prov,
        categoryId: catId,
        perPage: 50,
      );

      final items = response.items;

      if (_activeTag.value != 'All') {
        final tag = _activeTag.value.toLowerCase();
        results.value = items.where((item) {
          final badge = item.certificationType?.tr.toLowerCase() ?? '';
          return badge.contains(tag);
        }).toList();
      } else {
        results.value = items;
      }
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> refreshData() async {
    await _performSearch();
  }

  String displayLabelForTag(String value) {
    switch (value) {
      case 'Organic':
        return 'tag_organic'.tr;
      case 'Fresh':
        return 'tag_fresh'.tr;
      case 'Limited':
        return 'tag_limited'.tr;
      case 'Local':
        return 'tag_local'.tr;
      default:
        return 'tag_all'.tr;
    }
  }

  Future<void> clearQuery() async {
    textController.clear();
    _query.value = '';
    await _performSearch();
  }

  Future<void> openProduct(VendorInventory item) async {
    await Get.toNamed<void>(AppRoutes.productDetail, arguments: item);
  }

  @override
  void onClose() {
    _debounce?.cancel();
    textController.dispose();
    super.onClose();
  }
}
