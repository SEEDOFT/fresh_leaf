import 'package:get/get.dart';
import 'notifications_controller.dart';

class NotificationDetailController extends GetxController {
  late final NotificationItem item;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is NotificationItem) {
      item = args;
    } else if (args is Map) {
      item = NotificationItem(
        title: args['title']?.toString() ?? 'Notification',
        body: args['body']?.toString() ?? '',
        timeAgo: args['timeAgo']?.toString() ?? '',
        type: args['type']?.toString() ?? 'system',
        unread: args['unread'] is bool ? args['unread'] : true,
      );
    } else {
      item = const NotificationItem(
        title: 'Notification',
        body: '',
        timeAgo: '',
        type: 'system',
        unread: false,
      );
    }
  }
}
