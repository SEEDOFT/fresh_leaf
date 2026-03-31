import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/home/controllers/home_controller.dart';
import 'package:fresh_leaf/app/modules/product_detail/models/product_info.dart';
import 'package:fresh_leaf/app/routes/app_routes.dart';
import 'package:get/get.dart';

class SearchController extends GetxController {
  final textController = TextEditingController();
  final query = ''.obs;
  final activeTag = 'All'.obs;

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

  List<Map<String, dynamic>> get results {
    final source = _homeController.pickedThisMorning.cast<Map<String, dynamic>>();
    final q = query.value.trim().toLowerCase();
    final tag = activeTag.value.toLowerCase();

    return source.where((item) {
      final title = (item['title'] ?? '').toString().tr.toLowerCase();
      final subtitle = (item['subtitle'] ?? '').toString().tr.toLowerCase();
      final badge = (item['badge'] ?? '').toString().tr.toLowerCase();
      final origin = (item['origin'] ?? '').toString().tr.toLowerCase();
      final tags = (item['tags'] is List)
          ? (item['tags'] as List)
                .map((e) => e.toString().tr.toLowerCase())
                .join(' ')
          : '';

      final matchesQuery = q.isEmpty ||
          title.contains(q) ||
          subtitle.contains(q) ||
          badge.contains(q) ||
          origin.contains(q) ||
          tags.contains(q);

      final matchesTag = tag == 'all' ||
          badge.contains(tag) ||
          origin.contains(tag) ||
          tags.contains(tag);

      return matchesQuery && matchesTag;
    }).toList();
  }

  void updateQuery(String value) {
    query.value = value;
  }

  void changeTag(String value) {
    activeTag.value = value;
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
    query.value = '';
  }

  void openProduct(Map<String, dynamic> item) {
    final product = ProductInfo(
      title: item['title']?.toString() ?? '',
      subtitle: item['subtitle']?.toString() ?? '',
      description: item['description']?.toString() ??
          'seasonal_pick_description'.tr,
      imageUrl: item['image']?.toString() ?? '',
      tags: List<String>.from(item['tags'] ?? ['organic'.tr, 'fresh'.tr]),
      price: _parsePrice(item['price']),
      origin: item['origin']?.toString() ?? 'local_farm'.tr,
      harvest: item['harvest']?.toString() ?? 'harvested_this_week'.tr,
      storage:
          item['storage']?.toString() ?? 'refrigerate_extend_freshness'.tr,
    );
    Get.toNamed(AppRoutes.productDetail, arguments: product);
  }

  double _parsePrice(dynamic price) {
    if (price is num) return price.toDouble();
    if (price is String) {
      final cleaned = price.replaceAll(RegExp(r'[^0-9\\.]'), '');
      return double.tryParse(cleaned) ?? 0.0;
    }
    return 0.0;
  }

  @override
  void onClose() {
    textController.dispose();
    super.onClose();
  }
}
