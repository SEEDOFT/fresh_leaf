import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/wallet/controllers/wallet_controller.dart';
import 'package:fresh_leaf/app/modules/wallet/widgets/wallet_tab_content_widget.dart';
import 'package:fresh_leaf/shared/helpers/responsive_helper.dart';
import 'package:fresh_leaf/shared/widgets/app_scaffold.dart';
import 'package:fresh_leaf/shared/widgets/custom_app_bar.dart';
import 'package:get/get.dart';

class WalletView extends GetView<WalletController> {
  const WalletView({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return AppScaffold(
      scrollable: false,
      appBar: const CustomAppBar(
        title: 'my_wallet',
      ),
      body: Column(
        children: [
          ColoredBox(
            color: scheme.surface,
            child: TabBar(
              controller: controller.tabController,
              indicatorColor: scheme.primary,
              labelColor: scheme.primary,
              unselectedLabelColor: scheme.onSurfaceVariant,
              labelStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14.scaled,
              ),
              tabs: const [
                Tab(text: 'KHR'),
                Tab(text: 'USD'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: controller.tabController,
              children: [
                WalletTabContentWidget(
                  currency: 'KHR',
                  balance: controller.khrBalance,
                  transactions: controller.khrTransactions,
                  symbol: '៛',
                ),
                WalletTabContentWidget(
                  currency: 'USD',
                  balance: controller.usdBalance,
                  transactions: controller.usdTransactions,
                  symbol: r'$',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
