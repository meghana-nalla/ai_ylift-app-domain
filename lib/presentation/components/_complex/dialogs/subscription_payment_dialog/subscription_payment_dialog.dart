
import 'package:YLift/core/controllers/global.dart';
import 'package:YLift/presentation/components/_simple/us_state_dropdown.dart';
import 'package:galaxy_models/galaxy_models.dart';
import 'package:YLift/presentation/components/_complex/dialogs/subscription_payment_dialog/saved_cards_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:galaxy_ui/galaxy_ui.dart';
import 'package:get/get.dart';

enum _PaymentMethod {
  savedCards,
  addNewCard,
}

const _backgroundImageUrl =
    'https://media.stage.ylift.app/api/optimized/variant/image/d161c507-f107-49c3-9334-9a3bf7bebd75';

class SubscriptionPaymentDialog extends StatefulWidget {
  const SubscriptionPaymentDialog({super.key});

  @override
  State<SubscriptionPaymentDialog> createState() =>
      _SubscriptionPaymentDialogState();
}

class _SubscriptionPaymentDialogState extends State<SubscriptionPaymentDialog> {
  final global = Get.find<GlobalController>();
  _PaymentMethod _selectedPaymentMethod = _PaymentMethod.savedCards;

  CardPayment? selectedCardPayment;

  final cardNumberController = TextEditingController();
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

  String country = 'United States';
  USState? usState;

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

  void paySubscription() async {
    final now = DateTime.now();
    final profileId = global.user.value.profileId;
    final response = await global.api.postData(
      'cart/virtual/items/subscription/order',
      {
        "subscriptionName": "Galderma Platform Access1",
        "description":
            "Galderma yearly subscription for comprehensive healthcare platform features",
        "amount": 200,
        "intervalUnit": "MONTH",
        "intervalLength": 1,
        "profileId": profileId,
        "customerPaymentProfileId": selectedCardPayment!.id,
        "startDate": now.toIso8601String(),
      },
    );
    if (response.isSuccess) {
      Navigator.pop(context);
    } else {}
  }

  @override
  void initState() {
    selectedCardPayment = global.user.value.wallet?.first;
    super.initState();
  }

