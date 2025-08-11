import 'package:galaxy_models/galaxy_models.dart';
import 'package:YLift/models/z-index_export.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:YLift/core/controllers/global.dart';
import 'package:galaxy_ui/galaxy_ui.dart';
class OrderSummaryView extends StatefulWidget {
  final OrderSimple previousOrder;
  final Function onAddToCart;
  final int? cardId;

  const OrderSummaryView({
    super.key,
    required this.onAddToCart,
    required this.previousOrder,
    this.cardId,
  });

  @override
  State<OrderSummaryView> createState() => _OrderSummaryViewState();
}

class _OrderSummaryViewState extends State<OrderSummaryView> {
  final global = Get.find<GlobalController>();
  String? _errorMessage;
  String? _successMessage;
  bool _isProcessing = false;
  OrderSimple get previousOrder => widget.previousOrder;

  Future<void> _handlePlaceOrder() async {
    setState(() {
      _isProcessing = true;
      _errorMessage = null;
    });

    try {
      PhantomResponse response = await global.orders.placeQuickOrder(
        widget.previousOrder.orderId.toString(),
        widget.previousOrder.cardId.toString(),
      );
      if (response.statusCode == 200 && response.statusMessage != "Error") {
        String? orderId = global.orderHistory.last.orderId;
        if (orderId == null) {
          setState(() {
            _errorMessage = 'Order failed: could not get data from most recent order.';
          });
          return;
        }

        setState(() {
          _successMessage = '${response.message}.';
        });
        await Future.delayed(const Duration(seconds: 4));

        if (mounted) {
          await global.vroute.navigateTo('/order/confirm?orderId=$orderId');
          Navigator.of(context).pop();
        }
      } else {
        setState(() {
          _errorMessage = 'Order declined: ${response.message}';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Order declined: ${e.toString()}';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  Future<void> _handleAddToCart() async {
    try {
      final orderId = previousOrder.orderId;
      if (orderId == null) return;
      await global.basket.quickReorderAddToCart(orderId: orderId);
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to add to cart: $e';
      });
    }

    // PhantomResponse response =    await global.api.putData(ApiUrl.quickOrderReplaceCart.path, { 'orderId': previousOrder.orderId.toString() });
    // if(response.isSuccess) {
    //   try{
    //     // await global.basket.getCartSimple();
    //     final cart = CartSimple.fromJson(response.data!['cart']);
    //     global.simpleCart.value = cart;
    //     global.simpleCart.refresh();
    //     global.update();
    //     await global.vroute.navigateTo('/order/cart');
    //   } catch(e,s){
    //     print('$e\n$s');
    //   }
    // }
    // setState(() {
    //   _errorMessage = 'Failed to add to cart: ${response.message}';
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 560,
      width: 290,
      color: Colors.white,
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 40),
          Text(
            '${previousOrder.cartItems.length} ${previousOrder.cartItems.length == 1 ? 'item' : 'items'}',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          _buildPriceSummary(),
          if (_errorMessage != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  border: Border.all(color: Colors.red.shade200),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: Colors.red.shade700, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _errorMessage!,
                        style: TextStyle(
                          color: Colors.red.shade700,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (_successMessage != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  border: Border.all(color: Colors.green.shade200),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    Icon(Icons.edit_calendar, color: Colors.green.shade700, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _successMessage!,
                        style: TextStyle(
                          color: Colors.green.shade700,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          const Spacer(),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        const Text(
          'Summary',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        const Spacer(),
        CloseIconButton(),
      ],
    );
  }

  Widget _buildPriceSummary() {
    return Column(
      children: [
        SummaryPriceRow(
          label: 'Subtotal:',
          price: previousOrder.subTotal.toCurrency(),
        ),
        SummaryPriceRow(
          label: 'Tax:',
          price: previousOrder.taxTotal.toCurrency(),
        ),
        SummaryPriceRow(
          label: 'Shipping:',
          price: previousOrder.shippingTotal.toCurrency(),
        ),
        const Divider(height: 24),
        SummaryPriceRow(
          label: 'Order Total:',
          price: previousOrder.orderTotal.toCurrency(),
          isTotal: true,
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        if(widget.previousOrder.freeItems == null || widget.previousOrder.freeItems.isEmpty)...[
          SizedBox(
            width: double.infinity,
            height: 50,
            child: RoundedFilledButton(
              onPressed: _isProcessing ? null : _handlePlaceOrder,
              child: _isProcessing
                  ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
                  : const Text('PLACE ORDER'),
            ),
          ),

        ],
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: Color(0xFF787878),
              side: BorderSide(width: 1.5),
            ),
            onPressed: _handleAddToCart,
            child: const Text(
              'ADD TO CART',
              style: TextStyle(
                fontSize: 13.33,
                color: YLiftColor.softBlack,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
