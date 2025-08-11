import 'package:intl/intl.dart';

extension PriceExtension on num {
  /// Displaying the price in string;
  ///
  /// For example 4000 will be shown as $40.00
  String display() => '\$${(this / 100).toStringAsFixed(2)}';
  String toCurrency() {
    final currencyFormat = NumberFormat.currency(symbol: '\$');
    return currencyFormat.format(this / 100);
  }
}
