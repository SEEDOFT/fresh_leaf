import 'dart:async';
import 'package:flutter/material.dart';
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
  final RxMap<int, int> _apiStatusCounts = <int, int>{}.obs;

  int get selectedStatusId => _selectedStatusId.value;
  set selectedStatusId(int id) {
    if (_selectedStatusId.value == id) return;
    _selectedStatusId.value = id;
    final index = statusFilters.indexWhere((e) => e['id'] == id);
    if (index != -1 &&
        pageController.hasClients &&
        pageController.page?.round() != index) {
      unawaited(
        pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        ),
      );
    }
  }

  void onPageChanged(int index) {
    final id = statusFilters[index]['id'] as int;
    if (_selectedStatusId.value != id) {
      _selectedStatusId.value = id;
    }
  }

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

  Map<int, int> get statusCounts => _apiStatusCounts;

  List<Order> get filteredOrders => getOrdersForStatus(selectedStatusId);

  int get visibleOrderCount => filteredOrders.length;

  List<Order> getOrdersForStatus(int statusId) {
    final list = statusId == 0
        ? List<Order>.from(items)
        : items.where((order) => order.statusId == statusId).toList();

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

  Map<String, List<Order>> getGroupedOrdersForStatus(List<Order> filteredList) {
    final groups = <String, List<Order>>{
      'Today': <Order>[],
      'This Week': <Order>[],
      'This Month': <Order>[],
      'Earlier': <Order>[],
    };

    for (final order in filteredList) {
      final orderDate = order.createdAt ?? DateTime(1970);
      final section = _groupLabel(orderDate);
      groups[section]!.add(order);
    }

    groups.removeWhere((key, value) => value.isEmpty);
    return groups;
  }

  late final PageController pageController;

  @override
  void onInit() {
    super.onInit();
    pageController = PageController(
      initialPage:
          statusFilters.indexWhere((e) => e['id'] == _selectedStatusId.value) ==
              -1
          ? 0
          : statusFilters.indexWhere((e) => e['id'] == _selectedStatusId.value),
    );
    unawaited(loadInitial());
    unawaited(_fetchCounts());
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  @override
  Future<void> refreshList() async {
    await Future.wait([loadInitial(), _fetchCounts()]);
  }

  @override
  Future<PaginatedResponse<Order>> fetchPage(int page) async {
    return _orderService.getOrders(page: page);
  }

  Future<Order?> preloadOrderDetail(Order order) async {
    if (order.items.isNotEmpty) return order;

    return _orderService.getOrder(order.id);
  }

  Future<void> _fetchCounts() async {
    final counts = await _orderService.getOrderCounts();
    _apiStatusCounts.assignAll(counts);
  }

  String _groupLabel(DateTime orderDate) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(orderDate.year, orderDate.month, orderDate.day);
    final dayDiff = today.difference(target).inDays;

    if (dayDiff == 0) return 'today'.tr;
    if (dayDiff > 0 && dayDiff <= 7) return 'this_week'.tr;
    if (orderDate.year == now.year && orderDate.month == now.month) {
      return 'this_month'.tr;
    }
    return 'earlier'.tr;
  }
}
