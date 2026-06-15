import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AppFormatter {
  /// Formats a price with a currency symbol.
  /// Standardizes placement (e.g., $10.00 vs 10,000 ៛) and precision.
  static String formatCurrency(double amount, String symbol) {
    final isKhr = symbol == '៛' || symbol.contains('KHR');
    if (isKhr) {
      final formatter = NumberFormat('#,###');
      return '${formatter.format(amount)} $symbol';
    } else {
      final formatter = NumberFormat('#,##0.00');
      return '$symbol${formatter.format(amount)}';
    }
  }

  /// Formats a number with decimals if it's not a whole number.
  static String formatNumber(double amount) {
    if (amount == amount.toInt().toDouble()) {
      return NumberFormat('#,###').format(amount);
    }
    return NumberFormat('#,##0.00').format(amount);
  }

  /// Formats a date to a standard string.
  static String formatDate(DateTime date) {
    final isKhmer = Get.locale?.languageCode == 'km';
    if (isKhmer) {
      return DateFormat('dd/MM/yyyy').format(date);
    }
    return DateFormat('MMM dd, yyyy').format(date);
  }

  /// Formats a date and time to a detailed string
  /// (e.g., 10:30 AM, 15 Jun 2026).
  static String formatDateTime(DateTime date) {
    return DateFormat('hh:mm a, dd MMM yyyy').format(date);
  }
}
