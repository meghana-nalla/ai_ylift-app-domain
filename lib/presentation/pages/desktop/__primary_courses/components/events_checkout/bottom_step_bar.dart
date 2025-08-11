// import 'package:flutter/material.dart';

part of 'event_checkout_dialog.dart';

class BottomStepBar extends StatelessWidget {
  final EventsCheckoutStep step;
  final List<Widget> actions;
  final String? extraMessage;
  const BottomStepBar({super.key, required this.step, required this.actions, this.extraMessage});

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
          Text(extraMessage ?? step.stepMessage, style: TextStyle(color: Colors.white)),
          Row(mainAxisSize: MainAxisSize.min, spacing: 16, children: actions),
        ],
      ),
    );
  }
}
