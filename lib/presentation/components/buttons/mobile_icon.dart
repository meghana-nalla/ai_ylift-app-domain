import 'package:flutter/material.dart';

class MobileIcon extends StatelessWidget {
  final IconData icon;
  final void Function()? onPressed;

  final Color? color;

  const MobileIcon({
    super.key,
    required this.onPressed,
    required this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon),
      iconSize: 20,
      color: color,
      padding: EdgeInsets.zero,
      constraints: BoxConstraints(
        minHeight: 28,
        minWidth: 28,
      ),
    );
  }
}
