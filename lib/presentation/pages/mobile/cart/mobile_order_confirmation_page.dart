import 'package:YLift/core/constants/text_style.dart';
import 'package:YLift/core/controllers/global.dart';
import 'package:YLift/models/api/z-index_export.dart';
import 'package:YLift/presentation/components/_simple/product_image_view.dart';
import 'package:YLift/presentation/components/mobile_scaffold.dart';
import 'package:YLift/presentation/pages/mobile/cart/components/mobile_virtual_item_tile.dart';
import 'package:flutter/material.dart';
import 'package:galaxy_models/galaxy_models.dart';
import 'package:galaxy_ui/galaxy_ui.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class MobileOrderConfirmationPage extends StatefulWidget {
  const MobileOrderConfirmationPage({super.key});

  @override
  State<MobileOrderConfirmationPage> createState() =>
      _MobileOrderConfirmationPageState();
}

class _MobileOrderConfirmationPageState
    extends State<MobileOrderConfirmationPage> {
  final global = Get.find<GlobalController>();
  OrderSimple? order;

  bool isLoading = false;
  String? errorMessage;

  bool get isFromHistory {
    final currentUrl = Uri.base;
    return currentUrl.queryParameters['fromHistory'] == 'true';
  }

  Future<OrderSimple?> getOrder(/*[String orderId = '16783194']*/) async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });
      final currentUrl = Uri.base;
      final orderId = currentUrl.queryParameters['orderId'];
      print('ORDER ID IS $orderId');
      if (orderId == null) {
        setState(() {
          errorMessage = 'Cannot find order id $orderId';
          isLoading = false;
        });
        return null;
      }
      final global = Get.find<GlobalController>();
      final response = await global.api.get(
        '${ApiUrl.getSingleOrder.path}/$orderId',
      );
      final statusCode = response.statusCode ?? 0;

      if (statusCode >= 200 && statusCode < 300) {
        // final data = jsonDecode(response.data) as Map<String, dynamic>;
        // print('RESPONSE DATA: ${response.data}');
        final order = OrderSimple.fromJson(response.data['data']['orders']);
        debugPrint('ORDER SUCESSFULLY RETRIEVED');
        setState(() {
          this.order = order;
        });
        return order;
      } else {
        setState(() {
          errorMessage = 'Cannot find order id $orderId';
          isLoading = false;
        });
        return null;
      }
    } catch (e) {
      print('GETTING ORDER FAILED');
      print('$e');
      setState(() {
        errorMessage = 'Failed to load order';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
    return null;
  }

  @override
  void initState() {
    getOrder();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (order == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    if (errorMessage != null) return Center(child: Text(errorMessage!));

    final paymentCard = global.user.value.wallet?.firstWhereOrNull(
      (card) => card.id == order?.cardId,
    );

    return MobileScaffold(
      title: 'Order Placed',
      onBackPressed:
          isFromHistory
              ? () {
                global.vroute.navigateTo('/profile');
              }
              : null,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                color: Colors.white,
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Icon(
                    Icons.check_circle_rounded,
                    color: YLiftColor.orange,
                    size: 64,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Thank you for choosing Y LIFT Store!',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Order #${order?.label} has been placed',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'We sent an email to ${order?.customerEmail} with your order confirmation and bill. Looking forward to seeing you again!',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Time placed: ${DateFormat.yMMMMd().add_jm().format(order!.orderDate!)}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  GalaxyFilledButton(
                    isExpanded: true,
                    backgroundColor: YLiftColor.orange,
                    onPressed: () {
                      global.vroute.navigateTo('/shop');
                    },
                    child: const Text('Back to Shop'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Shipping address
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                color: Colors.white,
              ),
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Shipping Address',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    order?.customerName ?? '(No name)',
                    style: const TextStyle(fontSize: 12),
                  ),
                  Text(
                    order?.shippingAddress?.twoLines ?? '(No address)',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Order Details
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                color: Colors.white,
              ),
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Payment Details',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),

                  Text(
                    'Paid with ${paymentCard?.cardType ?? 'card'} ending with ${paymentCard?.last4}',
                    style: const TextStyle(fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  Column(
                    spacing: 4,
                    children: [
                      CostRow(
                        'Subtotal',
                        order!.subTotal,
                        style: TextStyle(fontSize: 12),
                      ),
                      CostRow(
                        'Sales tax',
                        order!.taxTotal,
                        style: TextStyle(fontSize: 12),
                      ),
                      CostRow(
                        'Shipping cost',
                        order!.shippingTotal,
                        style: TextStyle(fontSize: 12),
                      ),
                      if(order!.discountTotal != null &&
                          order!.discountTotal! > 0)
                        CostRow(
                          'Discount',
                          -order!.discountTotal!,
                          style: TextStyle(fontSize: 12, color: Colors.green),
                        ),
                      if (order!.storeCreditUsed != null &&
                          order!.storeCreditUsed! > 0)
                        CostRow(
                          'Store Credit',
                          -order!.storeCreditUsed!,
                          style: TextStyle(fontSize: 12, color: Colors.green),
                        ),
                    ],
                  ),
                  Divider(height: 16, color: Colors.grey.shade100),
                  CostRow(
                    'Order total',
                    order!.orderTotal,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Cart Items
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                color: Colors.white,
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 16,
                children: [
                  Text(
                    'Order Summary',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ...List.generate(
                    order!.cartItems.length,
                    (index) {
                      final orderItem = order!.cartItems[index];
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox.square(
                            dimension: 64,
                            child: Image.network(
                              orderItem.imageUrl!,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  orderItem.productName,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  'YLS-SKU #${orderItem.sku.skuId}',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  orderItem.caption ?? '',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Text(
                                      'Quantity: ${orderItem.quantity}',
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                    const Spacer(),
                                    Text(
                                      orderItem.total.toCurrency(),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      );

                    },

                  ),

                  if (order?.virtualItems != null &&
                      order!.virtualItems.isNotEmpty) ...[
                    const SizedBox.shrink(),

                    Text(
                      'Video / Training Bundle',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ...order!.virtualItems.map(
                      (virtualItem) => MobileVirtualItemTile(item: virtualItem),
                    ),
                  ],
                  // if(order!.notes != null &&
                  //     order!.notes!.isNotEmpty && order!.notes!.any((e) => e.text == "Venus et Fleur")) ...[
                  //   const SizedBox(height: 8),
                  //   Text(
                  //     'You are getting a free Venus et Fleur Diffuser with this order.',
                  //     style: const TextStyle(
                  //       fontSize: 14,
                  //       fontWeight: FontWeight.bold,
                  //     ),
                  //   ),
                  // ],
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Free items
            if (order!.freeItems.isNotEmpty)
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  color: Colors.white,
                ),
                padding: const EdgeInsets.all(16),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 16,
                  children: [
                    const Text(
                      'Free Items',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ...List.generate(
                      order!.freeItems.length,
                      (index) {
                        final freeItem = order!.freeItems[index];
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox.square(
                              dimension: 64,
                              child: Image.network(
                                freeItem.imageUrl!,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    freeItem.productName,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    'YLS-SKU #${freeItem.skuId}',
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    freeItem.caption ?? '',
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Text(
                                        'Quantity: ${freeItem.quantity}',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
