import 'package:get/get.dart';

class NotificationItem {
  const NotificationItem({
    required this.title,
    required this.body,
    required this.timeAgo,
    required this.type,
    this.unread = true,
  });

  final String title;
  final String body;
  final String timeAgo;
  final String type; // e.g., order, promo, system
  final bool unread;

  NotificationItem copyWith({bool? unread}) => NotificationItem(
        title: title,
        body: body,
        timeAgo: timeAgo,
        type: type,
        unread: unread ?? this.unread,
      );
}

class NotificationsController extends GetxController {
  final RxList<NotificationItem> notifications = <NotificationItem>[].obs;
  final RxString activeFilter = 'all'.obs;
  final RxBool isRefreshing = false.obs;

  @override
  void onInit() {
    super.onInit();
    _seed();
  }

  void _seed() {
    notifications.assignAll(const [
      NotificationItem(
        title: 'Order delivered',
        body: 'Your order #FL-1043 has arrived. Rate your experience.',
        timeAgo: '12m ago',
        type: 'order',
      ),
      NotificationItem(
        title: 'New seasonal box',
        body: 'Try our Citrus Sunrise box with 15% off this week only.',
        timeAgo: '1h ago',
        type: 'promo',
      ),
      NotificationItem(
        title: 'System reminder',
        body: 'Enable notifications to get delivery updates in real time.',
        timeAgo: '2h ago',
        type: 'system',
        unread: false,
      ),
      NotificationItem(
        title: 'Order update',
        body: 'Your order #FL-1045 is out for delivery. ETA 25-30 min.',
        timeAgo: '5h ago',
        type: 'order',
      ),
    ]);
  }

  List<NotificationItem> get filtered {
    if (activeFilter.value == 'all') return notifications;
    return notifications
        .where((n) => n.type == activeFilter.value)
        .toList(growable: false);
  }

  Future<void> refreshList() async {
    if (isRefreshing.value) return;
    isRefreshing.value = true;
    await Future.delayed(const Duration(milliseconds: 900));
    isRefreshing.value = false;
  }

  void markAllRead() {
    notifications.assignAll(
      notifications.map((n) => n.copyWith(unread: false)).toList(),
    );
  }

  void setFilter(String value) {
    activeFilter.value = value;
  }
}
