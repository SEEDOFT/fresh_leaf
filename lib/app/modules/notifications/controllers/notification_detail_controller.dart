import 'package:fresh_leaf/core/models/app_notification.dart';
import 'package:fresh_leaf/core/services/notification_service.dart';
import 'package:get/get.dart';

class NotificationDetailController extends GetxController {
  NotificationDetailController({
    required NotificationService notificationService,
  }) : _notificationService = notificationService;

  final NotificationService _notificationService;
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
        title: 'notification_default_title'.tr,
        message: '',
        isRead: false,
        typeCode: 'SYSTEM',
      );
    }
  }

  Future<void> markAsRead(int id) async {
    final success = await _notificationService.markAsRead(id);

    if (success) {
      Get.back<bool>(result: true);
    }
  }
}
