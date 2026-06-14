import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:fresh_leaf/app/routes/app_routes.dart';
import 'package:fresh_leaf/core/services/product_service.dart';
import 'package:get/get.dart';

class DeepLinkService extends GetxService {
  DeepLinkService({required ProductService productService})
    : _productService = productService;

  final ProductService _productService;
  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _sub;

  @override
  void onReady() {
    super.onReady();
    _init();
  }

  void _init() {
    _appLinks.uriLinkStream.listen(_handleLink);
  }

  Future<void> handleInitialLink() async {
    try {
      final uri = await _appLinks.getInitialLink();
      if (uri != null) {
        unawaited(_handleLink(uri));
      }
    } on Exception {
      // Ignore
    }
  }

  Future<void> _handleLink(Uri uri) async {
    if (uri.scheme != 'freshleaf') return;

    final segments = uri.pathSegments;
    if (segments.isEmpty) return;

    switch (segments.first) {
      case 'product':
        if (segments.length < 2) return;
        await _navigateToProduct(segments[1]);
      case 'vendor':
        if (segments.length < 2) return;
        await _navigateToVendor(segments[1]);
    }
  }

  Future<void> _navigateToProduct(String slug) async {
    final products = await _productService.getProductBySlug(slug);
    if (products.isEmpty) {
      Get.snackbar('product_not_found'.tr, 'unable_load_product'.tr);
      return;
    }
    unawaited(
      Get.toNamed<void>(
        AppRoutes.productDetail,
        arguments: products.first,
      ),
    );
  }

  Future<void> _navigateToVendor(String slug) async {
    Get.snackbar(
      'vendor'.tr,
      'vendor_not_found'.tr,
    );
  }

  @override
  void onClose() {
    unawaited(_sub?.cancel());
    super.onClose();
  }
}
