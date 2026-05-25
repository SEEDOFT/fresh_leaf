import 'dart:async';
import 'package:fresh_leaf/core/models/vendor_inventory.dart';
import 'package:fresh_leaf/core/services/product_service.dart';
import 'package:get/get.dart';

class ProductListController extends GetxController {
  final ProductService _productService = Get.find<ProductService>();

  final RxBool isLoading = false.obs;
  final RxList<VendorInventory> products = <VendorInventory>[].obs;

  @override
  void onInit() {
    super.onInit();
    unawaited(loadProducts());
  }

  Future<void> loadProducts() async {
    isLoading.value = true;
    try {
      final fetchedProducts = await _productService.getProducts();
      products.value = fetchedProducts;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshProducts() async {
    await loadProducts();
  }
}
