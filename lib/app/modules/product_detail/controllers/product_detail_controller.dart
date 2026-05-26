import 'dart:async';
import 'package:fresh_leaf/app/modules/cart/controllers/cart_controller.dart';
import 'package:fresh_leaf/core/controllers/wishlist_controller.dart';
import 'package:fresh_leaf/core/models/money_display.dart';
import 'package:fresh_leaf/core/models/vendor_inventory.dart';
import 'package:fresh_leaf/shared/helpers/product_share_helper.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

class ProductDetailController extends GetxController {
  late final VendorInventory product;
  final WishlistController wishlistController = Get.find<WishlistController>();

  final RxDouble quantity = 1.0.obs;

  String get title => product.displayTitle;
  String get subtitle => product.displaySubtitle;
  String get description => product.displayDescription;
  String get imageUrl => product.displayImageUrl;
  List<String> get allImages {
    final images = <String>[];
    if (product.product?.imageUrl != null &&
        product.product!.imageUrl!.isNotEmpty) {
      images.add(product.product!.imageUrl!);
    }
    if (product.batchImages != null && product.batchImages!.isNotEmpty) {
      images.addAll(product.batchImages!);
    }
    if (images.isEmpty) {
      images.add('');
    }
    return images.toSet().toList();
  }

  List<String> get tags =>
      product.certificationType != null ? [product.certificationType!] : [];
  double get price {
    final usd = product.resolvedFinalPriceDisplay.usd;
    return usd > 0 ? usd : product.finalPrice;
  }

  double get originalPrice {
    final usd = product.resolvedPriceDisplay.usd;
    return usd > 0 ? usd : product.price;
  }

  double get discountPercentage => product.discountPercentage;
  bool get hasDiscount => discountPercentage > 0;
  String get origin => product.provinceOfOrigin ?? '';
  String get harvest =>
      product.harvestDateHuman ?? product.harvestDate?.toIso8601String() ?? '';
  String get storage => '';

  double get total => price * quantity.value;
  MoneyDisplay get totalDisplay {
    return product.resolvedFinalPriceDisplay.multiply(quantity.value);
  }

  MoneyDisplay get originalTotalDisplay {
    return product.resolvedPriceDisplay.multiply(quantity.value);
  }

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    product = args is VendorInventory
        ? args
        : VendorInventory.fromMap(args as Map<String, dynamic>? ?? {});
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
    final symbol = product.unitSymbol?.toLowerCase() ?? '';
    if (['kg', 'piece', 'unit', 'bundle', 'pcs', 'pc'].contains(symbol)) {
      return false;
    }
    return true; // allow for gram, etc.
  }

  Future<void> toggleWishlist() async {
    await wishlistController.toggleWishlist(product);
  }

  bool get isFavorite => wishlistController.isFavorite(product.id);

  void addToCart() {
    if (!Get.isRegistered<CartController>()) {
      Get.snackbar('unavailable'.tr, 'cart_not_ready'.tr);
      return;
    }

    final cart = Get.find<CartController>();
    unawaited(cart.addToCart(product.id, quantity.value));

    Get.snackbar(
      'added_to_cart'.tr,
      'added_to_cart_message'.trParams({'title': title.tr}),
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Future<void> shareProduct() async {
    try {
      final resolvedTitle = title.tr;
      final resolvedDescription = ProductShareHelper.trimDescription(
        description.tr,
      );
      final deepLink = ProductShareHelper.resolveDeepLink(
        title: resolvedTitle,
        shareSlug: product.product?.slug,
      );
      final message = 'share_product_message_template'.trParams({
        'title': resolvedTitle,
        'price': product.resolvedFinalPriceDisplay.combinedText,
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
