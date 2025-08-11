import 'package:YLift/core/constants/color.dart';
import 'package:flutter/material.dart';

class AddPaymentCardForm extends StatefulWidget {
  final double spacing;
  final Map<String, dynamic> newCard;
  final void Function(Map<String, dynamic> data)? onChanged;

  const AddPaymentCardForm({
    super.key,
    this.spacing = 24,
    required this.newCard,
    this.onChanged,
  });

  @override
  State<AddPaymentCardForm> createState() => _AddPaymentCardFormState();
}

class _AddPaymentCardFormState extends State<AddPaymentCardForm> {
  final formKey = GlobalKey<FormState>();

  bool isBillingSameAsAddress = false;
  void toggleBillingAddress(bool? value) {
    if (value == null) return;
    setState(() {
      isBillingSameAsAddress = value;
    });
  }

  void updateCard(String label, String value) {
    final updatedCard = widget.newCard;
    updatedCard[label] = value;
    widget.onChanged!(updatedCard);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: CardField(
                  name: 'Card Number',
                  onChanged: (value) => updateCard('cardNumber', value),
                ),
              ),
              SizedBox(width: widget.spacing),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: CardField(
                        name: 'MM/YY',
                        onChanged: (value) {
                          final mmyy = value.split('/');
                          final updatedCard = widget.newCard;
                          updatedCard['cardExpMonth'] = int.parse(mmyy.first);
                          updatedCard['cardExpYear'] = int.parse(mmyy.last);
                          widget.onChanged!(updatedCard);
                        },
                      ),
                    ),
                    SizedBox(width: widget.spacing),
                    Expanded(
                      child: CardField(
                        name: 'CVV',
                        onChanged: (value) => updateCard('cardCvc', value),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: widget.spacing),
          Row(
            children: [
              Expanded(
                child: CardField(
                    name: 'Full Name',
                    onChanged: (value) {
                      final names = value.split(' ');
                      final updatedCard = widget.newCard;
                      updatedCard['addressFirstName'] = names.first;
                      updatedCard['addressLastName'] = names.last;
                      widget.onChanged!(updatedCard);
                    }),
              ),
              SizedBox(width: widget.spacing),
              Expanded(
                child: CardField(name: 'Company Name'),
              ),
            ],
          ),
          SizedBox(height: widget.spacing),
          CardField(
            name: 'Address Line 1',
            onChanged: (value) => updateCard('addressLine', value),
          ),
          SizedBox(height: widget.spacing),
          Row(
            children: [
              Expanded(
                child: CardField(name: 'Address Line 2 (Optional)'),
              ),
              SizedBox(width: widget.spacing),
              Expanded(
                child: CardField(
                  name: 'Town/City',
                  onChanged: (value) => updateCard('addressCity', value),
                ),
              ),
            ],
          ),
          SizedBox(height: widget.spacing),
          Row(
            children: [
              Expanded(
                child: CardField(
                  name: 'State',
                  onChanged: (value) => updateCard('addressState', value),
                ),
              ),
              SizedBox(width: widget.spacing),
              Expanded(
                child: CardField(
                  name: 'Zip Code',
                  onChanged: (value) => updateCard('addressZip', value),
                ),
              ),
            ],
          ),
          SizedBox(height: widget.spacing),
          Row(
            children: [
              Checkbox(
                value: isBillingSameAsAddress,
                onChanged: toggleBillingAddress,
              ),
              // SizedBox(width: widget.spacing),
              const Text('Billing address same as shipping'),
            ],
          ),
        ],
      ),
    );
  }
}

class CardField extends StatelessWidget {
  final TextEditingController? controller;
  final String name;
  final void Function(String value)? onChanged;

  const CardField({
    super.key,
    this.controller,
    this.onChanged,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: name,
        labelStyle: const TextStyle(fontSize: 14, color: YLiftColor.grey),
        floatingLabelStyle: const TextStyle(color: YLiftColor.brown),
        hintText: name,
        hintStyle: const TextStyle(color: YLiftColor.grey),
        border: const OutlineInputBorder(),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: YLiftColor.brown, width: 2),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 2),
        ),
        // error: SizedBox.shrink(),
        errorStyle: const TextStyle(height: 0.001, color: Colors.transparent),
      ),
      validator: (value) => value!.isEmpty ? '' : null,
    );
  }
}
