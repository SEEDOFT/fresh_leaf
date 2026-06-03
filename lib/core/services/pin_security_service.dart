import 'package:fresh_leaf/app/routes/app_routes.dart';
import 'package:fresh_leaf/core/services/storage_service.dart';
import 'package:get/get.dart';

class PinSecurityService {
  PinSecurityService._();

  static Future<bool> verifyOrderAccess() async {
    final storage = Get.find<StorageService>();
    final requirePin = storage.pinOrderVerification;

    if (!requirePin) return true;
    final pin = await verifyPin();
    return pin != null;
  }

  static Future<String?> verifyPin() async {
    final result = await Get.toNamed<dynamic>(AppRoutes.pinVerification);
    return result is String ? result : null;
  }
}
