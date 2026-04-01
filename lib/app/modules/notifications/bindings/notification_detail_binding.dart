import 'package:fresh_leaf/app/modules/notifications/controllers/notification_detail_controller.dart';
import 'package:get/get.dart';

class NotificationDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NotificationDetailController>(NotificationDetailController.new);
  }
}
