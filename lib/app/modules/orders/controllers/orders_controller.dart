import 'dart:async';
import 'package:fresh_leaf/core/models/order.dart';
import 'package:fresh_leaf/core/services/order_service.dart';
import 'package:get/get.dart';

enum OrderSortType {
  newest,
  oldest,
  highestTotal,
}

class OrdersController extends GetxController {
  final OrderService _orderService = Get.find<OrderService>();

  final RxBool isLoading = false.obs;
  final RxList<Order> orders = <Order>[].obs;
  final RxString _selectedStatus = 'All'.obs;
  final Rx<OrderSortType> _selectedSort = OrderSortType.newest.obs;

  String get selectedStatus => _selectedStatus.value;
  set selectedStatus(String status) => _selectedStatus.value = status;

  OrderSortType get selectedSort => _selectedSort.value;
  set selectedSort(OrderSortType sortType) => _selectedSort.value = sortType;

  List<String> get statusFilters => const [
    'All',
    'Pending',
    'Processing',
    'Delivered',
    'Cancelled',
  ];
  int get visibleOrderCount => filteredOrders.length;

  List<Order> get filteredOrders {
    final current = _selectedStatus.value;
    final list = current == 'All'
        ? List<Order>.from(orders)
        : orders.where((order) => order.statusName == current).toList();

    switch (_selectedSort.value) {
      case OrderSortType.newest:
        list.sort(
          (a, b) => (b.createdAt ?? DateTime(1970)).compareTo(
            a.createdAt ?? DateTime(1970),
          ),
        );
      case OrderSortType.oldest:
        list.sort(
          (a, b) => (a.createdAt ?? DateTime(1970)).compareTo(
            b.createdAt ?? DateTime(1970),
          ),
        );
      case OrderSortType.highestTotal:
        list.sort((a, b) => b.totalAmount.compareTo(a.totalAmount));
    }

    return list;
  }

  Map<String, List<Order>> get groupedFilteredOrders {
    final groups = <String, List<Order>>{
      'Today': <Order>[],
      'This Week': <Order>[],
      'This Month': <Order>[],
      'Earlier': <Order>[],
    };

    for (final order in filteredOrders) {
      final orderDate = order.createdAt ?? DateTime(1970);
      final section = _groupLabel(orderDate);
      groups[section]!.add(order);
    }

    groups.removeWhere((key, value) => value.isEmpty);
    return groups;
  }

  @override
  void onInit() {
    super.onInit();
    unawaited(loadOrders());
  }

  Future<void> loadOrders() async {
    isLoading.value = true;
    try {
      final fetchedOrders = await _orderService.getOrders();
      orders.assignAll(fetchedOrders);
    } finally {
      isLoading.value = false;
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
