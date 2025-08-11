import 'package:flutter/material.dart';

class LineTextButton extends StatelessWidget {
  final void Function() onPressed;
  final Icon? icon;
  final String text;

  final double fontSize;
  final Color textColor;
  final bool isUnderlined;

  const LineTextButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.fontSize = 12.0,
    this.textColor = Colors.blue,
    this.isUnderlined = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null)
            Padding(
              padding: const EdgeInsets.only(right: 4.0),
              child: IconTheme(data: IconThemeData(color: textColor, size: 14), child: icon!),
            ),
          Text(
            text,
            style: TextStyle(
              color: textColor,
              decoration: isUnderlined ? TextDecoration.underline : null,
              fontSize: fontSize,
            ),
          ),
        ],
      ),
    );
  }
}
