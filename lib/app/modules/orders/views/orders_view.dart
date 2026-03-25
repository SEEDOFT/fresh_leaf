import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/orders_controller.dart';

class OrdersView extends GetView<OrdersController> {
  const OrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Orders View'),
    );
  }
}
