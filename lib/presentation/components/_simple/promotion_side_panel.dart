import 'package:YLift/core/constants/color.dart';
import 'package:flutter/material.dart';

class PromotionSidePanel extends StatelessWidget {
  final String title;
  final String? description;
  final List<Widget> children;

  /// This is the base of the side panel for all promotions
  const PromotionSidePanel({
    super.key,
    required this.title,
    this.children = const <Widget>[],
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: <BoxShadow>[
          BoxShadow(color: Colors.grey.shade300, blurRadius: 4),
        ],
      ),
      child: Material(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 16, right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontWeight: FontWeight.w600)),
                  if (description != null)
                    Text(description!, style: TextStyle(fontSize: 11.11)),
                ],
              ),
            ),
            const Divider(height: 16, indent: 16, endIndent: 16),
            ...children,
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class PromotionLearnMoreButton extends StatelessWidget {
  final void Function() onPressed;
  const PromotionLearnMoreButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onPressed,
        child: Text(
          'Learn more >>',
          style: TextStyle(
            fontSize: 11.11,
            color: YLiftColor.orange,
            decoration: TextDecoration.underline,
            decorationColor: YLiftColor.orange,
          ),
        ),
      ),
    );
  }
}
