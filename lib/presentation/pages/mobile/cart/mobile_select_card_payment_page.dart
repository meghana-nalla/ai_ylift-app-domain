import 'package:YLift/core/controllers/global.dart';
import 'package:YLift/presentation/components/buttons/line_text_button.dart';
import 'package:YLift/presentation/components/mobile_scaffold.dart';
import 'package:YLift/presentation/pages/mobile/cart/mobile_add_new_card_page.dart';
import 'package:YLift/presentation/pages/mobile/promotion/cart_promotion_page.dart';
import 'package:flutter/material.dart';
import 'package:galaxy_models/galaxy_models.dart';
import 'package:galaxy_ui/galaxy_ui.dart';
import 'package:get/get.dart';

class MobileSelectCardPaymentPage extends StatefulWidget {
  final CardPayment? value;
  final List<CardPayment> cards;

  const MobileSelectCardPaymentPage({
    super.key,
    required this.value,
    required this.cards,
  });

  @override
  State<MobileSelectCardPaymentPage> createState() =>
      _MobileSelectCardPaymentPageState();
}

class _MobileSelectCardPaymentPageState
    extends State<MobileSelectCardPaymentPage> {
  final global = Get.find<GlobalController>();

  final cards = <CardPayment>[];
  CardPayment? selectedCard;

  String? errorMessage;

  void selectCard() {
    if (selectedCard == null) {
      setState(() {
        errorMessage = 'Please select a card';
      });
      return;
    }
    Navigator.pop(context, selectedCard);
  }

  void addNewCard() async {
    await Navigator.push<CardPayment>(
      context,
      MaterialPageRoute(
        builder: (context) => MobileAddNewCardPage(),
      ),
    );

    setState(() {
      final wallet = global.user.value.wallet;
      if (wallet != null) {
        cards.clear();
        cards.addAll(wallet);
        selectedCard = cards.isNotEmpty ? cards.first : null;
      }
    });
  }

  @override
  void initState() {
    cards.addAll(widget.cards);
    selectedCard = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MobileScaffold(
      title: 'Select a card payment',
      onBackPressed: () => Navigator.pop(context),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 16),
            child: LineTextButton(
              onPressed: addNewCard,
              text: 'Add a new card',
              icon: const Icon(Icons.add),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: cards.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final card = cards[index];
                final isSelected = selectedCard?.id == card.id;

                return _CardPaymentTile(
                  card: card,
                  isSelected: isSelected,
                  onSelected: () {
                    setState(() {
                      selectedCard = card;
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomBar: MobileBar(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  errorMessage!,
                  style: TextStyle(color: Colors.red, fontSize: 14),
                ),
              ),
            GalaxyFilledButton(
              backgroundColor: YLiftColor.orange,
              isExpanded: true,
              onPressed: selectCard,
              child: const Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }
}

class _CardPaymentTile extends StatelessWidget {
  final CardPayment card;
  final bool isSelected;
  final void Function() onSelected;

  const _CardPaymentTile({
    super.key,
    required this.card,
    required this.onSelected,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: card.isExpired ? null : onSelected,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          color: card.isExpired ? Colors.grey.shade300 : Colors.white,
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            if (isSelected)
              const Icon(
                Icons.radio_button_checked,
                size: 16,
                color: YLiftColor.orange,
              )
            else
              const Icon(
                Icons.radio_button_unchecked,
                size: 16,
                color: Colors.grey,
              ),
            const SizedBox(width: 16),
            PaymentMarkIcon(card.cardType),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${card.cardType} ending with ${card.last4}',
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    if (card.expirationDate != null)
                      Text(
                        'Expires on ${card.expirationDate!.month}/${card.expirationDate!.year}',
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                        ),
                      ),
                    if (card.isDefault) ...[
                      const SizedBox(width: 8),
                      Icon(
                        Icons.circle,
                        size: 4,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Default',
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
