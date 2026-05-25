import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/wallet/controllers/wallet_controller.dart';
import 'package:fresh_leaf/app/routes/app_routes.dart';
import 'package:fresh_leaf/shared/helpers/helper.dart';
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
    final controller = Get.find<WalletController>();
    final scheme = Theme.of(context).colorScheme;
    final isUsd = currency == 'USD';

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.scaled),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            scheme.primary,
            Color.alphaBlend(
              scheme.tertiary.withValues(alpha: 0.22),
              scheme.primary.withValues(alpha: 0.9),
            ),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24.scaled),
        boxShadow: [
          BoxShadow(
            color: scheme.primary.withValues(alpha: 0.16),
            blurRadius: 16.scaled,
            offset: Offset(0, 8.scaled),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'current_balance'.tr,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.86),
                  fontSize: 13.scaled,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 10.scaled,
                  vertical: 5.scaled,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  currency,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11.scaled,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.35,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.scaled),
          Obx(
            () {
              final isVisible = controller.isBalanceVisible.value;
              final amountText = isUsd
                  ? '$symbol${formatPrice(balance.value)}'
                  : '${NumberFormat('#,###').format(balance.value)} $symbol';
              final hiddenText = isUsd ? '$symbol••••••' : '•••••• $symbol';
              return Text(
                isVisible ? amountText : hiddenText,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32.scaled,
                  fontWeight: FontWeight.w800,
                  height: 1.05,
                ),
              );
            },
          ),
          SizedBox(height: 6.scaled),
          Text(
            '${'wallet_currency'.tr}: $currency',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 11.scaled,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 18.scaled),
          Row(
            children: [
              FilledButton.icon(
                onPressed: () => Get.toNamed<void>(
                  AppRoutes.walletTopUp,
                  arguments: currency,
                ),
                icon: Icon(
                  Icons.add_circle_outline,
                  size: 18.scaled,
                ),
                label: Text('top_up'.tr),
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: scheme.primary.withValues(alpha: 0.95),
                  padding: EdgeInsets.symmetric(
                    horizontal: 18.scaled,
                    vertical: 10.scaled,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.scaled),
                  ),
                  elevation: 0,
                ),
              ),
              const Spacer(),
              Obx(
                () {
                  final isVisible = controller.isBalanceVisible.value;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    curve: Curves.easeOutCubic,
                    decoration: BoxDecoration(
                      color: isVisible
                          ? Colors.white.withValues(alpha: 0.2)
                          : Colors.white.withValues(alpha: 0.34),
                      borderRadius: BorderRadius.circular(12.scaled),
                      border: Border.all(
                        color: isVisible
                            ? Colors.white.withValues(alpha: 0.24)
                            : Colors.white.withValues(alpha: 0.5),
                      ),
                    ),
                    child: IconButton(
                      onPressed: controller.toggleBalanceVisibility,
                      icon: Icon(
                        isVisible
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: isVisible
                            ? Colors.white
                            : scheme.primary.withValues(alpha: 0.95),
                        size: 20.scaled,
                      ),
                      tooltip: isVisible ? 'Hide balance' : 'Show balance',
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
