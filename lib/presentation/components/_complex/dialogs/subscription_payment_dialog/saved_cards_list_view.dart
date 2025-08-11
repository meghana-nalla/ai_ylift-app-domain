
import 'package:YLift/core/controllers/global.dart';
import 'package:galaxy_models/galaxy_models.dart';
import 'package:flutter/material.dart';
import 'package:galaxy_ui/galaxy_ui.dart';
import 'package:get/get.dart';

class SavedCardListView extends StatefulWidget {
  final CardPayment? value;
  final void Function(CardPayment value) onSelected;

  const SavedCardListView({
    super.key,
    required this.value,
    required this.onSelected,
  });

  @override
  State<SavedCardListView> createState() => _SavedCardListViewState();
}

class _SavedCardListViewState extends State<SavedCardListView> {
  final global = Get.find<GlobalController>();

  List<CardPayment>? cardPayments;

  CardPayment? selectedCardPayment;
  void selectCardPayment(CardPayment cardPayment) {
    setState(() {
      selectedCardPayment = cardPayment;
    });
    widget.onSelected(cardPayment);
  }

  @override
  void initState() {
    cardPayments = global.user.value.wallet;
    selectedCardPayment = widget.value;
    super.initState();
  }

  Widget _buildCardPaymentIcon(CardPayment cardPayment) {
    switch (cardPayment.cardType.toLowerCase()) {
      case 'visa':
        return const VisaMarkIcon();
      case 'mastercard':
        return const MasterCardMarkIcon();
      case 'discover':
        return const DiscoverMarkIcon();
      case 'amex':
        return const AmexMarkIcon();
      default:
        return const Icon(Icons.payment_outlined);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (cardPayments == null) {
      return CircularProgressIndicator();
    }
    if (cardPayments!.isEmpty) {
      return Text('No saved cards found.\nPlease add a new card');
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16,
      children:
          cardPayments!.map((cardPayment) {
            final isSelected = selectedCardPayment?.id == cardPayment.id;
            return GestureDetector(
              onTap: () => selectCardPayment(cardPayment),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isSelected ? YLiftColor.orange : YLiftColor.grey3,
                      width: isSelected ? 2 : 1,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  child: Row(
                    children: [
                      _buildCardPaymentIcon(cardPayment),
                      const SizedBox(width: 16),
                      Text('Card ending with ****${cardPayment.last4}'),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
    );
  }
}
