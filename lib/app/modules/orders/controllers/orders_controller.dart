import 'package:fresh_leaf/app/modules/orders/models/order.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class OrdersController extends GetxController {
  static final DateFormat _dateFormat = DateFormat('MMM d, yyyy');
  final RxBool isLoading = false.obs;
  final RxList<Order> orders = <Order>[].obs;
  final RxString _selectedStatus = 'All'.obs;

  String get selectedStatus => _selectedStatus.value;
  set selectedStatus(String status) => _selectedStatus.value = status;

  List<String> get statusFilters => const ['All', 'Processing', 'Delivered'];

  List<Order> get filteredOrders {
    final current = _selectedStatus.value;
    if (current == 'All') return orders;
    return orders.where((o) => o.status == current).toList();
  }

  Map<String, List<Order>> get groupedFilteredOrders {
    final groups = <String, List<Order>>{
      'Today': <Order>[],
      'This Week': <Order>[],
      'This Month': <Order>[],
      'Earlier': <Order>[],
    };

    for (final order in filteredOrders) {
      final orderDate = _tryParseOrderDate(order.date);
      final section = _groupLabel(orderDate);
      groups[section]!.add(order);
    }

    groups.removeWhere((key, value) => value.isEmpty);
    return groups;
  }

  @override
  void onInit() {
    super.onInit();
    loadOrders();
  }

  void loadOrders() {
    isLoading.value = true;
    // Simulate network delay
    Future.delayed(
      const Duration(seconds: 2),
      () => {
        isLoading.value = false,
        orders.value = const [
          Order(
            id: 'ORD001',
            date: 'Jan 15, 2026',
            total: 45.50,
            status: 'Delivered',
            items: [
              {'name': 'Heritage Carrots', 'quantity': 1, 'price': 4.50},
              {'name': 'Golden Oysters', 'quantity': 2, 'price': 8.00},
            ],
          ),
          Order(
            id: 'ORD002',
            date: 'Jan 10, 2026',
            total: 23.75,
            status: 'Processing',
            items: [
              {'name': 'Leafy Greens', 'quantity': 3, 'price': 3.25},
              {'name': 'Citrus Bundle', 'quantity': 1, 'price': 12.00},
            ],
          ),
          Order(
            id: 'ORD003',
            date: 'Jan 5, 2026',
            total: 67.80,
            status: 'Delivered',
            items: [
              {'name': 'Rainbow Chard', 'quantity': 2, 'price': 5.90},
              {'name': 'Wild Mushrooms', 'quantity': 1, 'price': 15.00},
              {'name': 'Artisan Bread', 'quantity': 2, 'price': 8.00},
            ],
          ),
        ],
      },
    );
  }

  DateTime _tryParseOrderDate(String input) {
    try {
      return _dateFormat.parse(input);
    } on Exception catch (_) {
      return DateTime(1970);
    }
  }

  String _groupLabel(DateTime orderDate) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(orderDate.year, orderDate.month, orderDate.day);
    final dayDiff = today.difference(target).inDays;

    if (dayDiff == 0) return 'Today';
    if (dayDiff > 0 && dayDiff <= 7) return 'This Week';
    if (orderDate.year == now.year && orderDate.month == now.month) {
      return 'This Month';
    }
    return 'Earlier';
  }
}
