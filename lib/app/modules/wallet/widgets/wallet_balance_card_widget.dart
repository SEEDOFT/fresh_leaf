import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/routes/app_routes.dart';
import 'package:fresh_leaf/shared/helpers/responsive_helper.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class WalletBalanceCardWidget extends StatelessWidget {
  const WalletBalanceCardWidget({
    required this.currency,
    required this.balance,
    required this.symbol,
    super.key,
  });

  final String currency;
  final RxDouble balance;
  final String symbol;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.scaled),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [scheme.primary, scheme.primary.withValues(alpha: 0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24.scaled),
        boxShadow: [
          BoxShadow(
            color: scheme.primary.withValues(alpha: 0.3),
            blurRadius: 15.scaled,
            offset: Offset(0, 8.scaled),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${'current_balance'.tr} ($currency)',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 14.scaled,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8.scaled),
          Obx(
            () => Text(
              currency == 'KHR'
                  ? '${NumberFormat('#,###').format(balance.value)} $symbol'
                  : '$symbol${balance.value.toStringAsFixed(2)}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32.scaled,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 24.scaled),
          ElevatedButton.icon(
            onPressed: () => Get.toNamed<void>(
              AppRoutes.walletTopUp,
              arguments: currency,
            ),
            icon: const Icon(Icons.add_circle_outline),
            label: Text('top_up'.tr),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: scheme.primary,
              padding: EdgeInsets.symmetric(
                horizontal: 24.scaled,
                vertical: 12.scaled,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.scaled),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
