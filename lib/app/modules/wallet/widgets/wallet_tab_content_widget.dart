import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/wallet/controllers/wallet_controller.dart';
import 'package:fresh_leaf/app/modules/wallet/widgets/wallet_balance_card_widget.dart';
import 'package:fresh_leaf/app/modules/wallet/widgets/wallet_transaction_tile_widget.dart';
import 'package:fresh_leaf/shared/helpers/responsive_helper.dart';
import 'package:get/get.dart';

class WalletTabContentWidget extends StatelessWidget {
  const WalletTabContentWidget({
    required this.currency,
    required this.balance,
    required this.transactions,
    required this.symbol,
    super.key,
  });

  final String currency;
  final RxDouble balance;
  final RxList<WalletTransaction> transactions;
  final String symbol;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(20.scaled),
          child: WalletBalanceCardWidget(
            currency: currency,
            balance: balance,
            symbol: symbol,
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
                  fontSize: 18.scaled,
                  fontWeight: FontWeight.bold,
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
            () => transactions.isEmpty
                ? Center(child: Text('no_transactions'.tr))
                : ListView.separated(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.scaled,
                      vertical: 10.scaled,
                    ),
                    itemCount: transactions.length,
                    separatorBuilder: (context, index) {
                      return Divider(
                        height: 20.scaled,
                        color: scheme.outline.withValues(alpha: 0.1),
                      );
                    },
                    itemBuilder: (context, index) {
                      final tx = transactions[index];
                      return WalletTransactionTileWidget(
                        tx: tx,
                        symbol: symbol,
                      );
                    },
                  ),
          ),
        ),
      ],
    );
  }
}
