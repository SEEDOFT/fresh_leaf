import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/profile/controllers/profile_controller.dart';
import 'package:fresh_leaf/core/constants/api_endpoints.dart';
import 'package:fresh_leaf/core/models/api_response.dart';
import 'package:fresh_leaf/core/models/user_profile.dart';
import 'package:fresh_leaf/core/services/api_client.dart';
import 'package:fresh_leaf/core/services/storage_service.dart';
import 'package:get/get.dart' hide FormData, MultipartFile, Response;
import 'package:image_picker/image_picker.dart';

class ProfilePersonalDetailsController extends GetxController {
  final RxString firstName = ''.obs;
  final RxString lastName = ''.obs;
  final RxString email = ''.obs;
  final RxString image = ''.obs;
  final RxString pickedImagePath = ''.obs;
  final RxString phone = ''.obs;
  final RxBool isSaving = false.obs;
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  UserProfile? _initialProfile;

  @override
  void onInit() {
    super.onInit();
    _loadUser();
  }

  void _loadUser() {
    final storage = Get.find<StorageService>();
    final profile = storage.userProfile;
    if (profile != null) {
      _initialProfile = profile;
      setProfile(profile);
    } else {
      final tokenPresent = storage.token?.isNotEmpty ?? false;
      if (tokenPresent) {
        firstName.value = 'FreshLeaf';
        lastName.value = ' Member';
        email.value = '—';
        phone.value = '—';
        _syncTextControllers();
      }
    }
  }

  void setProfile(UserProfile profile) {
    firstName.value = profile.firstName;
    lastName.value = profile.lastName;
    email.value = profile.email;
    image.value = profile.image;
    phone.value = profile.phoneNumber;
    _syncTextControllers();
  }

