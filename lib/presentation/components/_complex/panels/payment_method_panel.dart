import 'package:YLift/core/constants/constant.dart';
import 'package:YLift/core/controllers/global.dart';
import 'package:YLift/models/api/z-index_export.dart';
import 'package:YLift/presentation/components/_complex/dialogs/saved_cards_dialog.dart';
import 'package:YLift/presentation/components/_complex/z-index_export.dart';
import 'package:YLift/presentation/components/_complex/tiles/payment_method_tile.dart';
import 'package:YLift/presentation/components/_complex/forms/add_card_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:galaxy_ui/galaxy_ui.dart';
import 'package:galaxy_models/galaxy_models.dart';
import 'package:YLift/core/constants/index.dart';

enum PaymentMethod {
  credit('Saved Card'),
  newCard('Add Credit or Debit Card'),
  yLiftTerms('Y Lift Terms'),
  applePay('Apple Pay', 'marks/apple_pay_mark.svg'),
  googlePay('Google Pay', 'marks/google_pay_mark.svg');

  final String label;
  final String? assetPath;
  const PaymentMethod(this.label, [this.assetPath]);

  static const noAdds = <PaymentMethod>[
    PaymentMethod.credit,
    PaymentMethod.yLiftTerms,
    PaymentMethod.applePay,
    PaymentMethod.googlePay,
  ];
}

class PaymentMethodPanel extends StatefulWidget {
  final PaymentMethod selectedMethod;
  final String? paymentInformation;
  final void Function(PaymentMethod paymentMethod) onChanged;

  PaymentMethodPanel({
    super.key,
    required this.selectedMethod,
    required this.onChanged,
    this.paymentInformation,
  });

  @override
  State<PaymentMethodPanel> createState() => _PaymentMethodPanelState();
}

class _PaymentMethodPanelState extends State<PaymentMethodPanel> {
  final controller = Get.find<GlobalController>();

  bool isAddingNewCard = false;

  var newCardData = <String, dynamic>{
    "addressFirstName": "",
    "addressLastName": "",
    "addressLine": "",
    "addressCity": "",
    "addressState": "",
    "addressZip": "",
    "addressCountry": "US",
    "cardNumber": "",
    "cardExpMonth": null,
    "cardExpYear": null,
    "cardCvc": ""
  };

