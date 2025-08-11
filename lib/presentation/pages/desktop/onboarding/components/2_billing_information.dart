
import 'package:YLift/presentation/components/_simple/us_state_dropdown.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:galaxy_ui/galaxy_ui.dart';
import 'package:YLift/core/controllers/global.dart';
import 'package:YLift/presentation/components/_complex/forms/text_form_field.dart';
import 'package:galaxy_models/galaxy_models.dart';

const _countries = <String>['United States', 'Canada'];

class BillingInformationPage extends StatefulWidget {
  final void Function(Map<String, dynamic> formData)? onSubmit;
  final String? errorMessage;
  final void Function(String)? onError;

  const BillingInformationPage({
    super.key,
    this.onSubmit,
    this.errorMessage,
    this.onError,
  });

  @override
  State<BillingInformationPage> createState() => _BillingInformationPageState();
}

class _BillingInformationPageState extends State<BillingInformationPage> {
  final global = Get.find<GlobalController>();

  final _formKey = GlobalKey<FormState>();
  final cardNumber = TextEditingController();
  final cardCvv = TextEditingController();
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final streetAddressController = TextEditingController();
  final suiteController = TextEditingController();
  final cityController = TextEditingController();
  final zipController = TextEditingController();
  final countryController = TextEditingController();

  int? cardExpMonth;
  int? cardExpYear;

  String country = _countries.first;
  USState? usState;

  void setCountry(String? value) {
    if (value == null || value == country) return;
    setState(() {
      country = value;
      usState = null;
    });
  }

  //
  void initializeFields() {
    cardNumber.text = '4111111111111111'; // Standard Visa test number
    cardExpMonth = 12;
    cardCvv.text = '123';
    firstName.text = 'John';
    lastName.text = 'Smith';
    streetAddressController.text = '123 Main Street';
    suiteController.text = 'Suite 100';
    cityController.text = 'New York';
    usState = USState.newYork;
    zipController.text = '10065';
    countryController.text = 'United States';
  }

  bool get isCanada => countryController.text == 'Canada';

  void clearShippingFields() {
    firstName.text = "";
    lastName.text = "";
    streetAddressController.text = "";
    suiteController.text = '';
    cityController.text = "";
    usState = null;
    // stateController.text = "";
    zipController.text = "";
    countryController.text = "";
  }

  /// Form validation logic

  String? errorMessage;

  // error states
  String? cardNumberError;
  String? cardExpMonthError;
  String? cardExpYearError;
  String? cardCvvError;
  String? firstNameError;
  String? lastNameError;
  String? streetError;
  String? cityError;
  String? stateError;
  String? zipError;

  void clearErrors() {
    setState(() {
      cardNumberError = null;
      cardExpMonthError = null;
      cardExpYearError = null;
      cardCvvError = null;
      firstNameError = null;
      lastNameError = null;
      streetError = null;
      cityError = null;
      stateError = null;
      zipError = null;
      errorMessage = null;
    });
  }

  bool validateForm() {
    bool otherForm = true;

    if (cardExpMonth == null) {
      cardExpMonthError = 'Enter a valid exp. month';
      otherForm = false;
    }
    if (cardExpYear == null) {
      cardExpYearError = 'Enter a valid exp. year';
      otherForm = false;
    }

    if (usState == null) {
      stateError = 'Select a state';
      otherForm = false;
    }
    final isFormValid = _formKey.currentState!.validate();
    setState(() {});

    return otherForm && isFormValid;
  }

  void onSubmit() {
    final isFormValid = validateForm();
    if (!isFormValid) return;

    final currentDate = DateTime.now();
    final cardExpDate = DateTime(cardExpYear!, cardExpMonth!);
    if (cardExpDate.year == currentDate.year && cardExpDate.month < currentDate.month) {
      setState(() {
        cardExpMonthError = 'Enter a valid exp. month';
      });
      return;
    }

    final payload = <String, dynamic>{
      'cardNumber': cardNumber.text,
      'cardExpiryMonth': '$cardExpMonth',
      'cardExpiryYear': '$cardExpYear',
      'cardCvv': cardCvv.text,
      'firstName': firstName.text,
      'lastName': lastName.text,
      'name': '${firstName.text} ${lastName.text}',
      'address1': streetAddressController.text,
      'address2': suiteController.text,
      'city': cityController.text,
      'state': usState!.code,
      'zipCode': zipController.text,
      'country': countryController.text,
      'sameAsShipping': false,
      'default': true,
      ///Add new Address Type
      /// Dany requested
      /// 02/07
      'type': 'BILLING'
    };
    widget.onSubmit?.call(payload);
  }

