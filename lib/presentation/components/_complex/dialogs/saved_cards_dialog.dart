import 'package:YLift/core/controllers/global.dart';
import 'package:YLift/presentation/components/_complex/tiles/payment_method_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:galaxy_ui/galaxy_ui.dart';
import 'package:galaxy_models/galaxy_models.dart';

class SavedCardsDialog extends StatefulWidget {
  // final CardInformation selectedCard
  const SavedCardsDialog({super.key});

  @override
  State<SavedCardsDialog> createState() => _SavedCardsDialogState();
}

class _SavedCardsDialogState extends State<SavedCardsDialog> {
  void selectSavedCard(CardInformation savedCard) {
    final controller = Get.find<GlobalController>();
    controller.cart.value.checkout?.card = savedCard;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Change Saved Card'),
      content: GetBuilder<GlobalController>(
        builder: (controller) {
          final savedCards = controller.cart.value.cards;
          final selectedCard = controller.cart.value.checkout?.card;

          if (savedCards == null) {
            return const Text('No saved cards');
          }
          return SizedBox(
            width: 400,
            height: 400,
            child: ListView.builder(
              itemCount: savedCards.length,
              itemBuilder: (context, index) {
                final savedCard = savedCards[index];
                final isSelected = selectedCard?.cardNumber == savedCard.cardNumber;
                return ListTile(
                  onTap: () => selectSavedCard(savedCard),
                  leading: const Icon(Icons.credit_card),
                  title: Row(
                    children: [
                      Text(
                        savedCard.cardType,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 16),
                      if (isSelected)
                        Container(
                          decoration: const ShapeDecoration(
                            color: YLiftColor.beige,
                            shape: StadiumBorder(),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          child: const Text('Selected', style: TextStyle(fontSize: 12)),
                        ),
                    ],
                  ),
                  subtitle: Row(
                    children: [
                      Text('Ending in ${savedCard.cardNumber}'),
                      // if (isSelected) ...[
                      //   SizedBox(width: 16),
                      //   Icon(Icons.check, color: Colors.blue),
                      // ]
                    ],
                  ),
                  // trailing: enableDeleteCard
                  //     ? IconButton(
                  //         icon: Icon(Icons.delete),
                  //         onPressed: () => deleteCard(card),
                  //       )
                  //     : Icon(Icons.edit, color: Colors.grey),
                );
              },
            ),
          );
        },
      ),
      actions: [
        YLiftTextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        YLiftFilledButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Select card'),
        ),
      ],
    );
  }
}
