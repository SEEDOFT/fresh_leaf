import 'package:get/get.dart';

class Order {
  final String id;
  final String date;
  final double total;
  final String status;
  final List<Map<String, dynamic>> items;

  Order({
    required this.id,
    required this.date,
    required this.total,
    required this.status,
    required this.items,
  });
}

class OrdersController extends GetxController {
  final isLoading = false.obs;
  final orders = <Order>[].obs;

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
        orders.value = [
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
}
