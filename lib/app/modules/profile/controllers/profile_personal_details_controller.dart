import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/profile/controllers/profile_controller.dart';
import 'package:fresh_leaf/core/constants/api_endpoints.dart';
import 'package:fresh_leaf/core/models/api_response.dart';
import 'package:fresh_leaf/core/models/user_profile.dart';
import 'package:fresh_leaf/core/services/api_client.dart';
import 'package:fresh_leaf/core/services/storage_service.dart';
import 'package:fresh_leaf/shared/helpers/helper.dart';
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
  final ApiClient _apiClient = Get.find<ApiClient>();
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
      final response = await _updateProfile(
        partialPayload: payload,
        fullPayload: _buildFullUpdatePayload(),
      );
      final apiResponse = ApiResponse.parseMap(response.data);

      final mapData = apiResponse.data;
      final currentProfile = Get.find<StorageService>().userProfile;
      final mergedProfile = UserProfile(
        id: toInt(mapData['id'], defaultValue: currentProfile?.id ?? 0),
        firstName: formatToString(
          mapData['first_name'],
          defaultValue: firstNameController.text.trim(),
        ),
        lastName: formatToString(
          mapData['last_name'],
          defaultValue: lastNameController.text.trim(),
        ),
        email: formatToString(
          mapData['email'],
          defaultValue: emailController.text.trim(),
        ),
        image: formatToString(
          mapData['image'],
          defaultValue: pickedImagePath.isNotEmpty
              ? pickedImagePath.value
              : image.value,
        ),
        phoneNumber: formatToString(
          mapData['phone_number'],
          defaultValue: normalizeCambodiaPhoneForApi(phoneController.text),
        ),
        locale: formatToString(
          mapData['locale'],
          defaultValue: currentProfile?.locale ?? 'km',
        ),
        theme: formatToString(
          mapData['theme'] ?? mapData['theme'],
          defaultValue: currentProfile?.theme ?? 'system',
        ),
        setPin: toBool(
          mapData['set_pin'] ?? mapData['setPin'],
          defaultValue: _initialProfile?.setPin ?? false,
        ),
        createdAt: _initialProfile?.createdAt,
        updatedAt: _initialProfile?.updatedAt,
      );

      Get.find<StorageService>().userProfile = mergedProfile;
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
    } on DioException catch (e) {
      Get.snackbar(
        'update_failed'.tr,
        parseApiErrorMessage(
          e,
          fallback: 'failed_update_profile'.tr,
        ),
      );
    } on Exception {
      Get.snackbar('update_failed'.tr, 'failed_update_profile'.tr);
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> refreshProfile() async {
    try {
      final response = await _apiClient.getRequest(
        ApiEndpoints.profile,
      );
      final apiResponse = ApiResponse.parseMap(response.data);

      if (!apiResponse.isSuccess && response.statusCode != 200) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to refresh profile',
        );
      }

      final latestProfile = UserProfile.fromMap(apiResponse.data);
      Get.find<StorageService>().userProfile = latestProfile;
      _initialProfile = latestProfile;
      setProfile(latestProfile);

      if (Get.isRegistered<ProfileController>()) {
        Get.find<ProfileController>().setProfile(latestProfile);
      }
    } on DioException {
      Get.snackbar('update_failed'.tr, 'unable_refresh_profile'.tr);
    } on Exception {
      Get.snackbar('update_failed'.tr, 'unable_refresh_profile'.tr);
    }
  }

  Future<Map<String, dynamic>> _buildUpdatePayload() async {
    final payload = <String, dynamic>{};

    final nextFirstName = firstNameController.text.trim();
    final nextLastName = lastNameController.text.trim();
    final nextEmail = emailController.text.trim();
    final nextPhone = normalizeCambodiaPhoneForApi(phoneController.text);

    final currentFirstName = _initialProfile?.firstName ?? firstName.value;
    final currentLastName = _initialProfile?.lastName ?? lastName.value;
    final currentEmail = _initialProfile?.email ?? email.value;
    final currentPhone = normalizeCambodiaPhoneForApi(
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

  Map<String, dynamic> _buildFullUpdatePayload() {
    final payload = <String, dynamic>{
      'first_name': firstNameController.text.trim(),
      'last_name': lastNameController.text.trim(),
      'email': emailController.text.trim(),
      'phone_number': normalizeCambodiaPhoneForApi(phoneController.text),
    }..removeWhere((key, value) => value.toString().trim().isEmpty);

    if (pickedImagePath.isNotEmpty) {
      payload['image'] = MultipartFile.fromFileSync(
        pickedImagePath.value,
        filename: pickedImagePath.value.split(Platform.pathSeparator).last,
      );
    }
    return payload;
  }

  Future<Response<dynamic>> _updateProfile({
    required Map<String, dynamic> partialPayload,
    required Map<String, dynamic> fullPayload,
  }) async {
    final usePatch = partialPayload.length == 1;
    final requestPayload = usePatch ? partialPayload : fullPayload;
    final hasFile = requestPayload.values.any(
      (value) => value is MultipartFile,
    );
    if (hasFile) {
      // Laravel file upload update convention: POST + method spoofing.
      final methodOverride = usePatch ? 'PATCH' : 'PUT';
      final multipartPayload = <String, dynamic>{
        ...requestPayload,
        '_method': methodOverride,
      };
      return _apiClient.postRequest(
        ApiEndpoints.userUpdateProfile,
        data: FormData.fromMap(multipartPayload),
        options: Options(contentType: 'multipart/form-data'),
      );
    }

    final payloadData = requestPayload;

    try {
      if (usePatch) {
        return await _apiClient.patchRequest(
          ApiEndpoints.userUpdateProfile,
          data: payloadData,
        );
      }
      return await _apiClient.putRequest(
        ApiEndpoints.userUpdateProfile,
        data: payloadData,
      );
    } on DioException catch (e) {
      final code = e.response?.statusCode ?? 0;
      if (code == 404 || code == 405) {
        return _apiClient.postRequest(
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
