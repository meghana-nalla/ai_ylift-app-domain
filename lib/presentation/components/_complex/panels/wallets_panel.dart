import 'package:YLift/core/controllers/global.dart';
import 'package:YLift/presentation/components/_simple/us_state_dropdown.dart';
import 'package:YLift/presentation/components/buttons/line_text_button.dart';
import 'package:YLift/presentation/components/z-index_export.dart';
import 'package:YLift/presentation/components/_complex/forms/text_form_field.dart';
import 'package:YLift/presentation/components/_complex/tiles/payment_method_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:galaxy_ui/galaxy_ui.dart';
import 'package:galaxy_models/galaxy_models.dart';

class WalletsPanel extends StatefulWidget {
  const WalletsPanel({super.key});

  @override
  State<WalletsPanel> createState() => _WalletsPanelState();
}

class _WalletsPanelState extends State<WalletsPanel>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  final GlobalController global = Get.find<GlobalController>();
  late List<CardPayment> cardPayments;
  int selectedIndex = 0;

  String? errorMessage;

  void deleteCreditCard(String cardID) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: Text("Are you sure that you want to delete it?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
            IconButton(
              onPressed: () async {
                await global.userController.deleteCardPayment(cardID);
                Navigator.pop(context);
              },
              icon: const Text('Yes'), //const Icon(Icons.delete_forever),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (errorMessage != null) {
      return Text('Error with getting your payment cards\n$errorMessage');
    }
    if (global.user.value.wallet!.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('No payment methods found'),
          const GapY(),
          YLiftFilledButton(
            child: const Text('Add New Payment Method'),
            onPressed: () {
              showDialog<CardPayment>(
                context: context,
                builder: (context) {
                  return CardPaymentDialog(
                    updateWalletPanel: () {
                      // setState(() {
                      //   cardPayments = global.userCardPayments;
                      // });
                    },
                  );
                },
              );
            },
          ),
        ],
      );
    }
    return Obx(() {
      return Column(
        children: [
          StoreCreditPanel(),
          ExpansionTile(
            shape: const Border(),
            initiallyExpanded: true,
            title: const Text('Payment Cards'),
            children: List.generate(global.user.value.wallet!.length, (index) {
              final card = global.user.value.wallet![index];

              return Column(
                children: [
                  PaymentMethodTile(
                    paymentIcon: PaymentMarkIcon(card.cardType),
                    expirationDate: card.expirationDate,
                    isSelected: selectedIndex == index,
                    methodName: '${card.cardType} ending in ****${card.last4}',
                    onSelected: () {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    delete:
                        !card.isDefault
                            ? TextButton(
                              onPressed: () {
                                //global.userController.deleteCardPayment(card.id);
                                deleteCreditCard(card.id);
                              },
                              child: const Icon(Icons.delete),
                            )
                            : null,
                    // edit: TextButton(
                    //   onPressed: () {
                    //     showDialog<CardPayment>(
                    //       context: context,
                    //       builder: (context) {
                    //         return CardPaymentDialog(
                    //           updateWalletPanel: () {
                    //             setState(() {
                    //               cardPayments = global.userCardPayments;
                    //             });
                    //           },
                    //         );
                    //       },
                    //     );
                    //   },
                    //   child: const Icon(Icons.edit),
                    // ),
                    trailing:
                        card.isDefault
                            ? const DefaultIcon()
                            : TextButton(
                              onPressed: () {
                                global.userController.setDefaultCardPayment(
                                  card.id,
                                );
                              },
                              child: const Text('Set as default'),
                            ),
                  ),
                  const GapY(),
                ],
              );
            }),
          ),
          const GapY(),
          YLiftFilledButton(
            child: const Text('Add New Payment Method'),
            onPressed: () {
              showDialog<CardPayment>(
                context: context,
                builder: (context) {
                  return CardPaymentDialog(
                    updateWalletPanel: () {
                      setState(() {
                        cardPayments = global.userCardPayments;
                      });
                    },
                  );
                },
              );
            },
          ),
        ],
      );
    });
  }
}

class CardPaymentDialog extends StatefulWidget {
  final Function updateWalletPanel;

  final CardPayment? cardPayment;
  const CardPaymentDialog({
    super.key,
    required this.updateWalletPanel,
    this.cardPayment,
  });

  @override
  State<CardPaymentDialog> createState() => _CardPaymentDialogState();
}

class _CardPaymentDialogState extends State<CardPaymentDialog> {
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

  late CardPayment _cardPayment;

  int? cardExpMonth;
  int? cardExpYear;

  bool isAddingCard = false;