  @override
  void dispose() {
    cardNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: SizedBox(
        height: 800,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Image
              Container(
                width: 480,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(16),
                  image: DecorationImage(
                    image: NetworkImage(_backgroundImageUrl),
                    fit: BoxFit.cover,
                    alignment: Alignment(0.24, 0.0),
                    opacity: 0.5,
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 40,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Upgrade to Premium',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Unlock top-tier pricing on products with subscriptions',
                      style: TextStyle(color: Colors.white, fontSize: 13.33),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(16),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 25,
                        vertical: 16,
                      ),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Pay Annually'),
                              Text(
                                '\$200.00 per month',
                                style: TextStyle(fontSize: 13.33),
                              ),
                            ],
                          ),
                          const Spacer(),
                          // Container(
                          //   decoration: BoxDecoration(
                          //     color: YLiftColor.orange,
                          //     borderRadius: const BorderRadius.all(
                          //       Radius.circular(4),
                          //     ),
                          //   ),
                          //   padding: const EdgeInsets.symmetric(
                          //     horizontal: 8,
                          //     vertical: 4,
                          //   ),
                          //   child: Text(
                          //     'Save 23%',
                          //     style: TextStyle(
                          //       color: Colors.white,
                          //       fontSize: 13.33,
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    CostRow(
                      'Subtotal',
                      20000,
                      style: TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    CostRow(
                      'Tax',
                      0,
                      style: TextStyle(color: Colors.white),
                    ),
                    const Divider(
                      height: 32,
                      color: Colors.white,
                    ),
                    CostRow(
                      'Total',
                      240000,
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 32),

              // Card Forms
              SizedBox(
                width: 480,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.clear),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),
                    Row(
                      spacing: 16,
                      children: [
                        _PaymentMethodOption(
                          icon: Icons.credit_card_outlined,
                          label: 'Saved Cards',
                          isSelected:
                              _selectedPaymentMethod ==
                              _PaymentMethod.savedCards,
                          onSelected: () {
                            setState(() {
                              _selectedPaymentMethod =
                                  _PaymentMethod.savedCards;
                            });
                          },
                        ),
                        _PaymentMethodOption(
                          icon: Icons.add_outlined,
                          label: 'Add New Card',
                          isSelected:
                              _selectedPaymentMethod ==
                              _PaymentMethod.addNewCard,
                          onSelected: () {
                            setState(() {
                              _selectedPaymentMethod =
                                  _PaymentMethod.addNewCard;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    if (_selectedPaymentMethod == _PaymentMethod.savedCards)
                      SavedCardListView(
                        value: selectedCardPayment,
                        onSelected: (cardPayment) {
                          setState(() {
                            selectedCardPayment = cardPayment;
                          });
                        },
                      )
                    else
                      Column(
                        spacing: 16,
                        children: [
                          GalaxyCardNumberField(
                            controller: cardNumberController,
                          ),
                          // Expiration Month and Year, CVV Row
                          Row(
                            spacing: 16,
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
                                        if (cardExpDate.year ==
                                                currentDate.year &&
                                            cardExpDate.month <
                                                currentDate.month) {
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
                                        if (cardExpDate.year ==
                                                currentDate.year &&
                                            cardExpDate.month <
                                                currentDate.month) {
                                          cardExpMonthError =
                                              'Enter a valid exp. month';
                                          return;
                                        }
                                      }
                                    });
                                  },
                                ),
                              ),
                              Expanded(
                                child: CardCvvField(
                                  controller: cardCvv,
                                  errorText: cardCvvError,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            spacing: 16,
                            children: [
                              Expanded(
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    labelText: 'First Name',
                                    helperText: '',
                                  ),
                                  validator: (value) {
                                    if (value?.isEmpty ?? false) {
                                      return 'Enter your first name';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              Expanded(
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    labelText: 'Last Name',
                                    helperText: '',
                                  ),
                                  validator: (value) {
                                    if (value?.isEmpty ?? false) {
                                      return 'Enter your last name';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),

                          // Street Address
                          TextFormField(
                            controller: streetAddressController,
                            decoration: InputDecoration(
                              labelText: 'Address Line 1',
                              errorText: streetError,
                              helperText: '',
                            ),
                            validator: (value) {
                              if (value?.isEmpty ?? false) {
                                return 'Enter your address line 1';
                              }
                              return null;
                            },
                          ),

                          // Suite Number
                          TextFormField(
                            controller: suiteController,
                            decoration: InputDecoration(
                              labelText: 'Address Line 2 (Optional)',
                              helperText: '',
                            ),
                          ),

                          // City, State, and ZIP Code Row
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 16,
                            children: [
                              Expanded(
                                // City must be letters only
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    labelText: 'City',
                                    errorText: cityError,
                                  ),
                                  controller: cityController,
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
                              ),
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
                              Expanded(
                                child: ZipCodeField(
                                  controller: zipController,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                    const Spacer(),
                    Row(
                      spacing: 16,
                      children: [
                        SizedBox(
                          width: 200,
                          child: _CancelButton(),
                        ),
                        Expanded(
                          child: _SubscribeNowButton(
                            onPressed: paySubscription,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CancelButton extends StatelessWidget {
  const _CancelButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: YLiftColor.grey3,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Text('Cancel'),
      ),
    );
  }
}

class _SubscribeNowButton extends StatelessWidget {
  final void Function() onPressed;
  const _SubscribeNowButton({
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: FilledButton.styleFrom(
        backgroundColor: YLiftColor.orange,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: onPressed,
      child: const Text('Subscribe Now'),
    );
  }
}

class _PaymentMethodOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final void Function() onSelected;
  const _PaymentMethodOption({
    super.key,
    required this.icon,
    required this.label,
    required this.onSelected,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onSelected,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected ? YLiftColor.orange : YLiftColor.grey3,
              width: isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          width: 160,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8,
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.black : Colors.grey,
              ),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.black : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
