import 'dart:async';

import 'package:fresh_leaf/app/modules/cart/controllers/cart_controller.dart';
import 'package:fresh_leaf/core/controllers/wishlist_controller.dart';
import 'package:fresh_leaf/core/models/money_display.dart';
import 'package:fresh_leaf/core/models/vendor_inventory.dart';
import 'package:fresh_leaf/core/models/vendor_inventory_rating.dart';
import 'package:fresh_leaf/core/services/product_service.dart';
import 'package:fresh_leaf/core/services/rating_service.dart';
import 'package:fresh_leaf/shared/helpers/product_share_helper.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

class ProductDetailController extends GetxController {
  ProductDetailController({
    required this.wishlistController,
    required ProductService productService,
    required CartController cartController,
    required RatingService ratingService,
  }) : _productService = productService,
       _cartController = cartController,
       _ratingService = ratingService;

  VendorInventory? product;
  final WishlistController wishlistController;
  final ProductService _productService;
  final CartController _cartController;
  final RatingService _ratingService;

  final RxDouble quantity = 1.0.obs;
  final RxBool isLoading = true.obs;
  final RxDouble averageRating = 0.0.obs;
  final RxInt ratingsCount = 0.obs;
  final RxList<VendorInventoryRating> ratings = <VendorInventoryRating>[].obs;
  final RxBool isLoadingRatings = false.obs;
  final RxBool hasMoreRatings = true.obs;

  String get title => product?.displayTitle ?? '';
  String get subtitle => product?.displaySubtitle ?? '';
  String get description => product?.displayDescription ?? '';
  String get imageUrl => product?.displayImageUrl ?? '';
  List<String> get allImages {
    if (product == null) return [''];
    final images = <String>[];
    if (product!.product?.imageUrl != null &&
        product!.product!.imageUrl!.isNotEmpty) {
      images.add(product!.product!.imageUrl!);
    }
    if (product!.batchImages != null && product!.batchImages!.isNotEmpty) {
      images.addAll(product!.batchImages!);
    }
    if (images.isEmpty) {
      images.add('');
    }
    return images.where((url) => url.trim().isNotEmpty).toSet().toList();
  }

  List<String> get tags =>
      product?.certificationType != null ? [product!.certificationType!] : [];
  double get price {
    if (product == null) return 0;
    final usd = product!.resolvedFinalPriceDisplay.usd;
    return usd > 0 ? usd : product!.finalPrice;
  }

  double get originalPrice {
    if (product == null) return 0;
    final usd = product!.resolvedPriceDisplay.usd;
    return usd > 0 ? usd : product!.price;
  }

  double get discountPercentage => product?.discountPercentage ?? 0;
  bool get hasDiscount => discountPercentage > 0;
  String get origin => product?.provinceOfOrigin ?? '';
  String get harvest =>
      product?.harvestDateHuman ??
      product?.harvestDate?.toIso8601String() ??
      '';
  String get storage => '';

  double get total => price * quantity.value;
  MoneyDisplay get totalDisplay {
    if (product == null) return MoneyDisplay.empty;
    return product!.resolvedFinalPriceDisplay.multiply(quantity.value);
  }

  MoneyDisplay get originalTotalDisplay {
    if (product == null) return MoneyDisplay.empty;
    return product!.resolvedPriceDisplay.multiply(quantity.value);
  }

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is VendorInventory) {
      product = args;
    } else if (args is Map<String, dynamic>) {
      product = VendorInventory.fromMap(args);
    }
    unawaited(_preloadProduct());
  }

  Future<void> _preloadProduct() async {
    final id = product?.id;
    if (id == null || id == 0) {
      isLoading.value = false;
      update();
      return;
    }

    isLoading.value = true;
    update();
    try {
      final updated = await _productService.getProduct(id);
      if (updated != null) {
        product = updated;
        averageRating.value = updated.averageRating;
        ratingsCount.value = updated.ratingsCount;
      }
      unawaited(loadRatings());
    } on Exception {
      // Keep existing product if API fails
    } finally {
      isLoading.value = false;
      update();
    }
  }

  Future<void> loadRatings() async {
    final id = product?.id;
    if (id == null || id == 0 || !hasMoreRatings.value) return;

    isLoadingRatings.value = true;
    try {
      final page = (ratings.length ~/ 15) + 1;
      final result = await _ratingService.getRatings(id, page: page);
      if (result.ratings.items.isNotEmpty) {
        ratings.addAll(result.ratings.items);
      }
      hasMoreRatings.value = result.ratings.nextPageUrl != null;
      averageRating.value = result.averageRating;
      ratingsCount.value = result.ratingsCount;
    } on Exception {
      // Keep existing state on failure
    } finally {
      isLoadingRatings.value = false;
      update();
    }
  }

  void increment() => quantity.value++;

  void decrement() {
    if (quantity.value > 1) quantity.value--;
  }

  void updateQuantity(double newQuantity) {
    if (newQuantity > 0) {
      quantity.value = newQuantity;
    }
  }

  bool get allowDecimal {
    final symbol = product?.unitSymbol?.toLowerCase() ?? '';
    if (['kg', 'piece', 'unit', 'bundle', 'pcs', 'pc'].contains(symbol)) {
      return false;
    }
    return true; // allow for gram, etc.
  }

  Future<void> toggleWishlist() async {
    if (product == null) return;
    await wishlistController.toggleWishlist(product!);
  }

  bool get isFavorite =>
      product != null && wishlistController.isFavorite(product!.id);

  void addToCart() {
    if (product == null) return;
    unawaited(_cartController.addToCart(product!.id, quantity.value));

    Get.snackbar(
      'added_to_cart'.tr,
      'added_to_cart_message'.trParams({'title': title.tr}),
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 1),
    );
  }

  Future<void> shareProduct() async {
    if (product == null) return;
    try {
      final resolvedTitle = title.tr;
      final resolvedDescription = ProductShareHelper.trimDescription(
        description.tr,
      );
      final deepLink = ProductShareHelper.resolveDeepLink(
        title: resolvedTitle,
        shareSlug: product!.product?.slug,
      );
      final message = 'share_product_message_template'.trParams({
        'title': resolvedTitle,
        'price': product!.resolvedFinalPriceDisplay.combinedText,
        'description': resolvedDescription,
        'link': deepLink,
      });
      await SharePlus.instance.share(
        ShareParams(
          text: message,
          subject: resolvedTitle,
        ),
      );
    } on Exception {
      Get.snackbar(
        'share_product'.tr,
        'unable_share_product'.tr,
      );
    }
  }
}
