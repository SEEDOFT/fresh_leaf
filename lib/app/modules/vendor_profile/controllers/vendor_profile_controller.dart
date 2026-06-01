import 'dart:async';
import 'package:fresh_leaf/app/routes/app_routes.dart';
import 'package:fresh_leaf/core/constants/api_endpoints.dart';
import 'package:fresh_leaf/core/models/api_response.dart';
import 'package:fresh_leaf/core/models/chat_conversation.dart';
import 'package:fresh_leaf/core/models/vendor_inventory.dart';
import 'package:fresh_leaf/core/models/vendor_profile.dart';
import 'package:fresh_leaf/core/services/api_client.dart';
import 'package:fresh_leaf/core/services/product_service.dart';
import 'package:get/get.dart';

class VendorProfileController extends GetxController {
  final ProductService _productService = Get.find<ProductService>();
  final ApiClient _apiClient = Get.find<ApiClient>();

  final RxBool isLoading = true.obs;
  final Rxn<VendorProfile> vendor = Rxn<VendorProfile>();
  final RxList<VendorInventory> products = <VendorInventory>[].obs;
  final RxBool isStartingChat = false.obs;

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

  Future<void> startChat() async {
    isStartingChat.value = true;
    try {
      final response = await _apiClient.postRequest(
        ApiEndpoints.chatConversations,
        data: {
          'type': 'direct',
          'user_id': vendorId,
        },
      );
      final apiResponse = ApiResponse.parseMap(response.data);

      if (apiResponse.isSuccess) {
        final newConversation = ChatConversation.fromMap(apiResponse.data);
        await Get.toNamed<void>(
          AppRoutes.supportChat,
          arguments: {'conversation': newConversation},
        );
      } else {
        Get.snackbar('error'.tr, apiResponse.status.message);
      }
    } on Exception {
      Get.snackbar('error'.tr, 'failed_create_chat'.tr);
    } finally {
      isStartingChat.value = false;
    }
  }
}
