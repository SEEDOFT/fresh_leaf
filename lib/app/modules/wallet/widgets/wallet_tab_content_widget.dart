import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/wallet/controllers/wallet_controller.dart';
import 'package:fresh_leaf/app/modules/wallet/widgets/wallet_balance_card_widget.dart';
import 'package:fresh_leaf/app/modules/wallet/widgets/wallet_transaction_tile_widget.dart';
import 'package:fresh_leaf/shared/helpers/responsive_helper.dart';
import 'package:get/get.dart';

class WalletTabContentWidget extends StatelessWidget {
  const WalletTabContentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<WalletController>();
    final scheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Obx(
          () => Padding(
            padding: EdgeInsets.fromLTRB(
              20.scaled,
              0,
              20.scaled,
              16.scaled,
            ),
            child: WalletBalanceCardWidget(
              currency: controller.selectedCurrency.value,
              balance: controller.activeBalance,
              symbol: controller.activeSymbol,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.scaled),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'transaction_history'.tr,
                style: TextStyle(
                  fontSize: 17.scaled,
                  fontWeight: FontWeight.w700,
                  color: scheme.onSurface,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text('see_all'.tr),
              ),
            ],
          ),
        ),
        Expanded(
          child: Obx(
            () {
              final transactions = controller.activeTransactions;
              final currency = controller.selectedCurrency.value;
              final symbol = controller.activeSymbol;

              return transactions.isEmpty
                  ? Center(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 20.scaled),
                        padding: EdgeInsets.symmetric(
                          horizontal: 18.scaled,
                          vertical: 20.scaled,
                        ),
                        decoration: BoxDecoration(
                          color: scheme.surfaceContainerHighest.withValues(
                            alpha: 0.32,
                          ),
                          borderRadius: BorderRadius.circular(16.scaled),
                          border: Border.all(
                            color: scheme.outline.withValues(alpha: 0.14),
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.receipt_long_outlined,
                              color: scheme.onSurfaceVariant,
                              size: 28.scaled,
                            ),
                            SizedBox(height: 10.scaled),
                            Text(
                              'no_transactions'.tr,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14.scaled,
                                fontWeight: FontWeight.w600,
                                color: scheme.onSurface,
                              ),
                            ),
                            SizedBox(height: 4.scaled),
                            Text(
                              'wallet_empty_hint'.tr,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12.scaled,
                                color: scheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.scaled,
                        vertical: 8.scaled,
                      ),
                      itemCount: transactions.length,
                      separatorBuilder: (context, index) {
                        return SizedBox(height: 8.scaled);
                      },
                      itemBuilder: (context, index) {
                        final tx = transactions[index];
                        return WalletTransactionTileWidget(
                          tx: tx,
                          currency: currency,
                          symbol: symbol,
                        );
                      },
                    );
            },
          ),
        ),
      ],
    );
  }
}
