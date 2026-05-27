import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fresh_leaf/core/constants/api_endpoints.dart';
import 'package:fresh_leaf/core/models/api_response.dart';
import 'package:fresh_leaf/core/services/api_client.dart';
import 'package:fresh_leaf/core/services/storage_service.dart';
import 'package:fresh_leaf/shared/helpers/helper.dart';
import 'package:get/get.dart';

class PinSecurityService {
  PinSecurityService._();

  static Future<bool> verifyOrderAccess() async {
    final storage = Get.find<StorageService>();
    final requirePin = storage.pinOrderVerification;

    if (!requirePin) return true;

    final pinController = TextEditingController();
    final result = await Get.dialog<bool>(
      AlertDialog(
        title: Text('pin_verification'.tr),
        content: TextField(
          controller: pinController,
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(6),
          ],
          obscureText: true,
          decoration: InputDecoration(hintText: 'enter_pin'.tr),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text('cancel'.tr),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            child: Text('verify'.tr),
          ),
        ],
      ),
    );

    final inputPin = pinController.text.trim();
    pinController.dispose();

    if (result != true) return false;
    if (inputPin.isEmpty) {
      Get.snackbar('invalid_pin'.tr, 'enter_your_pin'.tr);
      return false;
    }

    try {
      final api = Get.find<ApiClient>();
      final response = await api.postRequest(
        ApiEndpoints.verifyPin,
        data: {'pin': inputPin},
      );
      final apiResponse = ApiResponse.parseDynamic(response.data);

      if (apiResponse.isSuccess || response.statusCode == 200) {
        return true;
      }

      Get.snackbar('invalid_pin'.tr, 'incorrect_pin'.tr);
      return false;
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      final message = parseApiErrorMessage(
        e,
        fallback: 'unable_verify_pin'.tr,
      );

      if (statusCode == 422 && message.toLowerCase().contains('not set')) {
        await storage.savePinOrderVerification(enabled: false);
        Get.snackbar(
          'pin_not_set'.tr,
          'setup_pin_instruction'.tr,
        );
        return true;
      }

      Get.snackbar('invalid_pin'.tr, message);
      return false;
    } on Exception {
      Get.snackbar('invalid_pin'.tr, 'unable_verify_pin'.tr);
      return false;
    }
  }
}
