import 'package:YLift/presentation/components/_simple/us_state_dropdown.dart';
import 'package:galaxy_models/galaxy_models.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:galaxy_ui/galaxy_ui.dart';
import 'package:YLift/core/controllers/global.dart';
import 'package:YLift/presentation/components/_complex/forms/text_form_field.dart';

const _countries = <String>['United States', 'Canada'];

class RequireCardPaymentPage extends StatefulWidget {
  const RequireCardPaymentPage({
    super.key,
  });

  @override
  State<RequireCardPaymentPage> createState() => _RequireCardPaymentPageState();
}

class _RequireCardPaymentPageState extends State<RequireCardPaymentPage> {
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

  bool isAddingCard = false;

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
    cityController.text = 'Helena';
    usState = USState.montana;
    zipController.text = '59601';
    countryController.text = 'United States';
    usState = USState.values.first;
  }

  bool get isCanada => countryController.text == 'Canada';

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

  Future<void> addCard() async {
    try {
      setState(() {
        isAddingCard = true;
        errorMessage = null;
      });

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

      final address = AddressSimple(
        line1: streetAddressController.text,
        city: cityController.text,
        state: usState!.code,
        zip: zipController.text,
        phone: '',
        createdAt: DateTime.now(),
      );

      final expiryMonth = '$cardExpMonth'.padLeft(2, '0');

      final payload = <String, dynamic>{
        'cardNumber': cardNumber.text,
        'expirationDate': '$cardExpYear-$expiryMonth',
        'nameFirst': firstName.text,
        'nameLast': lastName.text,
        'address': address.display,
        'city': cityController.text,
        'state': usState!.code,
        'zip': zipController.text,
        'phoneNumber': '',
        'customerProfileId': global.user.value.customerId,
        'default': true,
        'country': 'US',
      };

      final response = await global.userProfile.addUserPaymentCard(payload: payload);
      global.userProfile.fetchProfile();
      if (response.isSuccess) {
        global.vroute.navigateTo('/shop');
      } else {
        setState(() {
          isAddingCard = false;
          errorMessage = response.message;
        });
      }
    } catch (e) {
      print('$e');
    } finally {
      setState(() {
        isAddingCard = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    if (global.isAuthenticated.isFalse || global.user.value.hasCardPayment) {
      global.vroute.navigateTo('/shop');
    }
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
    return Scaffold(
      body: SizedBox(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SizedBox(
                width: double.infinity,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: Column(
                    children: [
                      SizedBox(
                        width: 640,
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Card Payment Required', style: TextStyle(fontSize: 23)),
                              Text(
                                'Before accessing Y Lift Store, your account needs to have at least one active card payment',
                                style: TextStyle(fontSize: 13.33),
                              ),
                              const SizedBox(height: 32),
                              CardNumberField(controller: cardNumber),
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
                              if (errorMessage != null)
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Text(
                                    errorMessage!,
                                    style: TextStyle(color: YLiftColor.orange),
                                  ),
                                ),
                              SizedBox(
                                width: double.infinity,
                                child: RoundedFilledButton(
                                  onPressed: isAddingCard ? null : addCard,
                                  child: const Text('Add card payment'),
                                ),
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton(
                                  onPressed: () {
                                    global.auth.processLogout();
                                  },
                                  child: const Text('Log out'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildHeader() {
  return ColoredBox(
    color: Colors.black,
    child: SizedBox(
      height: 54,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text('Y LIFT STORE', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    ),
  );
}
