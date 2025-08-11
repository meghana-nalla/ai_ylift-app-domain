import 'package:flutter/material.dart';

class CategorySubNavigationButton extends StatelessWidget {
  final void Function(bool isHovered) onHover;
  const CategorySubNavigationButton({
    super.key,
    required this.onHover,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) {
        onHover(true);
      },
      onExit: (event) {
        onHover(false);
      },
      child: Text(
        'CATEGORIES',
        style: TextStyle(fontSize: 13.33),
      ),
    );
  }
}
