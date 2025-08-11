import 'package:YLift/presentation/pages/desktop/__primary_shopping/components/quick_reorder_payments_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:YLift/core/controllers/global.dart';
import 'order_item_card.dart';
import 'package:galaxy_models/galaxy_models.dart';

class QuickOrderView extends StatefulWidget {
  final OrderSimple previousOrder;
  final void Function(CardPayment cardPayment) onSelectedCard;

  const QuickOrderView({
    super.key,
    required this.previousOrder,
    required this.onSelectedCard,
  });

  @override
  State<QuickOrderView> createState() => _QuickOrderViewState();
}

class _QuickOrderViewState extends State<QuickOrderView> {
  final global = Get.find<GlobalController>();
  OrderSimple get previousOrder => widget.previousOrder;

  String formatAddress() {
    AddressSimple? address = widget.previousOrder.shippingAddress!;
    String formattedAddress = '${address.line1!} ${address.city}, ${address.state}';
    if (widget.previousOrder.optionalAddress != null && widget.previousOrder.optionalAddress!.length > 1) {
      formattedAddress += '\t + ${widget.previousOrder.optionalAddress!.length - 1} additional addresses';
    }

    return formattedAddress;
  }

  CardPayment? selectedCard;
  List<CardPayment>? cardPayments;
  int selectedIndex = 0;

  void setCardPayment(CardPayment card) {
    setState(() {
      selectedCard = card;
    });
    widget.onSelectedCard(card);
  }

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    init();
  }

  Future<void> init() async {
    if (global.userCardPayments.isEmpty) {
      cardPayments = (await global.userProfile.getUserCardPayments());
    } else {
      cardPayments = global.userCardPayments;
    }

    selectedCard = cardPayments?.first;

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return (_isLoading)
        ? const Center(child: CircularProgressIndicator())
        : Container(
            height: 560,
            width: 480,
            color: Colors.white,
            padding: const EdgeInsets.all(8),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: YLiftColor.grey3),
                    ),
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return QuickReorderPaymentsDialog(
                                selectedCardPayment: selectedCard,
                                onSelected: setCardPayment,
                              );
                            },
                          );
                          // showDialog(context: context, builder: (context) {
                          //   return Dialog(
                          //     child: CardPaymentListView(
                          //       selectedCard: selectedCard,
                          //       onSelected: (card) {
                          //         setCardPayment(card);
                          //         Navigator.of(context).pop();
                          //       },
                          //     ),
                          //   );
                          // });
                        },
                        child: Row(
                          children: [
                            const Icon(
                              Icons.payment_outlined,
                              size: 14,
                            ),
                            const SizedBox(width: 24),
                            if (selectedCard != null) ...[
                              Text(
                                'Saved Card',
                                style: TextStyle(
                                  fontSize: 11.11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Text(
                                'Ending In',
                                style: TextStyle(
                                  fontSize: 11.11,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Text(
                                '****${selectedCard!.last4}',
                                style: TextStyle(
                                  fontSize: 11.11,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ] else ...[
                              const Text(
                                'Change Payment Method',
                                style: TextStyle(
                                  fontSize: 11.11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                            const Spacer(),
                            const Icon(
                              Icons.edit_outlined,
                              size: 14,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: YLiftColor.grey3),
                    ),
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 14,
                        ),
                        const SizedBox(width: 24),
                        Text(
                          formatAddress(),
                          style: TextStyle(
                            fontSize: 11.11,
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  _buildOrderItems(),
                ],
              ),
            ),
          );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          decoration: const BoxDecoration(
            color: Color(0xFFF3F4F3),
            shape: BoxShape.circle,
          ),
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.add_shopping_cart_rounded),
          ),
        ),
        const SizedBox(width: 30),
        const Text(
          'Review Information',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }

  Widget _buildOrderItems() {
    return Wrap(
      alignment: WrapAlignment.start,
      crossAxisAlignment: WrapCrossAlignment.start,
      spacing: 32,
      runSpacing: 24,
      children: previousOrder.cartItems.map((item) => OrderItemCard(cartItem: item)).toList(),
    );
  }
}