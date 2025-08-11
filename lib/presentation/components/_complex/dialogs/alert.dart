import 'package:flutter/material.dart';

class YLiftAlertDialog {
  static void show(
      BuildContext context, {
        required String title,
        required String message,
        List<Widget>? actions,
      }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return YLiftAlertDialogWidget(
          title: title,
          message: message,
          additionalActions: actions,
        );
      },
    );
  }
}

class YLiftAlertDialogWidget extends StatelessWidget {
  final String title;
  final String message;
  final List<Widget>? additionalActions;

  const YLiftAlertDialogWidget({
    super.key,
    required this.title,
    required this.message,
    this.additionalActions,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(message),
        ],
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
        if (additionalActions != null) ...additionalActions!,
      ],
    );
  }
}