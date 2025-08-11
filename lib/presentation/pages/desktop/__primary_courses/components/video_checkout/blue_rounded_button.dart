import 'package:flutter/material.dart';

class RoundedBlueButton extends StatelessWidget {
  final String label;
  final void Function()? onPressed;
  const RoundedBlueButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: Color(0xFF006AFF),
        disabledBackgroundColor: Colors.grey.shade200,
        disabledForegroundColor: Colors.black54,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      ),
      child: Text(label),
    );
  }
}
