import 'package:YLift/core/controllers/global.dart';
import 'package:flutter/material.dart';
import 'package:galaxy_models/galaxy_models.dart';
import 'package:get/get.dart';

class RemoveCardPaymentDialog extends StatefulWidget {
  final CardPayment card;

  const RemoveCardPaymentDialog({
    super.key,
    required this.card,
  });

  @override
  State<RemoveCardPaymentDialog> createState() =>
      _RemoveCardPaymentDialogState();
}

class _RemoveCardPaymentDialogState extends State<RemoveCardPaymentDialog> {
  final global = Get.find<GlobalController>();
  bool isLoading = false;
  String? errorMessage;

  void removeCard() async {
    try {
      setState(() {
        isLoading = true;
      });
      await global.userController.deleteCardPayment(widget.card.id);
      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to delete card payment, please try again later.';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      insetPadding: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Remove ${widget.card.cardType} ending with ${widget.card.last4}?',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'This action cannot be undone. Are you sure you want to remove this card from your saved wallets?',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 24),
            if (errorMessage != null)
              Text(
                errorMessage!,
                style: TextStyle(color: Colors.red),
              ),
            isLoading
                ? const CircularProgressIndicator()
                : OverflowBar(
                  alignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        minimumSize: Size.zero,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        foregroundColor: Colors.black,
                        textStyle: const TextStyle(
                          fontSize: 14,
                          letterSpacing: 1,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'),
                    ),

                    TextButton(
                      style: TextButton.styleFrom(
                        minimumSize: Size.zero,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        foregroundColor: Colors.black,
                        textStyle: const TextStyle(
                          fontSize: 14,
                          letterSpacing: 1,
                        ),
                      ),
                      onPressed: removeCard,
                      child: const Text('Remove'),
                    ),
                  ],
                ),
          ],
        ),
      ),
    );
  }
}
