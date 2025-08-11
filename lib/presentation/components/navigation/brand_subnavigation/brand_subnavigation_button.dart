import 'package:flutter/material.dart';

class BrandSubNavigationButton extends StatelessWidget {
  final void Function(bool isHovered) onHover;

  const BrandSubNavigationButton({
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
        'BRANDS',
        style: TextStyle(fontSize: 13.33),
      ),
    );
  }
}
