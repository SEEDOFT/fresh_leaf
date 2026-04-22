import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WalletTransaction {
  WalletTransaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.isCredit,
    this.status = 'Success',
  });

  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final bool isCredit;
  final String status;
}

class WalletController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;

  final RxDouble khrBalance = 250000.0.obs;
  final RxDouble usdBalance = 125.50.obs;

  final RxList<WalletTransaction> khrTransactions = <WalletTransaction>[
    WalletTransaction(
      id: '1',
      title: 'Top Up via ABA',
      amount: 50000,
      date: DateTime.now().subtract(const Duration(days: 1)),
      isCredit: true,
    ),
    WalletTransaction(
      id: '2',
      title: 'Payment for Order #1234',
      amount: 15000,
      date: DateTime.now().subtract(const Duration(days: 2)),
      isCredit: false,
    ),
  ].obs;

  final RxList<WalletTransaction> usdTransactions = <WalletTransaction>[
    WalletTransaction(
      id: '1',
      title: 'Top Up via Visa',
      amount: 50,
      date: DateTime.now().subtract(const Duration(days: 1)),
      isCredit: true,
    ),
    WalletTransaction(
      id: '2',
      title: 'Payment for Order #1235',
      amount: 12.50,
      date: DateTime.now().subtract(const Duration(days: 3)),
      isCredit: false,
    ),
  ].obs;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  void topUp(String currency) {
    // Navigate to top up screen with currency context
    // Get.toNamed(AppRoutes.paymentMethodsAdd); // For now, or dedicated top up
  }
}
