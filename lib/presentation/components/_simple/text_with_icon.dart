import 'package:flutter/material.dart';

class TextWithIcon extends StatelessWidget {
  final Widget icon;
  final String text;
  final TextStyle? style;
  const TextWithIcon({
    super.key,
    required this.icon,
    required this.text,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        icon,
        const SizedBox(width: 8),
        Expanded(
          child: Text(text, style: style),
        ),
      ],
    );
  }
}
