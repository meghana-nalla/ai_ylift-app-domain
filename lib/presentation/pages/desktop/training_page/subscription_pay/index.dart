import 'package:flutter/material.dart';

class SubscriptionPaymentPage extends StatefulWidget {
  const SubscriptionPaymentPage({super.key});
  @override
  State<SubscriptionPaymentPage> createState() =>
      _SubscriptionPaymentPageState();
}

class _SubscriptionPaymentPageState extends State<SubscriptionPaymentPage> {
  String? subscriptionPaymentOption; // 'same', 'change', or 'new'
  String? selectedCard;
  bool cardsLoaded = true;
  bool saving = false;
  bool isSubscriptionPaymentValid = false;

  void handlePaymentOptionChange(String? option) {
    setState(() {
      subscriptionPaymentOption = option;
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

          ],
        ),
      ),
    );
  }
}


