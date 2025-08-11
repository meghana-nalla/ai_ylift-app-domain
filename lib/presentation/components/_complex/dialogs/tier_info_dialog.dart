import 'package:flutter/material.dart';

class TierDialog extends StatelessWidget {
  const TierDialog({
    super.key
  });

  static void show (BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return TierDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Product Unavailable at Current Tier'),
      content: const Text('To learn how to unlock exclusive pricing on this product, please contact the Y Lift Store.'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();  // Close the dialog
          },
          child: const Text('Close'),
        ),
      ],
    );
  }
}