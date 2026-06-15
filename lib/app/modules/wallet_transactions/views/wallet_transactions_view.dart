import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/wallet/controllers/wallet_controller.dart';
import 'package:fresh_leaf/app/modules/wallet/widgets/wallet_transaction_tile_widget.dart';
import 'package:fresh_leaf/shared/helpers/responsive_helper.dart';
import 'package:fresh_leaf/shared/widgets/app_scaffold.dart';
import 'package:fresh_leaf/shared/widgets/custom_app_bar.dart';
import 'package:fresh_leaf/shared/widgets/paginated_list_view.dart';
import 'package:get/get.dart';

class WalletTransactionsView extends GetView<WalletController> {
  const WalletTransactionsView({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return AppScaffold(
      scrollable: false,
      padding: EdgeInsets.zero,
      appBar: CustomAppBar(title: 'transaction_history'.tr),
      body: Obx(() {
        final transactions = controller.activeTransactions;
        final currency = controller.selectedCurrency.value;
        final symbol = controller.activeSymbol;

        if (transactions.isEmpty) {
          return Center(
            child: Text(
              'wallet_empty_hint'.tr,
              style: TextStyle(
                color: scheme.onSurfaceVariant,
                fontSize: 16.scaled,
              ),
            ),
          );
        }

        return CustomScrollView(
          slivers: [
            SliverPadding(
              padding: EdgeInsets.symmetric(
                horizontal: 20.scaled,
                vertical: 8.scaled,
              ),
              sliver: PaginatedSliverList(
                items: transactions,
                isLoadingMore: controller.isLoadingMoreTransactions,
                separatorBuilder: (context, index) {
                  return const SizedBox.shrink();
                },
                itemBuilder: (context, index, tx) {
                  return WalletTransactionTileWidget(
                    tx: tx,
                    currency: currency,
                    symbol: symbol,
                    isFirst: index == 0,
                    isLast: index == transactions.length - 1,
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}
