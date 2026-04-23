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
      await Share.share(
        message,
        subject: resolvedTitle,
      );
    } on Exception {
      Get.snackbar(
        'share_product'.tr,
        'unable_share_product'.tr,
      );
    }
  }
}
