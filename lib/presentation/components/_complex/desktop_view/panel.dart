import 'package:YLift/core/constants/constant.dart';
import 'package:flutter/material.dart';

class GalaxyPanel extends StatelessWidget {
  final EdgeInsets padding;
  final EdgeInsets margin;

  final double? width;
  final double? height;
  final Widget child;

  const GalaxyPanel({
    super.key,
    this.padding = const EdgeInsets.all(YLiftConstant.gap),
    this.margin = EdgeInsets.zero,
    this.width,
    this.height,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 4,
          ),
        ],
      ),
      padding: padding,
      margin: margin,
      width: width,
      height: height,
      child: child,
    );
  }
}
