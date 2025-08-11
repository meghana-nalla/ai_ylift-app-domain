import 'package:flutter/material.dart';

class PaymentCardForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController firstName;
  final TextEditingController lastName;
  final TextEditingController streetAddress;
  final TextEditingController city;
  final TextEditingController state;
  final TextEditingController zipCode;
  final TextEditingController country;
  final TextEditingController cardNumber;
  final TextEditingController cardExpireDate;
  final TextEditingController cardCvc;

  const PaymentCardForm({
    super.key,
    required this.formKey,
    required this.firstName,
    required this.lastName,
    required this.streetAddress,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.country,
    required this.cardNumber,
    required this.cardExpireDate,
    required this.cardCvc,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: firstName,
            decoration: const InputDecoration(
              labelText: 'First Name',
            ),
          ),
          TextFormField(
            controller: lastName,
            decoration: const InputDecoration(
              labelText: 'Last Name',
            ),
          ),
          TextFormField(
            controller: streetAddress,
            decoration: const InputDecoration(
              labelText: 'Address',
            ),
          ),
          TextFormField(
            controller: city,
            decoration: const InputDecoration(
              labelText: 'City',
            ),
          ),
          TextFormField(
            controller: state,
            decoration: const InputDecoration(
              labelText: 'State',
            ),
          ),
          TextFormField(
            controller: country,
            decoration: const InputDecoration(
              labelText: 'Country',
            ),
          ),
          TextFormField(
            controller: zipCode,
            decoration: const InputDecoration(
              labelText: 'Zip Code',
            ),
          ),
          TextFormField(
            controller: cardNumber,
            decoration: const InputDecoration(
              labelText: 'Card Number',
            ),
          ),
          TextFormField(
            controller: cardExpireDate,
            decoration: const InputDecoration(
              labelText: 'Expire Date',
              hintText: '10/28',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter expiration date';
              }
              final regexp = RegExp(r'^(0[1-9]|1[0-2])\/\d{2}$');
              final valid = regexp.hasMatch(value);
              if (valid) return null;
              return 'Please enter a valid expiration date';
            },
          ),
          TextFormField(
            controller: cardCvc,
            decoration: const InputDecoration(
              labelText: 'CVC',
            ),
          ),
        ],
      ),
    );
  }
}
