import 'dart:async';
import 'package:fresh_leaf/core/mixins/paginated_list_mixin.dart';
import 'package:fresh_leaf/core/models/order.dart';
import 'package:fresh_leaf/core/models/paginated_response.dart';
import 'package:fresh_leaf/core/services/order_service.dart';
import 'package:get/get.dart';

enum OrderSortType {
  newest,
  oldest,
  highestTotal,
}

class OrdersController extends GetxController with PaginatedListMixin<Order> {
  OrdersController({required OrderService orderService})
    : _orderService = orderService;

  final OrderService _orderService;

  final RxInt _selectedStatusId = 0.obs;
  final Rx<OrderSortType> _selectedSort = OrderSortType.newest.obs;

  int get selectedStatusId => _selectedStatusId.value;
  set selectedStatusId(int id) => _selectedStatusId.value = id;

  OrderSortType get selectedSort => _selectedSort.value;
  set selectedSort(OrderSortType sortType) => _selectedSort.value = sortType;

  static const _activeStatusIds = {1, 2, 3, 6, 7};

  List<Map<String, dynamic>> get statusFilters => const [
    {'id': 0, 'name': 'All'},
    {'id': 1, 'name': 'Pending'},
    {'id': 2, 'name': 'Confirmed'},
    {'id': 3, 'name': 'Preparing'},
    {'id': 7, 'name': 'Out for Delivery'},
    {'id': 4, 'name': 'Delivered'},
    {'id': 5, 'name': 'Cancelled'},
    {'id': 6, 'name': 'Awaiting Payment'},
  ];

  int get activeOrderCount =>
      items.where((o) => _activeStatusIds.contains(o.statusId)).length;

  int get visibleOrderCount => filteredOrders.length;

  List<Order> get filteredOrders {
    final currentId = _selectedStatusId.value;
    final list = currentId == 0
        ? List<Order>.from(items)
        : items.where((order) => order.statusId == currentId).toList();

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
    unawaited(loadInitial());
  }

  @override
  Future<PaginatedResponse<Order>> fetchPage(int page) async {
    return _orderService.getOrders(page: page);
  }

  Future<Order?> preloadOrderDetail(Order order) async {
    if (order.items.isNotEmpty) return order;

    return _orderService.getOrder(order.id);
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
