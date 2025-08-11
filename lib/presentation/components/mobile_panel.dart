import 'package:flutter/widgets.dart';

class MobilePanel extends StatelessWidget {
  final double? width;
  final double? height;
  final EdgeInsets? margin;
  final EdgeInsets padding;
  final Color color;

  final List<Widget> children;

  const MobilePanel({
    super.key,
    required this.children,
    this.padding = const EdgeInsets.all(16),
    this.width = double.infinity,
    this.height,
    this.margin,
    this.color = const Color(0xFFFFFFFF),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        color: color,
      ),
      margin: margin,
      width: width,
      height: height,
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}
