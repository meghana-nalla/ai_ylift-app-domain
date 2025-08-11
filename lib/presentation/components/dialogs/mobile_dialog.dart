import 'package:YLift/presentation/components/buttons/mobile_icon.dart';
import 'package:flutter/material.dart';

class MobileDialog extends StatelessWidget {
  final Widget title;
  final Widget content;

  const MobileDialog({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      insetPadding: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DefaultTextStyle(
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    child: title,
                  ),
                  MobileIcon(
                    onPressed: () => Navigator.pop(context),
                    icon: Icons.close,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: content,
            ),
          ],
        ),
      ),
    );
  }
}
