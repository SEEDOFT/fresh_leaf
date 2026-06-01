import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/profile/controllers/profile_controller.dart';
import 'package:fresh_leaf/app/routes/app_routes.dart';
import 'package:fresh_leaf/core/constants/api_endpoints.dart';
import 'package:fresh_leaf/core/models/api_response.dart';
import 'package:fresh_leaf/core/models/user_address.dart';
import 'package:fresh_leaf/core/models/user_profile.dart';
import 'package:fresh_leaf/core/services/api_client.dart';
import 'package:fresh_leaf/core/services/storage_service.dart';
import 'package:fresh_leaf/shared/helpers/helper.dart';
import 'package:get/get.dart';

class ProfileAddressesController extends GetxController {
  ProfileAddressesController({
    required ApiClient apiClient,
    required ProfileController profileController,
    required StorageService storageService,
  }) : _apiClient = apiClient,
       _profileController = profileController,
       _storageService = storageService;

  final RxList<UserAddress> savedAddresses = <UserAddress>[].obs;
  final RxBool isLoadingAddresses = false.obs;
  final RxBool isRefreshing = false.obs;
  final RxString deletingAddressId = ''.obs;
  final ApiClient _apiClient;
  final ProfileController _profileController;
  final StorageService _storageService;

  bool returnOnSelect = false;
  String mode = 'view';

  @override
  void onInit() {
    super.onInit();
    final map = Get.arguments;
    if (map is Map<String, dynamic>) {
      mode = map['mode']?.toString() ?? 'view';
      returnOnSelect = map['return_on_select'] == true;
    }
    savedAddresses.assignAll(_profileController.addresses);
  }

  @override
  Future<void> onReady() async {
    super.onReady();
    await fetchSavedAddresses(showError: false);
  }

  Future<void> refreshAddresses() async {
    if (isRefreshing.value) return;
    isRefreshing.value = true;
    try {
      await fetchSavedAddresses();
    } finally {
      isRefreshing.value = false;
    }
  }

  void selectAddress(UserAddress address) {
    if (returnOnSelect) {
      Get.back<dynamic>(result: address);
    }
  }

  Future<void> fetchSavedAddresses({bool showError = true}) async {
    if (isLoadingAddresses.value) return;
    if (savedAddresses.isEmpty) {
      isLoadingAddresses.value = true;
    }

    try {
      final response = await _apiClient.getRequest(ApiEndpoints.addresses);
      final apiResponse = ApiResponse.parseDynamic(response.data);

      if (!apiResponse.isSuccess && response.statusCode != 200) {
        if (showError) {
          Get.snackbar(
            'fetch_failed'.tr,
            apiResponse.status.message.isNotEmpty
                ? apiResponse.status.message
                : 'unable_load_addresses'.tr,
          );
        }
        return;
      }

      final items = _extractAddressMaps(
        apiResponse.data,
      ).map(UserAddress.fromMap).toList();
      savedAddresses.assignAll(items);
    } on DioException catch (e) {
      if (!showError) return;
      Get.snackbar(
        'fetch_failed'.tr,
        parseApiErrorMessage(
          e,
          fallback: 'unable_load_addresses'.tr,
        ),
      );
    } on Exception {
      if (!showError) return;
      Get.snackbar('fetch_failed'.tr, 'unable_load_addresses'.tr);
    } finally {
      isLoadingAddresses.value = false;
    }
  }

  Future<void> openCreateAddress() async {
    final storage = _storageService;
    final profile = storage.userProfile;

    final result = await Get.toNamed<dynamic>(
      AppRoutes.addressesEdit,
      arguments: {
        'mode': 'create',
        'label': 'address_label_home'.tr,
        'recipient_name': _resolveRecipientName(profile),
        'phone': _resolvePhone(profile),
        'address_line_1': '',
        'address_line_2': '',
        'city': '',
        'province': '',
        'postal_code': '',
      },
    );

    if (_didAddressChange(result)) {
      await fetchSavedAddresses(showError: false);
    }
  }

  Future<void> openEditAddress(UserAddress address) async {
    final result = await Get.toNamed<dynamic>(
      AppRoutes.addressesEdit,
      arguments: {
        'mode': 'edit',
        'id': address.id,
        'label': address.label,
        'recipient_name': address.recipientName,
        'phone': address.phone,
        'address_line_1': address.addressLine1,
        'address_line_2': address.addressLine2,
        'city': address.city,
        'province': address.province,
        'postal_code': address.postalCode,
        'lat': address.lat,
        'long': address.long,
      },
    );

    if (_didAddressChange(result)) {
      await fetchSavedAddresses(showError: false);
    }
  }

  Future<void> requestDeleteAddress(UserAddress address) async {
    if (deletingAddressId.value.isNotEmpty) return;

    if (address.id.isEmpty) {
      Get.snackbar('delete_failed'.tr, 'address_id_missing'.tr);
      return;
    }

    final confirmed =
        await Get.dialog<bool>(
          AlertDialog(
            title: Text('delete_address_title'.tr),
            content: Text('delete_address_account_body'.tr),
            actions: [
              TextButton(
                onPressed: () => Get.back(result: false),
                child: Text('cancel'.tr),
              ),
              FilledButton(
                onPressed: () => Get.back(result: true),
                style: FilledButton.styleFrom(
                  backgroundColor: Get.theme.colorScheme.error,
                ),
                child: Text('delete'.tr),
              ),
            ],
          ),
        ) ??
        false;

    if (!confirmed) return;

    deletingAddressId.value = address.id;
    try {
      final path = ApiEndpoints.address.replaceFirst('{id}', address.id);
      final response = await _apiClient.deleteRequest(path);

      if (response.statusCode != 200 && response.statusCode != 204) {
        Get.snackbar('delete_failed'.tr, 'unable_delete_address'.tr);
        return;
      }

      var message = 'deleted'.tr;
      final body = response.data;
      if (body is Map<String, dynamic>) {
        final statusMap = body['status'];
        if (statusMap is Map<String, dynamic>) {
          final fromApi = statusMap['message']?.toString() ?? '';
          if (fromApi.isNotEmpty) {
            message = fromApi;
          }
        }
      }

      await fetchSavedAddresses(showError: false);
      Get.snackbar('deleted'.tr, message);
    } on DioException catch (e) {
      Get.snackbar(
        'delete_failed'.tr,
        parseApiErrorMessage(
          e,
          fallback: 'unable_delete_address'.tr,
        ),
      );
    } on Exception {
      Get.snackbar('delete_failed'.tr, 'unable_delete_address'.tr);
    } finally {
      deletingAddressId.value = '';
    }
  }

  List<Map<String, dynamic>> _extractAddressMaps(dynamic data) {
    if (data is List) {
      return data.whereType<Map<String, dynamic>>().toList();
    }

    if (data is Map) {
      final nested = data['items'] ?? data['addresses'] ?? data['data'];
      if (nested is List) {
        return nested.whereType<Map<String, dynamic>>().toList();
      }
    }

    return const <Map<String, dynamic>>[];
  }

  String _resolveRecipientName(UserProfile? profile) {
    if (profile == null) return 'default_profile_name'.tr;
    final value = '${profile.firstName} ${profile.lastName}'.trim();
    return value.isEmpty ? 'default_profile_name'.tr : value;
  }

  String _resolvePhone(UserProfile? profile) {
    final value = profile?.phoneNumber.trim() ?? '';
    if (value.isEmpty) return '';
    return value;
  }

  bool _didAddressChange(dynamic routeResult) {
    return routeResult is bool && routeResult;
  }
}
