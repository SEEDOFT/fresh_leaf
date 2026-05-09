import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/home/controllers/home_controller.dart';
import 'package:fresh_leaf/app/routes/app_routes.dart';
import 'package:fresh_leaf/core/models/home_product.dart';
import 'package:fresh_leaf/core/models/product_info.dart';
import 'package:fresh_leaf/shared/helpers/product_share_helper.dart';
import 'package:get/get.dart';

class SearchController extends GetxController {
  final textController = TextEditingController();
  final RxString _query = ''.obs;
  final RxString _activeTag = 'All'.obs;

  String get query => _query.value;
  set query(String value) => _query.value = value;

  String get activeTag => _activeTag.value;
  set activeTag(String value) => _activeTag.value = value;

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

  List<HomeProduct> get results {
    final source = _homeController.pickedThisMorning.toList();
    final q = _query.value.trim().toLowerCase();
    final tag = _activeTag.value.toLowerCase();

    return source.where((item) {
      final title = item.title.tr.toLowerCase();
      final subtitle = item.subtitle.tr.toLowerCase();
      final badge = item.badge.tr.toLowerCase();
      final origin = item.origin.tr.toLowerCase();
      final tags = item.tags.map((e) => e.tr.toLowerCase()).join(' ');

      final matchesQuery =
          q.isEmpty ||
          title.contains(q) ||
          subtitle.contains(q) ||
          badge.contains(q) ||
          origin.contains(q) ||
          tags.contains(q);

      final matchesTag =
          tag == 'all' ||
          badge.contains(tag) ||
          origin.contains(tag) ||
          tags.contains(tag);

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

  Future<void> openProduct(HomeProduct item) async {
    final product = ProductInfo(
      id: item.id,
      title: item.title.tr,
      subtitle: item.subtitle.tr,
      description:
          (item.description.isEmpty
                  ? 'seasonal_pick_description'
                  : item.description)
              .tr,
      imageUrl: item.image,
      tags: (item.tags.isEmpty ? ['organic', 'fresh'] : item.tags)
          .map((e) => e.tr)
          .toList(),
      price: item.priceValue,
      origin: (item.origin.isEmpty ? 'local_farm' : item.origin).tr,
      harvest: (item.harvest.isEmpty ? 'harvested_this_week' : item.harvest).tr,
      storage:
          (item.storage.isEmpty ? 'refrigerate_extend_freshness' : item.storage)
              .tr,
      shareSlug: ProductShareHelper.resolveSlug(
        title: item.title.tr,
        shareSlug: item.shareSlug,
      ),
      shareDeepLink: item.shareDeepLink.isEmpty ? null : item.shareDeepLink,
    );
    await Get.toNamed<void>(AppRoutes.productDetail, arguments: product);
  }

  @override
  void onClose() {
    textController.dispose();
    super.onClose();
  }
}
