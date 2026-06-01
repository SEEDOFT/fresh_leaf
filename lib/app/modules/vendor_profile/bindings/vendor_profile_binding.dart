import 'package:fresh_leaf/app/modules/vendor_profile/controllers/vendor_profile_controller.dart';
import 'package:fresh_leaf/core/services/api_client.dart';
import 'package:fresh_leaf/core/services/product_service.dart';
import 'package:get/get.dart';

class VendorProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VendorProfileController>(
      () => VendorProfileController(
        productService: Get.find<ProductService>(),
        apiClient: Get.find<ApiClient>(),
      ),
    );
  }
}
