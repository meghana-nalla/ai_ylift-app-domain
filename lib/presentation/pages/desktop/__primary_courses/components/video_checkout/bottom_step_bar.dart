import 'package:flutter/material.dart';

class VideoCheckoutBottomBar extends StatelessWidget {
  final String message;
  final List<Widget> actions;

  const VideoCheckoutBottomBar({
    super.key,
    required this.message,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(message, style: TextStyle(color: Colors.white)),
          Row(mainAxisSize: MainAxisSize.min, spacing: 16, children: actions),
        ],
      ),
    );
  }
}
