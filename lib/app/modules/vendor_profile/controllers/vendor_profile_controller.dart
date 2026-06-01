import 'dart:async';
import 'package:fresh_leaf/app/routes/app_routes.dart';
import 'package:fresh_leaf/core/constants/api_endpoints.dart';
import 'package:fresh_leaf/core/models/api_response.dart';
import 'package:fresh_leaf/core/models/chat_conversation.dart';
import 'package:fresh_leaf/core/models/vendor_inventory.dart';
import 'package:fresh_leaf/core/models/vendor_profile.dart';
import 'package:fresh_leaf/core/services/api_client.dart';
import 'package:fresh_leaf/core/services/product_service.dart';
import 'package:fresh_leaf/shared/helpers/product_share_helper.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

class VendorProfileController extends GetxController {
  VendorProfileController({
    required ProductService productService,
    required ApiClient apiClient,
  }) : _productService = productService,
       _apiClient = apiClient;

  final ProductService _productService;
  final ApiClient _apiClient;

  final RxBool isLoading = true.obs;
  final Rxn<VendorProfile> vendor = Rxn<VendorProfile>();
  final RxList<VendorInventory> products = <VendorInventory>[].obs;
  final RxBool isStartingChat = false.obs;
  final Rxn<int> selectedCategoryId = Rxn<int>();

  List<({int id, String name})> get productCategories {
    final seen = <int>{};
    final result = <({int id, String name})>[];
    for (final item in products) {
      final catId = item.product?.productCategoryId;
      final catName = item.product?.productCategoryName;
      if (catId != null && catName != null && seen.add(catId)) {
        result.add((id: catId, name: catName));
      }
    }
    return result;
  }

  List<VendorInventory> get filteredProducts {
    final catId = selectedCategoryId.value;
    if (catId == null) return products;
    return products
        .where((p) => p.product?.productCategoryId == catId)
        .toList();
  }

  int? get category => selectedCategoryId.value;
  set category(int? id) {
    selectedCategoryId.value = id;
  }

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

  Future<void> shareVendor() async {
    final v = vendor.value;
    if (v == null) return;
    try {
      final name = v.displayName;
      final slug = ProductShareHelper.resolveSlug(title: name);
      final deepLink = 'freshleaf://vendor/$slug';
      final message = 'share_vendor_message_template'.trParams({
        'name': name,
        'link': deepLink,
      });
      await SharePlus.instance.share(
        ShareParams(
          text: message,
          subject: name,
        ),
      );
    } on Exception {
      Get.snackbar(
        'share_vendor'.tr,
        'unable_share_vendor'.tr,
      );
    }
  }
}
