import 'package:flutter/material.dart';

class ErrorContainer extends StatelessWidget {
  final Widget child;
  const ErrorContainer({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.red, width: 2),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ERROR!',
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
          child,
        ],
      ),
    );
  }
}