  Future<void> saveNewCard() async {
    try {
      setState(() {
        isAddingNewCard = true;
      });

      final response = await controller.api.post(ApiUrl.cards.path, newCardData);
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonMap = response.data;
        // need to save the JsonMap response to an object
        // var myTemp
        CardResponse cardResponse = CardResponse.fromJson(jsonMap);
        CardInformation newCard = CardInformation(
          cardNumber: cardResponse.payment!.creditCard!.cardNumber!,
          cardType: cardResponse.payment!.creditCard!.cardType!,
          billTo: BillingAddress(
            firstName: cardResponse.billTo!.firstName!,
            lastName: cardResponse.billTo!.lastName!,
            address: cardResponse.billTo!.address!,
            city: cardResponse.billTo!.city!,
            state: cardResponse.billTo!.state!,
            zip: cardResponse.billTo!.zip!,
            country: cardResponse.billTo!.country!,
          ),
          customerPaymentProfileId: cardResponse.customerPaymentProfileId!,
        );
        // make sure to set the default card if there are no cards
        if (controller.cart.value.cards!.isEmpty) controller.cart.value.checkout!.card = newCard;
        controller.cart.value.cards!.add(newCard);
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Card added successfully')),
        );
        // toggleAddNewCard();
      } else {
        throw Exception('Failed to add card');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    } finally {
      setState(() {
        isAddingNewCard = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GalaxyPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Select payment method'),
          const SizedBox(height: YLiftConstant.gap),
          ExpansionTile(
            shape: const Border(),
            leading: widget.selectedMethod.assetPath != null
                ? SvgPicture.asset(
                    widget.selectedMethod.assetPath!,
                    width: 40,
                    // height: 24,
                  )
                : const SizedBox(
                    width: 40,
                    child: Placeholder(),
                  ),
            // title: paymentInformation == null
            //     ? const Text('Select payment method')
            //     : Text('${selectedMethod.label} ${paymentInformation ?? ''}'),
            title: Text('${widget.selectedMethod.label} ${widget.paymentInformation ?? ''}'),
            subtitle: const Text('Click to change or add a new payment method'),
            initiallyExpanded: true,
            children: [
              Obx(() => PaymentMethodTile(
                    // TODO: Change this to the users credit number
                    paymentIcon: const Icon(Icons.payment),
                    methodName: '${PaymentMethod.credit.label} Ending in ${controller.cart.value.checkout?.card?.cardNumber ?? ''}',
                    isSelected: widget.selectedMethod == PaymentMethod.credit,
                    onSelected: () => widget.onChanged(PaymentMethod.credit),
                    trailing: IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return const SavedCardsDialog();
                          },
                        );
                      },
                      icon: const Icon(Icons.swap_horiz),
                    ),
                  ),
              ),
              if(BETA)...[

              const SizedBox(height: 16),
              PaymentMethodTile(
                paymentIcon: const Icon(Icons.payment),
                methodName: PaymentMethod.yLiftTerms.label,
                isSelected: widget.selectedMethod == PaymentMethod.yLiftTerms,
                onSelected: () => widget.onChanged(PaymentMethod.yLiftTerms),
              ),
              const SizedBox(height: 16),
              PaymentMethodTile(
                paymentIcon: PaymentMethod.applePay.assetPath != null
                    ? SvgPicture.asset(
                        PaymentMethod.applePay.assetPath!,
                        width: 24,
                      )
                    : null,
                methodName: PaymentMethod.applePay.label,
                isSelected: widget.selectedMethod == PaymentMethod.applePay,
                onSelected: () => widget.onChanged(PaymentMethod.applePay),
              ),
              const SizedBox(height: 16),
              PaymentMethodTile(
                paymentIcon: PaymentMethod.googlePay.assetPath != null
                    ? SvgPicture.asset(
                        PaymentMethod.googlePay.assetPath!,
                        width: 24,
                      )
                    : null,
                methodName: PaymentMethod.googlePay.label,
                isSelected: widget.selectedMethod == PaymentMethod.googlePay,
                onSelected: () => widget.onChanged(PaymentMethod.googlePay),
              ),
              ],
              const PaymentMethodDivider(),
              PaymentMethodTile(
                methodName: 'Add Credit or Debit Card',
                isSelected: widget.selectedMethod == PaymentMethod.newCard,
                onSelected: () => widget.onChanged(PaymentMethod.newCard),
              ),
            ],
          ),
          // TODO : RICHIE IS THIS NEEDED?

          // ListView.separated(
          //   shrinkWrap: true,
          //   itemCount: PaymentMethod.values.length,
          //   separatorBuilder: (context, index) => const SizedBox(height: 16),
          //   itemBuilder: (context, index) {
          //     final paymentMethod = PaymentMethod.values[index];
          //     return PaymentMethodTile(
          //       paymentIcon: paymentMethod.assetPath != null
          //           ? SvgPicture.asset(
          //               paymentMethod.assetPath!,
          //               width: 40,
          //               // height: 24,
          //             )
          //           : null,
          //       isSelected: selectedMethod == paymentMethod,
          //       methodName: paymentMethod.label,
          //       onSelected: () => onChanged(paymentMethod),
          //     );
          //   },
          // ),

          const SizedBox(height: 32),
          if (widget.selectedMethod == PaymentMethod.newCard) ...[
            AddPaymentCardForm(
              newCard: newCardData,
              onChanged: (data) {
                setState(() {
                  newCardData = data;
                });
              },
            ),
            const GapY(),
            Center(
              child: YLiftFilledButton(
                onPressed: isAddingNewCard ? null : saveNewCard,
                child: isAddingNewCard ? const Text('Adding new card...') : const Text('Add new card'),
              ),
            )
          ],
        ],
      ),
    );
  }
}

class PaymentMethodDivider extends StatelessWidget {
  const PaymentMethodDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: YLiftConstant.gap * 2,
      child: Row(
        children: [
          Expanded(
            child: Divider(endIndent: 40),
          ),
          Text(
            'OR',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Divider(indent: 40),
          ),
        ],
      ),
    );
  }
}
