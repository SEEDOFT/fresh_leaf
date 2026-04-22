import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/wallet/controllers/wallet_controller.dart';
import 'package:get/get.dart';

class WalletTopUpController extends GetxController {
  final amountController = TextEditingController();
  final RxString selectedCurrency = 'USD'.obs;
  final RxDouble selectedAmount = 0.0.obs;
  final RxBool isLoading = false.obs;

  final List<double> usdPresets = [10, 20, 50, 100];
  final List<double> khrPresets = [50000, 100000, 200000, 500000];

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is String) {
      selectedCurrency.value = args;
    }
  }

  void selectPreset(double amount) {
    selectedAmount.value = amount;
    amountController.text = amount % 1 == 0
        ? amount.toInt().toString()
        : amount.toString();
  }

  Future<void> proceedToPayment() async {
    final amountText = amountController.text;
    if (amountText.isEmpty) {
      Get.snackbar('Error', 'Please enter or select an amount');
      return;
    }

    final amount = double.tryParse(amountText);
    if (amount == null || amount <= 0) {
      Get.snackbar('Error', 'Please enter a valid amount');
      return;
    }

    isLoading.value = true;
    
    // Simulate payment processing
    await Future<void>.delayed(const Duration(seconds: 2));
    
    // Update WalletController balance
    if (Get.isRegistered<WalletController>()) {
      final walletCtrl = Get.find<WalletController>();
      if (selectedCurrency.value == 'USD') {
        walletCtrl.usdBalance.value += amount;
        walletCtrl.usdTransactions.insert(0, WalletTransaction(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: 'Top Up via Mock Payment',
          amount: amount,
          date: DateTime.now(),
          isCredit: true,
        ));
      } else {
        walletCtrl.khrBalance.value += amount;
        walletCtrl.khrTransactions.insert(0, WalletTransaction(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: 'Top Up via Mock Payment',
          amount: amount,
          date: DateTime.now(),
          isCredit: true,
        ));
      }
    }

    isLoading.value = false;
    Get.back<void>();
    final sym = selectedCurrency.value == 'KHR' ? '' : r'$';
    final label = selectedCurrency.value == 'KHR' ? ' ៛' : '';
    Get.snackbar(
      'Success',
      'Top up of $sym$amountText$label was successful',
    );
  }
}