  @override
  void initState() {
    super.initState();
    countryController.text = _countries.first;
    if (kDebugMode) {
      initializeFields();
    }
    final basePayload = global.signUpPayload;
    firstName.text = basePayload['firstName'] ?? '';
    lastName.text = basePayload['lastName'] ?? '';
  }

  @override
  void dispose() {
    cardNumber.dispose();
    cardCvv.dispose();
    streetAddressController.dispose();
    suiteController.dispose();
    cityController.dispose();
    zipController.dispose();
    countryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CardNumberField(
            controller: cardNumber,
          ),
          const SizedBox(height: 16),

          // Expiration Month and Year, CVV Row
          Row(
            children: [
              Expanded(
                child: CardExpYearField(
                  value: cardExpYear,
                  errorText: cardExpYearError,
                  onSelected: (year) {
                    setState(() {
                      cardExpYear = year;
                      cardExpYearError = null;
                      if (cardExpMonth != null) {
                        final currentDate = DateTime.now();
                        final cardExpDate = DateTime(cardExpYear!, cardExpMonth!);
                        if (cardExpDate.year == currentDate.year && cardExpDate.month < currentDate.month) {
                          cardExpMonthError = 'Enter a valid exp. month';
                          return;
                        } else {
                          cardExpMonthError = null;
                        }
                      }
                    });
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CardExpMonthField(
                  value: cardExpMonth,
                  errorText: cardExpMonthError,
                  onSelected: (month) {
                    setState(() {
                      cardExpMonth = month;
                      cardExpMonthError = null;

                      if (cardExpYear != null) {
                        final currentDate = DateTime.now();
                        final cardExpDate = DateTime(cardExpYear!, cardExpMonth!);
                        if (cardExpDate.year == currentDate.year && cardExpDate.month < currentDate.month) {
                          cardExpMonthError = 'Enter a valid exp. month';
                          return;
                        }
                      }
                    });
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CardCvvField(
                  controller: cardCvv,
                  errorText: cardCvvError,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // First Name and Last Name Row
          Row(
            children: [
              Expanded(
                child: YLiftTextFormField(
                  labelText: 'First Name*',
                  controller: firstName,
                  errorText: firstNameError,
                  validator: (value) {
                    if (value?.isEmpty ?? false) return 'Enter your first name';
                    return null;
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: YLiftTextFormField(
                  labelText: 'Last Name*',
                  controller: lastName,
                  errorText: lastNameError,
                  validator: (value) {
                    if (value?.isEmpty ?? false) return 'Enter last name';
                    return null;
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Street Address
          YLiftTextFormField(
            labelText: 'Address Line 1*',
            controller: streetAddressController,
            errorText: streetError,
            validator: (value) {
              if (value?.isEmpty ?? false) return 'Enter your address line 1';
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Suite Number
          YLiftTextFormField(
            labelText: 'Address Line 2 (Optional)',
            controller: suiteController,
          ),
          const SizedBox(height: 16),

          // City, State, and ZIP Code Row
          Row(
            children: [
              Expanded(
                // City must be letters only
                child: YLiftTextFormField(
                  labelText: 'City*',
                  controller: cityController,
                  validator: (value) {
                    if (value?.isEmpty ?? false) return 'Enter a valid city';
                    return null;
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]")),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: UsStateDropdownMenu(
                  value: usState,
                  errorText: stateError,
                  onChanged: (state) {
                    setState(() {
                      usState = state;
                      stateError = null;
                    });
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: YLiftTextFormField(
                  labelText: 'Zip Code*',
                  controller: zipController,
                  maxLength: 5,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    if (value!.length < 5) return 'Enter a valid zip code';
                    return null;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          if (widget.errorMessage != null) ...[
            Center(
              child: Text(
                widget.errorMessage!,
                style: TextStyle(color: YLiftColor.darkOrange),
              ),
            ),
            const SizedBox(height: 16),
          ],

          SizedBox(
            width: double.infinity,
            child: RoundedFilledButton(
              onPressed: onSubmit,
              child: const Text('Proceed to Step 3'),
            ),
          ),
        ],
      ),
    );
  }
}