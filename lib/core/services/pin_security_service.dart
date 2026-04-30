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
        title: const Text('PIN Verification'),
        content: TextField(
          controller: pinController,
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(6),
          ],
          obscureText: true,
          decoration: const InputDecoration(hintText: 'Enter PIN'),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Verify'),
          ),
        ],
      ),
    );

    final inputPin = pinController.text.trim();
    pinController.dispose();

    if (result != true) return false;
    if (inputPin.isEmpty) {
      Get.snackbar('Invalid PIN', 'Please enter your PIN.');
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

      Get.snackbar('Invalid PIN', 'The PIN you entered is incorrect.');
      return false;
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      final message = parseApiErrorMessage(
        e,
        fallback: 'Unable to verify PIN right now',
      );

      if (statusCode == 422 && message.toLowerCase().contains('not set')) {
        await storage.savePinOrderVerification(enabled: false);
        Get.snackbar(
          'PIN not set',
          'Please set up your PIN in Profile > PIN Security.',
        );
        return true;
      }

      Get.snackbar('Invalid PIN', message);
      return false;
    } on Exception {
      Get.snackbar('Invalid PIN', 'Unable to verify PIN right now');
      return false;
    }
  }
}