  Future<void> addCard() async {
    try {
      setState(() {
        isAddingCard = true;
      });

      final isFormValid = validateForm();
      if (!isFormValid) return;

      final currentDate = DateTime.now();
      final cardExpDate = DateTime(cardExpYear!, cardExpMonth!);
      if (cardExpDate.year == currentDate.year &&
          cardExpDate.month < currentDate.month) {
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

      PhantomResponse response = await global.userProfile.addUserPaymentCard(
        payload: payload,
      );

      if (response.isSuccess) {
        widget.updateWalletPanel();
        Navigator.pop(context);
      } else {
        setState(() {
          isAddingCard = false;
          errorMessage = response.message;
        });
      }
    } catch (e) {
    } finally {
      setState(() {
        isAddingCard = false;
      });
    }
  }

  String country = 'United States';
  USState? usState;

  void setCountry(String? value) {
    if (value == null || value == country) return;
    // stateController.clear();

    setState(() {
      country = value;
      usState = null;
    });
  }

  //
  void initializeFields() {
    if (widget.cardPayment != null) {
      _cardPayment = widget.cardPayment!;
      cardNumber.text = _cardPayment.last4; // Standard Visa test number
      cardExpMonth = _cardPayment.expirationDate?.month;
      cardCvv.text = "";
      // firstName.text = _cardPayment.;
      // lastName.text = 'Smith';
      // streetAddressController.text = '123 Main Street';
      // suiteController.text = 'Suite 100';
      // cityController.text = 'Helena';
      // zipController.text = '59601';
      // countryController.text = 'United States';
      // usState = USState.values.first;
    }
    // else {
    //   cardNumber.text = '4111111111111111'; // Standard Visa test number
    //   cardExpMonth = 12;
    //   cardCvv.text = '123';
    //   firstName.text = 'John';
    //   lastName.text = 'Smith';
    //   streetAddressController.text = '123 Main Street';
    //   suiteController.text = 'Suite 100';
    //   cityController.text = 'Helena';
    //   zipController.text = '59601';
    //   countryController.text = 'United States';
    //   usState = USState.values.first;
    // }
  }

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

  @override
  void initState() {
    super.initState();
    countryController.text = 'United States';

    // if (kDebugMode) {
    initializeFields();
    // }
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
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: SizedBox(
          width: 800,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text('Add a Card Payment'),
                ],
              ),
              const SizedBox(height: 32),
              Form(
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
                                  final cardExpDate = DateTime(
                                    cardExpYear!,
                                    cardExpMonth!,
                                  );
                                  if (cardExpDate.year == currentDate.year &&
                                      cardExpDate.month < currentDate.month) {
                                    cardExpMonthError =
                                        'Enter a valid exp. month';
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
                                  final cardExpDate = DateTime(
                                    cardExpYear!,
                                    cardExpMonth!,
                                  );
                                  if (cardExpDate.year == currentDate.year &&
                                      cardExpDate.month < currentDate.month) {
                                    cardExpMonthError =
                                        'Enter a valid exp. month';
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
                            labelText: 'First Name',
                            controller: firstName,
                            errorText: firstNameError,
                            maxLength: 25,
                            validator: (value) {
                              if (value?.isEmpty ?? false)
                                return 'Enter your first name';
                              return null;
                            },
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp("[a-zA-Z]"),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: YLiftTextFormField(
                            labelText: 'Last Name',
                            controller: lastName,
                            errorText: lastNameError,
                            maxLength: 25,
                            validator: (value) {
                              if (value?.isEmpty ?? false)
                                return 'Enter last name';
                              return null;
                            },
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp("[a-zA-Z]"),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Street Address
                    YLiftTextFormField(
                      labelText: 'Address Line 1',
                      controller: streetAddressController,
                      errorText: streetError,
                      maxLength: 25,
                      validator: (value) {
                        if (value?.isEmpty ?? false)
                          return 'Enter your address line 1';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Suite Number
                    YLiftTextFormField(
                      maxLength: 25,
                      labelText: 'Address Line 2 (Optional)',
                      controller: suiteController,
                    ),
                    const SizedBox(height: 16),

                    // City, State, and ZIP Code Row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          // City must be letters only
                          child: YLiftTextFormField(
                            labelText: 'City',
                            controller: cityController,
                            maxLength: 20,
                            validator: (value) {
                              if (value?.isEmpty ?? false)
                                return 'Enter a valid city';
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
                          child: ZipCodeField(
                            controller: zipController,
                          ),
                        ),
                        // Expanded(
                        //   child: YLiftTextFormField(
                        //     labelText: 'Zip Code',
                        //     controller: zipController,
                        //     maxLength: 5,
                        //     keyboardType: TextInputType.number,
                        //     validator: (value) {
                        //       if (value!.length < 5) return 'Enter a valid zip code';
                        //       return null;
                        //     },
                        //   ),
                        // ),
                      ],
                    ),
                  ],
                ),
              ),
              if (errorMessage != null)
                Text(errorMessage!, style: TextStyle(color: YLiftColor.orange)),
              OverflowBar(
                alignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Cancel'),
                  ),
                  if (isAddingCard)
                    const CircularProgressIndicator()
                  else
                    FilledButton(
                      onPressed: addCard,
                      child: const Text('Add Card'),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StoreCreditPanel extends StatefulWidget {
  const StoreCreditPanel({super.key});

  @override
  State<StoreCreditPanel> createState() => _StoreCreditPanelState();
}

class _StoreCreditPanelState extends State<StoreCreditPanel> {
  final global = Get.find<GlobalController>();

  late Future<int?> _storeCreditBalanceFuture;

  @override
  void initState() {
    _storeCreditBalanceFuture = global.userController.getStoreCreditBalance();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _storeCreditBalanceFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox.shrink();
        } else if (snapshot.hasError) {
          return Text(
            'Unable to retrieve balance at the moment.',
            style: TextStyle(color: YLiftColor.orange),
          );
        } else {
          final balance = snapshot.data;
          if (balance == null) return SizedBox.shrink();

          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            padding: const EdgeInsets.all(16),
            margin: EdgeInsets.only(bottom: 16),
            child: Row(
              children: [
                Text(
                  'Store Credit Balance: ',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text((balance * 100).toCurrency()),
              ],
            ),
          );
        }
      },
    );
  }
}
