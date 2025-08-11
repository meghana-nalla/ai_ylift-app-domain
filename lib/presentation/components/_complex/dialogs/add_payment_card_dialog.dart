import 'package:flutter/material.dart';
import 'package:YLift/presentation/components/_complex/desktop_view/payment_card_form.dart';


class AddPaymentCardDialog extends StatefulWidget {
  final void Function() onAdd;
  const AddPaymentCardDialog({
    super.key,
    required this.onAdd,
  });

  @override
  State<AddPaymentCardDialog> createState() => _AddPaymentCardDialogState();
}

class _AddPaymentCardDialogState extends State<AddPaymentCardDialog> {
  final formKey = GlobalKey<FormState>();
  final cardNumberController = TextEditingController();
  final cardExpireDateController = TextEditingController();
  final cardCvcController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final streetAddressController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final zipCodeController = TextEditingController();
  final countryController = TextEditingController();

  void addCard() {
    final isFormValid = formKey.currentState!.validate();
    if(!isFormValid) return;

    // turn it into [CardInformation] object


  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    streetAddressController.dispose();
    cityController.dispose();
    stateController.dispose();
    zipCodeController.dispose();
    countryController.dispose();
    cardNumberController.dispose();
    cardExpireDateController.dispose();
    cardCvcController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PaymentCardForm(
              formKey: formKey,
              firstName: firstNameController,
              lastName: lastNameController,
              streetAddress: streetAddressController,
              city: cityController,
              state: stateController,
              zipCode: zipCodeController,
              country: countryController,
              cardNumber: cardNumberController,
              cardExpireDate: cardExpireDateController,
              cardCvc: cardCvcController,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: addCard,
                child: const Text('Add card'),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.black,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
