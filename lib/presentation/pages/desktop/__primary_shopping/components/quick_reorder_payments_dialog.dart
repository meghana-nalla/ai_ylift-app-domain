import 'package:YLift/core/controllers/global.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:galaxy_ui/galaxy_ui.dart';
import 'package:galaxy_models/galaxy_models.dart';
class QuickReorderPaymentsDialog extends StatefulWidget {
  final CardPayment? selectedCardPayment;
  final void Function(CardPayment cardPayment) onSelected;

  const QuickReorderPaymentsDialog({
    super.key,
    this.selectedCardPayment,
    required this.onSelected,
  });

  @override
  State<QuickReorderPaymentsDialog> createState() => _QuickReorderPaymentsDialogState();
}

class _QuickReorderPaymentsDialogState extends State<QuickReorderPaymentsDialog> {
  final global = Get.find<GlobalController>();
  late List<CardPayment> cardPayments;
  late CardPayment selectedCard;

  @override
  void initState() {
    cardPayments = global.userCardPayments;
    selectedCard = widget.selectedCardPayment ?? cardPayments.first;
    super.initState();
  }

  void selectCard(CardPayment card) {
    setState(() {
      selectedCard = card;
    });
    widget.onSelected(card);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: SizedBox(
          height: 600,
          width: 900,
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.chevron_left),
                  ),
                  Text('Payment Method'),
                ],
              ),
              Expanded(
                child: ListView.separated(
                  itemCount: cardPayments.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final cardPayment = cardPayments[index];
                    return GestureDetector(
                      onTap: () {
                        selectCard(cardPayment);

                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        child: Row(
                          children: [
                            Radio(
                              value: cardPayment.id,
                              groupValue: selectedCard.id,
                              onChanged: (value) {
                                selectCard(cardPayment);
                              },
                            ),
                            const SizedBox(width: 16),
                            Text('Ending in ****${cardPayment.last4}'),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                width: 200,
                child: RoundedFilledButton(
                  onPressed: () {
                    Navigator.pop(context);

                  },
                  child: const Text('Select & Update'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
