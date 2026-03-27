import 'package:get/get.dart';
import 'package:fresh_leaf/app/modules/product_detail/models/product_info.dart';

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
}
