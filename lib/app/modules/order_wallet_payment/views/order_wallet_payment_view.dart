import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/order_wallet_payment/controllers/order_wallet_payment_controller.dart';
import 'package:get/get.dart';

class OrderWalletPaymentView extends GetView<OrderWalletPaymentController> {
  const OrderWalletPaymentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('wallet_payment'.tr),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: controller.cancelPayment,
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final orders = controller.orders;
        if (orders.isEmpty && !controller.isCheckout) {
          return Center(child: Text('order_not_found'.tr));
        }

        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Order Summary Card
                    Card(
                      elevation: 0,
                      color: Theme.of(context).colorScheme.surfaceContainer,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            Text(
                              'total_amount'.tr,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              controller.totalDisplay.combinedText,
                              style: Theme.of(context).textTheme.headlineMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'select_wallet'.tr,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (controller.wallets.isEmpty)
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          'no_wallets_found'.tr,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Theme.of(context).hintColor),
                        ),
                      )
                    else
                      ...controller.wallets.map((wallet) {
                        final isSelected =
                            controller.selectedWallet.value?.id == wallet.id;
                        final hasEnough =
                            wallet.balance >= controller.totalAmount;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isSelected
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.outline
                                        .withValues(alpha: 0.2),
                              width: isSelected ? 2 : 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Opacity(
                            opacity: hasEnough ? 1.0 : 0.5,
                            child: ListTile(
                              onTap: hasEnough
                                  ? () =>
                                        controller.updateSelectedWallet(wallet)
                                  : null,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              leading: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.primary.withValues(alpha: 0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.account_balance_wallet,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              title: Text(
                                'wallet_label'.trParams({
                                  'currencyCode': wallet.currency.code,
                                }),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 4),
                                  Text(
                                    'wallet_balance'.trParams({
                                      'balance': wallet.balance.toString(),
                                      'symbol': wallet.currency.symbol,
                                    }),
                                  ),
                                  if (!hasEnough)
                                    Text(
                                      'insufficient_balance'.tr,
                                      style: TextStyle(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.error,
                                        fontSize: 12,
                                      ),
                                    ),
                                ],
                              ),
                              trailing: isSelected
                                  ? Icon(
                                      Icons.check_circle,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                    )
                                  : const SizedBox.shrink(),
                            ),
                          ),
                        );
                      }),
                  ],
                ),
              ),
            ),
            // Bottom Action Area
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: SafeArea(
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: controller.canPay
                        ? () => controller.payOrder()
                        : null,
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: controller.isPaying.value
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            'pay_now'.tr,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
