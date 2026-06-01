import 'package:fresh_leaf/app/modules/notifications/controllers/notifications_controller.dart';
import 'package:fresh_leaf/core/services/notification_service.dart';
import 'package:get/get.dart';

class NotificationsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NotificationsController>(
      () => NotificationsController(
        notificationService: Get.find<NotificationService>(),
      ),
    );
  }
}
