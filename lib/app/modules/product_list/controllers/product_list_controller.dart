import 'dart:async';
import 'package:fresh_leaf/core/mixins/paginated_list_mixin.dart';
import 'package:fresh_leaf/core/models/paginated_response.dart';
import 'package:fresh_leaf/core/models/vendor_inventory.dart';
import 'package:fresh_leaf/core/services/product_service.dart';
import 'package:get/get.dart';

class ProductListController extends GetxController
    with PaginatedListMixin<VendorInventory> {
  ProductListController({required ProductService productService})
    : _productService = productService;

  final ProductService _productService;

  List<VendorInventory> get products => items;

  @override
  void onInit() {
    super.onInit();
    unawaited(loadInitial());
  }

  @override
  Future<PaginatedResponse<VendorInventory>> fetchPage(int page) async {
    return _productService.getProducts(page: page);
  }

  Future<void> refreshProducts() async {
    await refreshList();
  }
}
