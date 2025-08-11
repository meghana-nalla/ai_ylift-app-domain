import 'package:YLift/core/constants/constant.dart';
import 'package:YLift/core/controllers/global.dart';
import 'package:YLift/presentation/components/report_issue_button.dart';
import 'package:flutter/material.dart';
import 'package:galaxy_models/galaxy_models.dart';
import 'package:galaxy_ui/galaxy_ui.dart';
import 'package:get/get.dart';

class PlaceOrderButton extends StatefulWidget {
  final CardPayment? cardPayment;
  const PlaceOrderButton({
    super.key,
    this.cardPayment,
  });

  @override
  State<PlaceOrderButton> createState() => _PlaceOrderButtonState();
}

class _PlaceOrderButtonState extends State<PlaceOrderButton> {
  final global = Get.find<GlobalController>();

  bool _isProcessingOrder = false;

  bool _isOrderReady() {
    if (widget.cardPayment == null) return false;
    return true;
  }

  void showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        content: Text(
          message,
          style: TextStyle(color: Colors.white),
        ),
        margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height - 240, right: 20, left: 20),
      ),
    );
  }

  void showErrorTile(String message) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder:
          (context) => Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: Material(
              elevation: 6,
              borderRadius: BorderRadius.circular(8),
              color: const Color(0xFFFFF8F8),
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.error, color: Colors.black),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            message,
                            style: const TextStyle(color: Colors.black),
                          ),
                          const SizedBox(height: 8),
                          ReportIssueButton(
                            errorMessage:
                                "User is not able to unable to place the order. Problem in function: _placeOrder() on page PlaceOrderButton. The message user is seeing: $message. ",
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => overlayEntry.remove(),
                      icon: const Icon(Icons.close, color: Colors.black),
                      tooltip: 'Close',
                    ),
                  ],
                ),
              ),
            ),
          ),
    );

    overlay.insert(overlayEntry);
  }

  Future<void> placeOrderDialog() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Place Order Confirmation'),
          content: Text(
            "Thank you for choosing us! We're excited to ship your order.\nYour account setup is underway and usually takes about 3 business days.\nWe'll keep you updated and let you know as soon as everything is ready.",
          ),
          actions: [
            RoundedFilledButton(
              onPressed: () async {
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: const Text('Go Back'),
              ), //const Icon(Icons.delete_forever),
            ),
            RoundedFilledButton(
              onPressed: () {
                _placeOrder();
                Navigator.pop(context);
              },
              color: YLiftColor.orange,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Place Order Now',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _placeOrder() async {
    // do not allow the user to place an order for less that $0
    if (global.simpleCart.value.orderTotal <= 0) {
      //showErrorSnackBar('Error: cannot place an order for \$0 or less');
      showErrorTile('Error: cannot place an order for \$0 or less');
    }

    setState(() {
      _isProcessingOrder = true;
    });
    try {
      final order = await global.basket.createOrder(cardId: widget.cardPayment!.id);

      showSuccessSnackBar('Order has been placed!');
      await Future.delayed(const Duration(seconds: 1));
      if(!mounted) return;
      ScaffoldMessenger.of(context).clearSnackBars();

      debugPrint('Navigating to OrderConfirmationPage');
      await global.vroute.navigateTo('/order/confirm?orderId=${order.orderId}');

    } catch (e) {
      showErrorTile(
        'Something went wrong while placing the order, please try again later.\n'
        'If the problem persists, please contact ${YLiftConstant.yliftPhoneNumber} or ${YLiftConstant.yliftEmail}.\n'
        '$e',
      );
    } finally {
      setState(() {
        _isProcessingOrder = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return YLiftFilledButton(
      isExpanded: true,
      backgroundColor: YLiftColor.brown,
      onPressed:
          !_isOrderReady()
              ? null
              : () async {
                if (_isOrderReady() && !_isProcessingOrder) {
                  var merzProduct = global.simpleCart.value.cartItems.where((products) => products.vendorId == 13);
                  if (global.user.value.notifyOnNewOrder! && merzProduct.isNotEmpty) {
                    await placeOrderDialog();
                  } else {
                    _placeOrder();
                  }
                }
              },
      child: _buildMessage(),
    );
  }

  Widget _buildMessage() {
    if (_isOrderReady()) {
      if (_isProcessingOrder) return const Text('Processing order...');
      return const Text('Place Order');
    } else {
      return const Text('Select Payment To Checkout', style: TextStyle(fontSize: 13.33));
    }
  }
}
