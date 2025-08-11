import 'package:flutter/material.dart';

class YLiftFormErrorDialog extends StatelessWidget {
  final String? errorMessage;
  const YLiftFormErrorDialog({
    super.key,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,  // Or whatever fixed height you want
      child: Center(
        child: errorMessage != null
            ? Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            errorMessage!,
            style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        )
            : null,
      ),
    );
  }
}
