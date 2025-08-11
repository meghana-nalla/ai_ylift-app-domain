import 'package:YLift/core/controllers/global.dart';
import 'package:YLift/core/services/device_check.dart';
import 'package:YLift/hardcodes/promotions/summer_glow_july_15/summer_glow_promotion.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:galaxy_models/galaxy_models.dart';
import 'package:galaxy_ui/galaxy_ui.dart';
import 'package:get/get.dart';

class ImmediatePurchaseButton extends StatefulWidget {
  const ImmediatePurchaseButton({super.key});

  @override
  State<ImmediatePurchaseButton> createState() =>
      _ImmediatePurchaseButtonState();
}

class _ImmediatePurchaseButtonState extends State<ImmediatePurchaseButton> {
  final global = Get.find<GlobalController>();
  final _deviceService = WebDeviceService();
  bool _isProcessingOrder = false;
  bool _isDismissed = false;

  CardPayment? get _cardFromPaymentHistory {
    // just like before we can get cardId from payment history if there is a pending payment
    final cardId =
        global.simpleCart.value.paymentHistory
            ?.firstWhereOrNull((history) => history.paymentStatus == 'PENDING')
            ?.cardId;

    final userWallet = global.user.value.wallet ?? <CardPayment>[];

    // if we have a cardId from payment history, we use that
    if (cardId != null) {
      return userWallet.firstWhereOrNull((card) => card.id == cardId);
    }

    // otherwise, we use the default wallet card if its not expired
    return userWallet.firstWhereOrNull(
      (card) => card.isDefault == true && !card.isExpired,
    );
  }

  bool get _hasCardId {
    return _cardFromPaymentHistory != null;
  }

  bool get _canPurchase {
    return _hasCardId &&
        global.simpleCart.value.cartItems.isNotEmpty &&
        global.simpleCart.value.orderTotal > 0 &&
        !_isProcessingOrder;
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height - 240,
          right: 20,
          left: 20,
        ),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        action: SnackBarAction(
          label: 'Info',
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Order process error'),
                  content: Text(message),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                    IconButton(
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: message));
                      },
                      icon: const Icon(Icons.copy),
                    ),
                  ],
                );
              },
            );
          },
        ),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height - 240,
          right: 20,
          left: 20,
        ),
      ),
    );
  }

  Future<void> _placeImmediateOrder() async {
    final card = _cardFromPaymentHistory;
    if (card == null) return;

    // we never allow the user to place an order for less than $0
    if (global.simpleCart.value.orderTotal <= 0) {
      _showErrorSnackBar('Error: cannot place an order for \$0 or less');
      return;
    }

    setState(() {
      _isProcessingOrder = true;
    });

    try {
      final order = await global.basket.createOrder(cardId: card.id);

      _showSuccessSnackBar('Order has been placed!');
      await Future.delayed(const Duration(seconds: 1));

      debugPrint('Navigating to OrderConfirmationPage');
      await global.vroute.navigateTo('/order/confirm?orderId=${order.orderId}');

      // Handle Galderma promotion if eligible ??
      // if (SummerGlowPromotion.isEligibleForVEFDiffuser) {
      //   await global.galdermaController.setReward('Venus et Fleur');
      //   debugPrint('User is eligible for Venus et Fleur Diffuser');
      // }
      //
      // // place the order using the card we set ?? might need to handle the error meg was talking about.. ;/
      // final response = await global.basket.createOrderSimple(
      //   profileId: global.user.value.profileId,
      //   cardId: card.id,
      // );
      //
      // if (response.isSuccess) {
      //   // Success
      //   final data = response.data?['cart'];
      //   final order = OrderSimple.fromJson(data);
      //   await global.blowOutCarts();
      //   _showSuccessSnackBar(response.message);
      //
      //   // Wait for snackbar to show
      //   await Future.delayed(const Duration(seconds: 1));
      //   await global.auth.performRefreshToken();
      //   await global.vroute.navigateTo(
      //     '/order/confirm?orderId=${order.orderId}',
      //   );
      // } else {
      //   global.galdermaController.setReward('');
      //   _showErrorSnackBar(
      //     'Something went wrong while placing the order, please try again later.\n'
      //     'If the problem persists, please contact support.\n\n${response.message}',
      //   );
      // }
    } catch (e) {
      _showErrorSnackBar(
        'Something went wrong while placing the order, please try again later.\n'
        'If the problem persists, please contact support.',
      );
    } finally {
      setState(() {
        _isProcessingOrder = false;
      });
    }
  }

  String _getCardDisplayText(CardPayment card) {
    final expirationDate =
        '${card.expirationDate?.month}/${card.expirationDate?.year}';
    return '${card.cardType} ending with ****${card.last4} • Expires $expirationDate';
  }

  @override
  void initState() {
    super.initState();
    _loadDismissedState();
  }

  Future<void> _loadDismissedState() async {
    if (mounted) {
      setState(() {
        _isDismissed = global.immediateButtonDismiss.value;
      });
    }
  }

  Future<void> _dismissButton() async {
    if (mounted) {
      setState(() {
        global.immediateButtonDismiss.value = true; // need to create a way to reset back to false
        _isDismissed = true;
      });
    }
  }

  Widget _buildMobileCompactVersion(CardPayment card) {
    return Dismissible(
      key: const Key('immediate_purchase_mobile'),
      direction: DismissDirection.horizontal,
      onDismissed: (_) => _dismissButton(),
      background: Container(
        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.close, color: Colors.white),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orange.shade600, Colors.orange.shade700],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.orange.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _canPurchase ? _placeImmediateOrder : null,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.flash_on,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Quick Buy',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '•••• ${card.last4}',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 12,
                              ),
                            ),
                            if (card.isDefault) ...[
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 1,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Text(
                                  'Default',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Swipe to dismiss',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (_isProcessingOrder)
                    Container(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.white.withOpacity(0.9),
                        ),
                      ),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '\$${(global.simpleCart.value.orderTotal / 100).toStringAsFixed(2)}',
                        style: TextStyle(
                          color: Colors.orange.shade700,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasCardId || _isDismissed) {
      return const SizedBox.shrink();
    }

    final card = _cardFromPaymentHistory!;
    final isMobile =
        _deviceService.isMobileWeb || MediaQuery.of(context).size.width < 600;

    return Obx(() {
      if (isMobile) {
        return _buildMobileCompactVersion(card);
      }
      // Desktop version
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.flash_on, color: Colors.orange, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Quick Purchase',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.orange,
                  ),
                ),
                const Spacer(),
                if (card.isDefault)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Default',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Colors.orange.shade700,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                PaymentMarkIcon(card.cardType),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _getCardDisplayText(card),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: YLiftFilledButton(
                backgroundColor: Colors.orange,
                onPressed: _canPurchase ? _placeImmediateOrder : null,
                child:
                    _isProcessingOrder
                        ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 16,
                              width: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Processing...',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        )
                        : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.flash_on, color: Colors.white, size: 18),
                            const SizedBox(width: 8),
                            Text(
                              'Purchase Now - \$${((global.simpleCart.value.orderTotal - (global.simpleCart.value.discountTotal ?? 0) ) / 100).toStringAsFixed(2)}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'This will complete your order immediately using your saved payment method.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    });
  }
}
