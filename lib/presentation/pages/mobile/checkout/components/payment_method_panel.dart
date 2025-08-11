import 'package:YLift/presentation/components/buttons/line_text_button.dart';
import 'package:YLift/presentation/components/mobile_panel.dart';
import 'package:YLift/presentation/pages/mobile/cart/mobile_select_card_payment_page.dart';
import 'package:flutter/material.dart';
import 'package:galaxy_models/galaxy_models.dart';

class MobilePaymentMethodPanel extends StatelessWidget {
  final CardPayment? cardPayment;
  final List<CardPayment> cards;
  final void Function(CardPayment card) onCardChanged;

  const MobilePaymentMethodPanel({
    super.key,
    this.cardPayment,
    this.cards = const <CardPayment>[],
    required this.onCardChanged,
  });

  @override
  Widget build(BuildContext context) {
    return MobilePanel(
      children: [
        Text(
          cardPayment != null
              ? 'Paying with Mastercard ${cardPayment!.last4}'
              : 'Select a card to pay',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (cardPayment != null && cardPayment!.isExpired) ...const [
          SizedBox(height: 4),
          Text(
            'Card is expired, please select other payment method.',
            style: TextStyle(fontSize: 12, color: YLiftColor.orange),
          ),
        ],
        const SizedBox(height: 4),
        LineTextButton(
          onPressed: () async {
            final selectedCard = await Navigator.push<CardPayment>(
              context,
              MaterialPageRoute(
                builder:
                    (context) => MobileSelectCardPaymentPage(
                      value: cardPayment,
                      cards: cards,
                    ),
              ),
            );
            if (selectedCard == null) return;
            onCardChanged(selectedCard);
          },
          text: 'Change payment method',
        ),
      ],
    );
  }
}
