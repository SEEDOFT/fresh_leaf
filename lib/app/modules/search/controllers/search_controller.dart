import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/home/controllers/home_controller.dart';
import 'package:fresh_leaf/app/routes/app_routes.dart';
import 'package:fresh_leaf/core/models/vendor_inventory.dart';
import 'package:get/get.dart';

class SearchController extends GetxController {
  final textController = TextEditingController();
  final RxString _query = ''.obs;
  final RxString _activeTag = 'All'.obs;

  String get query => _query.value;
  set query(String value) => _query.value = value;

  String get activeTag => _activeTag.value;
  set activeTag(String value) => _activeTag.value = value;

  bool get isLoading => _homeController.isLoadingProducts.value;

  final quickTags = const <String>[
    'All',
    'Organic',
    'Fresh',
    'Limited',
    'Local',
  ];

  late final HomeController _homeController;

  @override
  void onInit() {
    super.onInit();
    _homeController = Get.find<HomeController>();
  }

  List<VendorInventory> get results {
    final source = _homeController.pickedThisMorning.toList();
    final q = _query.value.trim().toLowerCase();
    final tag = _activeTag.value.toLowerCase();

    return source.where((item) {
      final title = item.displayTitle.tr.toLowerCase();
      final subtitle = item.displaySubtitle.tr.toLowerCase();
      final badge = item.certificationType?.tr.toLowerCase() ?? '';
      final origin = item.provinceOfOrigin?.tr.toLowerCase() ?? '';

      final matchesQuery =
          q.isEmpty ||
          title.contains(q) ||
          subtitle.contains(q) ||
          badge.contains(q) ||
          origin.contains(q);

      final matchesTag =
          tag == 'all' || badge.contains(tag) || origin.contains(tag);

      return matchesQuery && matchesTag;
    }).toList();
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

  void clearQuery() {
    textController.clear();
    _query.value = '';
  }

  Future<void> openProduct(VendorInventory item) async {
    await Get.toNamed<void>(AppRoutes.productDetail, arguments: item);
  }

  @override
  void onClose() {
    textController.dispose();
    super.onClose();
  }
}
