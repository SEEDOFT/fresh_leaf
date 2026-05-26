import 'package:fresh_leaf/core/models/app_notification.dart';
import 'package:get/get.dart';

class NotificationDetailController extends GetxController {
  late final AppNotification item;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is AppNotification) {
      item = args;
    } else {
      item = AppNotification(
        id: 0,
        title: 'Notification',
        message: '',
        isRead: false,
        typeCode: 'SYSTEM',
      );
    }
  }
}
