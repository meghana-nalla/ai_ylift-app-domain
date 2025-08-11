import 'package:flutter/material.dart';

class TextFieldLabel extends StatelessWidget {
  final String label;
  final double width;
  final Widget child;

  const TextFieldLabel({
    super.key,
    required this.label,
    required this.width,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 12)),
          child,
        ],
      ),
    );
  }
}
