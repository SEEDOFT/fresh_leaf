import 'package:fresh_leaf/app/modules/cart/controllers/cart_controller.dart';
import 'package:fresh_leaf/core/models/product_info.dart';
import 'package:fresh_leaf/shared/helpers/product_share_helper.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

class ProductDetailController extends GetxController {
  late final ProductInfo product;

  final RxInt quantity = 1.obs;

  String get title => product.title;
  String get subtitle => product.subtitle;
  String get description => product.description;
  String get imageUrl => product.imageUrl;
  List<String> get tags => product.tags;
  double get price => product.price;
  String get origin => product.origin;
  String get harvest => product.harvest;
  String get storage => product.storage;

  double get total => price * quantity.value;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    product = args is ProductInfo
        ? args
        : ProductInfo.fromMap(args as Map<String, dynamic>? ?? {});
  }

  void increment() => quantity.value++;

  void decrement() {
    if (quantity.value > 1) quantity.value--;
  }

  void addToCart() {
    if (!Get.isRegistered<CartController>()) {
      Get.snackbar('unavailable'.tr, 'cart_not_ready'.tr);
      return;
    }

    final cart = Get.find<CartController>()
      ..addOrIncrementItem(
        title: product.title,
        subtitle: product.subtitle,
        imageUrl: product.imageUrl,
        price: product.price,
        originalPrice: product.originalPrice,
        priceKhr: product.priceKhr,
      );

    // Quantity logic is handled inside addOrIncrementItem for simplicity
    // but usually you would loop or add a quantity param.
    // For this app, let's just add the requested amount.
    if (quantity.value > 1) {
      for (var i = 1; i < quantity.value; i++) {
        cart.addOrIncrementItem(
          title: product.title,
          subtitle: product.subtitle,
          imageUrl: product.imageUrl,
          price: product.price,
          originalPrice: product.originalPrice,
          priceKhr: product.priceKhr,
        );
      }
    }

    Get.snackbar(
      'added_to_cart'.tr,
      'added_to_cart_message'.trParams({'title': product.title.tr}),
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
        shareSlug: product.shareSlug,
        shareDeepLink: product.shareDeepLink,
      );
      final message = 'share_product_message_template'.trParams({
        'title': resolvedTitle,
        'price': '\$${price.toStringAsFixed(2)}',
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
