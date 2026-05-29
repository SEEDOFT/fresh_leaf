import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/wallet/controllers/wallet_controller.dart';
import 'package:fresh_leaf/shared/helpers/helper.dart';
import 'package:fresh_leaf/shared/helpers/responsive_helper.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class WalletTransactionTileWidget extends StatelessWidget {
  const WalletTransactionTileWidget({
    required this.tx,
    required this.currency,
    required this.symbol,
    this.isFirst = false,
    this.isLast = false,
    super.key,
  });

  final WalletTransaction tx;
  final String currency;
  final String symbol;
  final bool isFirst;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isCredit = tx.isCredit;
    final displayAmount = currency == 'USD'
        ? formatPrice(tx.amount)
        : NumberFormat('#,###').format(tx.amount);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Timeline vertical layout
          SizedBox(
            width: 32.scaled,
            child: Column(
              children: [
                Expanded(
                  child: isFirst
                      ? const SizedBox.shrink()
                      : Container(
                          width: 2.scaled,
                          color: scheme.outlineVariant.withValues(alpha: 0.5),
                        ),
                ),
                Container(
                  width: 28.scaled,
                  height: 28.scaled,
                  margin: EdgeInsets.symmetric(vertical: 4.scaled),
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
                    color: isCredit
                        ? Colors.green.shade600
                        : Colors.orange.shade700,
                    size: 16.scaled,
                  ),
                ),
                Expanded(
                  child: isLast
                      ? const SizedBox.shrink()
                      : Container(
                          width: 2.scaled,
                          color: scheme.outlineVariant.withValues(alpha: 0.5),
                        ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.scaled),
          // Transaction Card
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                top: isFirst ? 0 : 4.scaled,
                bottom: isLast ? 0 : 4.scaled,
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(14.scaled),
                  onTap: () =>
                      _showTransactionDetails(context, scheme, displayAmount),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.scaled,
                      vertical: 11.scaled,
                    ),
                    decoration: BoxDecoration(
                      color: scheme.surfaceContainerHighest.withValues(
                        alpha: 0.3,
                      ),
                      borderRadius: BorderRadius.circular(14.scaled),
                      border: Border.all(
                        color: scheme.outline.withValues(alpha: 0.12),
                      ),
                    ),
                    child: Row(
                      children: [
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
                                formatDateTime(tx.date),
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
                                  ? '${isCredit ? '+' : '-'}'
                                      '$symbol$displayAmount'
                                  : '${isCredit ? '+' : '-'}'
                                      '$displayAmount $symbol',
                              style: TextStyle(
                                fontSize: 14.scaled,
                                fontWeight: FontWeight.w700,
                                color: isCredit
                                    ? Colors.green.shade700
                                    : scheme.onSurface,
                              ),
                            ),
                            SizedBox(height: 2.scaled),
                            Text(
                              tx.status,
                              style: TextStyle(
                                fontSize: 10.scaled,
                                color: switch (tx.statusId) {
                                  1 => Colors.orange.shade700, // Pending
                                  3 => scheme.error, // Failed
                                  4 => scheme.secondary, // Cancelled
                                  _ =>
                                    isCredit
                                        ? Colors.green.shade700
                                        : scheme.secondary, // Completed
                                },
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showTransactionDetails(
    BuildContext context,
    ColorScheme scheme,
    String displayAmount,
  ) {
    final isCredit = tx.isCredit;
    final amountText = currency == 'USD'
        ? '${isCredit ? '+' : '-'}$symbol$displayAmount'
        : '${isCredit ? '+' : '-'}$displayAmount $symbol';
    final amountColor = isCredit ? Colors.green.shade700 : scheme.onSurface;

    unawaited(
      Get.bottomSheet<void>(
        Container(
          decoration: BoxDecoration(
            color: scheme.surface,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(24.scaled),
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(24.scaled),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 40.scaled,
                      height: 4.scaled,
                      margin: EdgeInsets.only(bottom: 20.scaled),
                      decoration: BoxDecoration(
                        color: scheme.onSurfaceVariant.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(2.scaled),
                      ),
                    ),
                  ),
                  Text(
                    'transaction_details'.tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18.scaled,
                      fontWeight: FontWeight.bold,
                      color: scheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 24.scaled),
                  Container(
                    padding: EdgeInsets.all(16.scaled),
                    decoration: BoxDecoration(
                      color: scheme.surfaceContainerHighest.withValues(
                        alpha: 0.3,
                      ),
                      borderRadius: BorderRadius.circular(12.scaled),
                    ),
                    child: Column(
                      children: [
                        Text(
                          amountText,
                          style: TextStyle(
                            fontSize: 24.scaled,
                            fontWeight: FontWeight.w800,
                            color: amountColor,
                          ),
                        ),
                        SizedBox(height: 4.scaled),
                        Text(
                          tx.status,
                          style: TextStyle(
                            fontSize: 14.scaled,
                            fontWeight: FontWeight.w600,
                            color: switch (tx.statusId) {
                              1 => Colors.orange.shade700,
                              3 => scheme.error,
                              4 => scheme.secondary,
                              _ =>
                                isCredit
                                    ? Colors.green.shade700
                                    : scheme.secondary,
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.scaled),
                  _DetailRow(
                    label: 'transaction_id'.tr,
                    value: '#${tx.id}',
                    scheme: scheme,
                  ),
                  SizedBox(height: 12.scaled),
                  _DetailRow(
                    label: 'type'.tr,
                    value: tx.title,
                    scheme: scheme,
                  ),
                  SizedBox(height: 12.scaled),
                  _DetailRow(
                    label: 'date'.tr,
                    value: formatDateTime(tx.date),
                    scheme: scheme,
                  ),
                ],
              ),
            ),
          ),
        ),
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    required this.value,
    required this.scheme,
  });

  final String label;
  final String value;
  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13.scaled,
            color: scheme.onSurfaceVariant,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13.scaled,
            fontWeight: FontWeight.w600,
            color: scheme.onSurface,
          ),
        ),
      ],
    );
  }
}
