import 'package:YLift/core/constants/text_style.dart';
import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  final String labelText;
  final Color iconColor;
  const SectionTitle({
    super.key,
    required this.labelText,
    this.iconColor = Colors.red,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: iconColor,
            borderRadius: const BorderRadius.all(Radius.circular(2)),
          ),
          width: 16,
          height: 32,
        ),
        const SizedBox(width: 16),
        Text(labelText, style: YLiftTextStyle.title),
      ],
    );
  }
}
