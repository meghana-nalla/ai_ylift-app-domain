import 'package:flutter/material.dart';

class AnimatedRouteDisplay extends StatelessWidget {
  final String parentRoute;
  final String childRoute;

  const AnimatedRouteDisplay({
    Key? key,
    required this.parentRoute,
    required this.childRoute,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color textColor = colorScheme.surface; // inverse of onSurface

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: colorScheme.onSurface,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            parentRoute,
            style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
          ),
          AnimatedSize(
            duration: Duration(milliseconds: 300),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.arrow_right, color: textColor),
                Text(
                  childRoute,
                  style: TextStyle(color: textColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}