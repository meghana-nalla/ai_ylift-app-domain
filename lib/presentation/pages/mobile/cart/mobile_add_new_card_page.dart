import 'package:YLift/core/controllers/global.dart';
import 'package:YLift/presentation/components/_simple/us_state_dropdown.dart';
import 'package:YLift/presentation/components/mobile_scaffold.dart';
import 'package:YLift/presentation/components/z-index_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:galaxy_models/galaxy_models.dart';
import 'package:galaxy_ui/galaxy_ui.dart';
import 'package:get/get.dart';

class MobileAddNewCardPage extends StatefulWidget {
  const MobileAddNewCardPage({super.key});

  @override
  State<MobileAddNewCardPage> createState() => _MobileAddNewCardPageState();
}

class _MobileAddNewCardPageState extends State<MobileAddNewCardPage> {
  final paymentController = PaymentFormController();
  final _formKey = GlobalKey<FormState>();

  String? cardExpYearError;
  String? cardExpMonthError;
  USState? usState;

  String? usStateError;

  bool isLoading = false;

  bool validateForm() {
    bool isValid = true;

    if (usState == null) {
      setState(() {
        usStateError = 'Select a state';
      });
      isValid = false;
    } else {
      setState(() {
        usStateError = null;
      });
    }

    final isFormValid = _formKey.currentState?.validate() ?? false;
    return isValid && isFormValid;
  }

  Future<void> saveCard() async {
    try {
      setState(() {
        isLoading = true;
      });
      final isFormValid = validateForm();
      if (!isFormValid) return;

      final global = Get.find<GlobalController>();

      final address = AddressSimple(
        line1: paymentController.streetAddressController.text,
        city: paymentController.cityController.text,
        state: usState!.code,
        zip: paymentController.zipController.text,
        phone: '',
        createdAt: DateTime.now(),
      );

      // Format expiry month with leading zero
      final expiryMonth = '${paymentController.cardExpiryMonth}'.padLeft(
        2,
        '0',
      );

      // Construct payload
      final payload = <String, dynamic>{
        'cardNumber': paymentController.cardNumberController.text,
        'expirationDate': '${paymentController.cardExpiryYear}-$expiryMonth',
        'nameFirst': paymentController.firstName.text,
        'nameLast': paymentController.lastName.text,
        'address': address.display,
        'city': paymentController.cityController.text,
        'state': usState!.code,
        'zip': paymentController.zipController.text,
        'phoneNumber': '',
        'customerProfileId': global.user.value.customerId,
        'default': true,
        'country': 'US',
      };

      await global.userProfile.addUserPaymentCard(payload: payload);
      final last4 = paymentController.cardNumberController.text.substring(
        paymentController.cardNumberController.text.length - 4,
      );
      final addedCardPayment = global.user.value.wallet!.firstWhereOrNull(
        (element) => element.last4 == last4,
      );

      if (!mounted) return;
      Navigator.pop(context, addedCardPayment);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding card: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    paymentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MobileScaffold(
      title: 'Add a new card',
      onBackPressed: isLoading ? null : () => Navigator.pop(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CardNumberField(
                controller: paymentController.cardNumberController,
              ),
              const SizedBox(height: 16),

              // Expiration Month and Year, CVV Row
              Row(
                children: [
                  Expanded(
                    child: CardExpYearField(
                      value: paymentController.cardExpiryYear,
                      errorText: cardExpYearError,
                      onSelected: (year) {
                        setState(() {
                          paymentController.cardExpiryYear = year;
                          final newDate = DateTime(
                            year,
                            paymentController.cardExpiryMonth,
                          );
                          final currentDate = DateTime.now();
                          if (newDate.year <= currentDate.year &&
                              newDate.month < currentDate.month) {
                            cardExpYearError = 'Enter a valid exp. year';
                          } else {
                            cardExpYearError = null;
                            cardExpMonthError = null;
                          }
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CardExpMonthField(
                      value: paymentController.cardExpiryMonth,
                      errorText: cardExpMonthError,
                      onSelected: (month) {
                        setState(() {
                          paymentController.cardExpiryMonth = month;
                          final newDate = DateTime(
                            paymentController.cardExpiryYear,
                            month,
                          );
                          final currentDate = DateTime.now();
                          if (newDate.year <= currentDate.year &&
                              newDate.month < currentDate.month) {
                            cardExpMonthError = 'Enter a valid exp. month';
                          } else {
                            cardExpYearError = null;
                            cardExpMonthError = null;
                          }
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CardCvvField(
                      controller: paymentController.cardCvv,
                      // TODO: Enable withIcon in galaxy_ui
                      // withIcon: false,
                      // errorText: cardCvvError,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // First Name and Last Name Row
              Row(
                children: [
                  Expanded(
                    child: YLiftTextFormField(
                      labelText: 'First Name',
                      controller: paymentController.firstName,
                      // errorText: firstNameError,
                      maxLength: 25,
                      validator: (value) {
                        if (value?.isEmpty ?? false) {
                          return 'Enter your first name';
                        }
                        return null;
                      },
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp("[a-zA-Z ]"),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: YLiftTextFormField(
                      labelText: 'Last Name',
                      controller: paymentController.lastName,
                      // errorText: lastNameError,
                      maxLength: 25,
                      validator: (value) {
                        if (value?.isEmpty ?? false) {
                          return 'Enter last name';
                        }
                        return null;
                      },
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp("[a-zA-Z ]"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Street Address
              YLiftTextFormField(
                labelText: 'Address Line 1',
                controller: paymentController.streetAddressController,
                // errorText: streetError,
                maxLength: 25,
                validator: (value) {
                  if (value?.isEmpty ?? false) {
                    return 'Enter your address line 1';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Suite Number
              YLiftTextFormField(
                maxLength: 25,
                labelText: 'Address Line 2 (Optional)',
                controller: paymentController.suiteController,
              ),
              const SizedBox(height: 8),

              YLiftTextFormField(
                labelText: 'City',
                controller: paymentController.cityController,
                maxLength: 20,
                validator: (value) {
                  if (value?.isEmpty ?? false) {
                    return 'Enter a valid city';
                  }
                  return null;
                },
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp("[a-zA-Z ]"),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // City, State, and ZIP Code Row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: UsStateDropdownMenu(
                      labelText: 'State',
                      value: usState,
                      errorText: usStateError,
                      onChanged: (state) {
                        setState(() {
                          usState = state;
                          usStateError = null;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ZipCodeField(
                      controller: paymentController.zipController,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomBar: MobileBar(
        padding: const EdgeInsets.all(16),
        child: GalaxyFilledButton(
          backgroundColor: YLiftColor.orange,
          isExpanded: true,
          onPressed: isLoading ? null : saveCard,
          child: const Text('Add Card'),
        ),
      ),
    );
  }
}
