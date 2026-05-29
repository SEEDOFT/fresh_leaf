import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/wallet/controllers/wallet_controller.dart';
import 'package:fresh_leaf/app/modules/wallet/widgets/wallet_balance_card_widget.dart';
import 'package:fresh_leaf/app/modules/wallet/widgets/wallet_transaction_tile_widget.dart';
import 'package:fresh_leaf/shared/helpers/responsive_helper.dart';
import 'package:fresh_leaf/shared/widgets/paginated_list_view.dart';
import 'package:get/get.dart';

class WalletTabContentWidget extends StatelessWidget {
  const WalletTabContentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<WalletController>();
    final scheme = Theme.of(context).colorScheme;

    return RefreshIndicator(
      onRefresh: controller.refreshWallets,
      child: NotificationListener<ScrollNotification>(
        onNotification: (scrollInfo) {
          if (!controller.isLoadingMoreTransactions.value &&
              controller.activeHasMore.value &&
              scrollInfo.metrics.pixels >=
                  scrollInfo.metrics.maxScrollExtent - 200) {
            unawaited(controller.loadMoreTransactions());
          }
          return false;
        },
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Obx(
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
            ),
            SliverToBoxAdapter(
              child: Padding(
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
            ),
            Obx(
              () {
                final transactions = controller.activeTransactions;
                final currency = controller.selectedCurrency.value;
                final symbol = controller.activeSymbol;

                return transactions.isEmpty
                    ? SliverToBoxAdapter(
                        child: Center(
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
                        ),
                      )
                    : SliverPadding(
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
                      );
              },
            ),
          ],
        ),
      ),
    );
  }
}