  Future<void> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: source, imageQuality: 80);
    if (file != null) {
      pickedImagePath.value = file.path;
    }
  }

  void clearPickedImage() {
    pickedImagePath.value = '';
  }

  Future<void> saveChanges() async {
    if (isSaving.value) return;
    FocusManager.instance.primaryFocus?.unfocus();

    final payload = await _buildUpdatePayload();
    if (payload.isEmpty) {
      Get.snackbar('no_changes'.tr, 'profile_up_to_date'.tr);
      return;
    }

    isSaving.value = true;
    try {
      final api = Get.find<ApiClient>();
      final response = await _updateProfile(
        api,
        partialPayload: payload,
        fullPayload: _buildFullUpdatePayload(),
      );
      final apiResponse = ApiResponse.fromResponse(
        response.data,
        (json) => (json is Map<String, dynamic>) ? json : <String, dynamic>{},
      );

      final mapData = apiResponse.data;
      final mergedProfile = UserProfile(
        firstName:
            (mapData['first_name'] as String?) ??
            firstNameController.text.trim(),
        lastName:
            (mapData['last_name'] as String?) ?? lastNameController.text.trim(),
        email: (mapData['email'] as String?) ?? emailController.text.trim(),
        image:
            (mapData['image'] as String?) ??
            (pickedImagePath.isNotEmpty ? pickedImagePath.value : image.value),
        phoneNumber:
            (mapData['phone_number'] as String?) ??
            _normalizePhoneForApi(phoneController.text),
        setPin: _toBool(
          mapData['set_pin'] ?? mapData['setPin'],
          fallback: _initialProfile?.setPin ?? false,
        ),
        createdAt: _initialProfile?.createdAt,
        updatedAt: _initialProfile?.updatedAt,
      );

      Get.find<StorageService>().setUserProfile(mergedProfile);
      _initialProfile = mergedProfile;
      setProfile(mergedProfile);

      if (Get.isRegistered<ProfileController>()) {
        Get.find<ProfileController>().setProfile(mergedProfile);
      }

      Get.snackbar(
        'success'.tr,
        apiResponse.status.message.isNotEmpty
            ? apiResponse.status.message
            : 'profile_updated_success'.tr,
      );
    } on DioException catch (_) {
      Get.snackbar('update_failed'.tr, 'failed_update_profile'.tr);
    } on Exception {
      Get.snackbar('update_failed'.tr, 'failed_update_profile'.tr);
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> refreshProfile() async {
    try {
      final apiClient = Get.find<ApiClient>();
      final response = await apiClient.getRequest(
        ApiEndpoints.userProfile,
      );
      final apiResponse = ApiResponse.fromResponse(
        response.data,
        (json) => (json is Map<String, dynamic>) ? json : <String, dynamic>{},
      );

      if (!apiResponse.isSuccess && response.statusCode != 200) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to refresh profile',
        );
      }

      final latestProfile = UserProfile.fromMap(apiResponse.data);
      Get.find<StorageService>().setUserProfile(latestProfile);
      _initialProfile = latestProfile;
      setProfile(latestProfile);

      if (Get.isRegistered<ProfileController>()) {
        Get.find<ProfileController>().setProfile(latestProfile);
      }
    } on DioException catch (_) {
      Get.snackbar('update_failed'.tr, 'unable_refresh_profile'.tr);
    }
  }

  Future<Map<String, dynamic>> _buildUpdatePayload() async {
    final payload = <String, dynamic>{};

    final nextFirstName = firstNameController.text.trim();
    final nextLastName = lastNameController.text.trim();
    final nextEmail = emailController.text.trim();
    final nextPhone = _normalizePhoneForApi(phoneController.text);

    final currentFirstName = _initialProfile?.firstName ?? firstName.value;
    final currentLastName = _initialProfile?.lastName ?? lastName.value;
    final currentEmail = _initialProfile?.email ?? email.value;
    final currentPhone = _normalizePhoneForApi(
      _initialProfile?.phoneNumber ?? phone.value,
    );

    if (nextFirstName != currentFirstName && nextFirstName.isNotEmpty) {
      payload['first_name'] = nextFirstName;
    }
    if (nextLastName != currentLastName && nextLastName.isNotEmpty) {
      payload['last_name'] = nextLastName;
    }
    if (nextEmail != currentEmail && nextEmail.isNotEmpty) {
      payload['email'] = nextEmail;
    }
    if (nextPhone != currentPhone && nextPhone.isNotEmpty) {
      payload['phone_number'] = nextPhone;
    }
    if (pickedImagePath.isNotEmpty) {
      payload['image'] = await MultipartFile.fromFile(
        pickedImagePath.value,
        filename: pickedImagePath.value.split(Platform.pathSeparator).last,
      );
    }

    return payload;
  }

  String _normalizePhoneForApi(String rawValue) {
    var raw = rawValue.trim().replaceAll(RegExp(r'[\s-]'), '');
    if (raw.isEmpty) return '';

    // Only Cambodia prefix is allowed.
    if (raw.startsWith('+') && !raw.startsWith('+855')) {
      return '';
    }

    if (raw.startsWith('+855')) {
      raw = raw.substring(4);
    } else if (raw.startsWith('855')) {
      raw = raw.substring(3);
    }

    raw = raw.replaceAll(RegExp('[^0-9]'), '');
    if (raw.startsWith('0')) {
      raw = raw.substring(1);
    }
    if (raw.isEmpty) return '';
    return '+855$raw';
  }

  bool _toBool(dynamic value, {required bool fallback}) {
    if (value is bool) return value;
    if (value is num) return value != 0;
    if (value is String) {
      final normalized = value.trim().toLowerCase();
      if (normalized == 'true' || normalized == '1' || normalized == 'yes') {
        return true;
      }
      if (normalized == 'false' || normalized == '0' || normalized == 'no') {
        return false;
      }
    }
    return fallback;
  }

  Map<String, dynamic> _buildFullUpdatePayload() {
    final payload = <String, dynamic>{
      'first_name': firstNameController.text.trim(),
      'last_name': lastNameController.text.trim(),
      'email': emailController.text.trim(),
      'phone_number': _normalizePhoneForApi(phoneController.text),
    }..removeWhere((key, value) => value.toString().trim().isEmpty);
    return payload;
  }

  Future<Response<dynamic>> _updateProfile(
    ApiClient api, {
    required Map<String, dynamic> partialPayload,
    required Map<String, dynamic> fullPayload,
  }) async {
    final usePatch = partialPayload.length == 1;
    final requestPayload = usePatch ? partialPayload : fullPayload;
    final hasFile = requestPayload.values.any(
      (value) => value is MultipartFile,
    );
    final payloadData = hasFile
        ? FormData.fromMap(requestPayload)
        : requestPayload;

    try {
      if (usePatch) {
        return await api.patchRequest(
          ApiEndpoints.userUpdateProfile,
          data: payloadData,
        );
      }
      return await api.putRequest(
        ApiEndpoints.userUpdateProfile,
        data: payloadData,
      );
    } on DioException catch (e) {
      final code = e.response?.statusCode ?? 0;
      if (code == 404 || code == 405) {
        return api.postRequest(
          ApiEndpoints.userUpdateProfile,
          data: payloadData,
        );
      }
      rethrow;
    }
  }

  void _syncTextControllers() {
    firstNameController.text = firstName.value;
    lastNameController.text = lastName.value;
    emailController.text = email.value;
    phoneController.text = phone.value;
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}
