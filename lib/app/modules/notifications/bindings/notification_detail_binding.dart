import 'package:fresh_leaf/app/modules/notifications/controllers/notification_detail_controller.dart';
import 'package:fresh_leaf/core/services/notification_service.dart';
import 'package:get/get.dart';

class NotificationDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NotificationDetailController>(
      () => NotificationDetailController(
        notificationService: Get.find<NotificationService>(),
      ),
    );
  }
}
