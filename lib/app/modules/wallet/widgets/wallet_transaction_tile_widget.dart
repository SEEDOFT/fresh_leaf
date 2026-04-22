import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/wallet/controllers/wallet_controller.dart';
import 'package:fresh_leaf/shared/helpers/responsive_helper.dart';
import 'package:intl/intl.dart';

class WalletTransactionTileWidget extends StatelessWidget {
  const WalletTransactionTileWidget({
    required this.tx,
    required this.symbol,
    super.key,
  });

  final WalletTransaction tx;
  final String symbol;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isCredit = tx.isCredit;

    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(12.scaled),
          decoration: BoxDecoration(
            color: (isCredit ? Colors.green : Colors.orange)
                .withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            isCredit ? Icons.arrow_downward : Icons.arrow_upward,
            color: isCredit ? Colors.green : Colors.orange,
            size: 20.scaled,
          ),
        ),
        SizedBox(width: 16.scaled),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tx.title,
                style: TextStyle(
                  fontSize: 15.scaled,
                  fontWeight: FontWeight.bold,
                  color: scheme.onSurface,
                ),
              ),
              SizedBox(height: 4.scaled),
              Text(
                DateFormat('dd MMM yyyy, HH:mm').format(tx.date),
                style: TextStyle(
                  fontSize: 12.scaled,
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${isCredit ? '+' : '-'}'
              '${tx.amount % 1 == 0 ? tx.amount.toInt() : tx.amount} $symbol',
              style: TextStyle(
                fontSize: 16.scaled,
                fontWeight: FontWeight.bold,
                color: isCredit ? Colors.green : scheme.onSurface,
              ),
            ),
            SizedBox(height: 4.scaled),
            Text(
              tx.status,
              style: TextStyle(
                fontSize: 11.scaled,
                color: Colors.green,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
