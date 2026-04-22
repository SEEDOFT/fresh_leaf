import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/wallet/controllers/wallet_controller.dart';
import 'package:fresh_leaf/shared/helpers/responsive_helper.dart';
import 'package:intl/intl.dart';

class WalletTransactionTileWidget extends StatelessWidget {
  const WalletTransactionTileWidget({
    required this.tx,
    required this.currency,
    required this.symbol,
    super.key,
  });

  final WalletTransaction tx;
  final String currency;
  final String symbol;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isCredit = tx.isCredit;
    final displayAmount = currency == 'USD'
        ? tx.amount.toStringAsFixed(2)
        : NumberFormat('#,###').format(tx.amount);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 12.scaled,
        vertical: 11.scaled,
      ),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(14.scaled),
        border: Border.all(
          color: scheme.outline.withValues(alpha: 0.12),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.scaled),
            decoration: BoxDecoration(
              color: (isCredit ? Colors.green : Colors.orange).withValues(
                alpha: 0.13,
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isCredit
                  ? Icons.arrow_downward_rounded
                  : Icons.arrow_upward_rounded,
              color: isCredit ? Colors.green.shade600 : Colors.orange.shade700,
              size: 18.scaled,
            ),
          ),
          SizedBox(width: 12.scaled),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tx.title,
                  style: TextStyle(
                    fontSize: 13.scaled,
                    fontWeight: FontWeight.w700,
                    color: scheme.onSurface,
                  ),
                ),
                SizedBox(height: 3.scaled),
                Text(
                  DateFormat('dd MMM yyyy, HH:mm').format(tx.date),
                  style: TextStyle(
                    fontSize: 11.scaled,
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.scaled),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                currency == 'USD'
                    ? '${isCredit ? '+' : '-'}$symbol$displayAmount'
                    : '${isCredit ? '+' : '-'}$displayAmount $symbol',
                style: TextStyle(
                  fontSize: 14.scaled,
                  fontWeight: FontWeight.w700,
                  color: isCredit ? Colors.green.shade700 : scheme.onSurface,
                ),
              ),
              SizedBox(height: 2.scaled),
              Text(
                tx.status,
                style: TextStyle(
                  fontSize: 10.scaled,
                  color: isCredit ? Colors.green.shade700 : scheme.secondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
