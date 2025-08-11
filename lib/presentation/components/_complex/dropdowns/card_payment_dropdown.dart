
import 'package:YLift/core/controllers/z-index_export.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:galaxy_models/galaxy_models.dart';
//
// class CardPaymentDropdown extends StatefulWidget {
//   const CardPaymentDropdown({
//     super.key,
//     this.selectedCard,
//     required this.onSelected,
//   });
//
//   final CardPayment? selectedCard;
//   final void Function(CardPayment card) onSelected;
//
//   @override
//   State<CardPaymentDropdown> createState() => _CardPaymentDropdownState();
// }
//
// class _CardPaymentDropdownState extends State<CardPaymentDropdown> {
//   final global = Get.find<GlobalController>();
//   List<CardPayment>? cardPayments;
//
//   bool get isLoading => cardPayments == null;
//
//   void loadCardPayments() async {
//     final cards = await global.basket.getCardPayments(profileId: global.user.value.profileId.toString());
//     setState(() {
//       cardPayments = cards;
//     });
//   }
//
//   @override
//   void initState() {
//     loadCardPayments();
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text('Credit Card'),
//         DropdownMenu<CardPayment>(
//           enableSearch: false,
//           requestFocusOnTap: false,
//           expandedInsets: EdgeInsets.zero,
//           hintText: 'Select a payment method',
//           onSelected: (value) {
//             if (value == null) return;
//             widget.onSelected(value);
//           },
//           dropdownMenuEntries: isLoading
//               ? []
//               : List.generate(cardPayments!.length, (index) {
//                   final payment = cardPayments![index];
//                   return DropdownMenuEntry(
//                     value: payment,
//                     label: '${payment.cardType} ending in ****${payment.last4}',
//                   );
//                 }, growable: false),
//         ),
//       ],
//     );
//   }
// }

class CardPaymentDropdown extends StatelessWidget {
  final void Function(CardPayment card) onSelected;
  final String? errorMessage;

  CardPaymentDropdown({
    super.key,
    required this.onSelected,
    this.errorMessage,
  });

  final global = Get.find<GlobalController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final cardPayments = global.user.value.wallet;
        final hasCards = cardPayments != null && cardPayments.isNotEmpty;

        return DropdownMenu<CardPayment>(
          requestFocusOnTap: false,
          enableSearch: false,
          enabled: hasCards,
          expandedInsets: EdgeInsets.zero,
          hintText: 'Select card payment',
          onSelected: (value) {
            if (value == null) return;
            onSelected(value);
          },
          inputDecorationTheme: InputDecorationTheme(
            errorStyle: TextStyle(
                fontSize: 11.11,
              color: YLiftColor.orange
            )
          ),
          errorText: errorMessage,
          dropdownMenuEntries: cardPayments?.map(
            (card) {
              return DropdownMenuEntry(
                value: card,
                label: '${card.cardType} ending in ****${card.last4}',
              );
            },
          ).toList() ?? [],
        );
      },
    );
  }
}
