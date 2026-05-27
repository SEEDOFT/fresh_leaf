import 'dart:async';
import 'package:fresh_leaf/core/models/vendor_inventory.dart';
import 'package:fresh_leaf/core/models/vendor_profile.dart';
import 'package:fresh_leaf/core/services/product_service.dart';
import 'package:get/get.dart';

class VendorProfileController extends GetxController {
  final ProductService _productService = Get.find<ProductService>();

  final RxBool isLoading = true.obs;
  final Rxn<VendorProfile> vendor = Rxn<VendorProfile>();
  final RxList<VendorInventory> products = <VendorInventory>[].obs;

  late final int vendorId;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is int) {
      vendorId = args;
    } else {
      vendorId = int.tryParse(args.toString()) ?? 0;
    }
    unawaited(loadVendorProfile());
  }

  Future<void> loadVendorProfile() async {
    isLoading.value = true;
    try {
      final result = await _productService.getVendorProfile(vendorId);
      vendor.value = result.$1;
      products.value = result.$2;
    } finally {
      isLoading.value = false;
    }
  }
}
