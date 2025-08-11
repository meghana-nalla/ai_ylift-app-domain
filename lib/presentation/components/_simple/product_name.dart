import 'package:flutter/widgets.dart';

class ProductName extends StatelessWidget {
  final String name;
  final double fontSize;
  final bool isBold;

  /// A text widget that displays the name with the following features:
  /// - Maximum of 2 lines
  /// - Ellipsis overflow
  const ProductName(
    this.name, {
    super.key,
    this.fontSize = 16.0,
    this.isBold = true,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      name,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}
