import 'dart:js_interop';

import 'package:YLift/core/constants/constant.dart';
import 'package:YLift/core/constants/text_style.dart';
import 'package:galaxy_models/galaxy_models.dart';
import 'package:galaxy_models/galaxy_models.dart';
import 'package:YLift/presentation/components/z-index_export.dart';
import 'package:YLift/presentation/pages/desktop/order_confirmation/components/order_virtual_items_section.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:galaxy_ui/galaxy_ui.dart';

class OrderSummaryPanel extends StatelessWidget {
  final OrderSimple order;

  const OrderSummaryPanel({super.key, required this.order});

  static final currencyFormat = NumberFormat.currency(symbol: '\$');
  static final costStyle = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  int get orderTotal {
    var total = order.orderTotal;
    if (order.storeCreditUsed != null) total -= order.storeCreditUsed!;
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return GalaxyPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Order Summary',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 80),
              Text(
                'Order #${order.label}',
                style: const TextStyle(color: YLiftColor.grey),
              ),
            ],
          ),
          const SizedBox(height: YLiftConstant.gap),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListView.separated(
                      shrinkWrap: true,
                      itemCount: order.cartItems.length,
                      separatorBuilder:
                          (context, index) =>
                              const SizedBox(height: YLiftConstant.gap),
                      itemBuilder: (context, index) {
                        final cartItem = order.cartItems[index];
                        final addressIndex = cartItem.shippingAddress;

                        return OrderProductTile(
                          productId: '$index',
                          imageUrl: cartItem.imageUrl,
                          name: cartItem.productName,
                          description: cartItem.caption,
                          price: cartItem.total,
                          sku: cartItem.sku.skuId,
                          variety: cartItem.sku.attributeName,
                          quantity: cartItem.quantity,
                          address:
                              order.optionalAddress?[addressIndex] ??
                              order.shippingAddress,
                          shippingQuantities: cartItem.shippingQuantities,
                          optionalAddresses: order.optionalAddress,
                        );
                      },
                    ),
                    if (order.virtualItems.isNotEmpty) ...[
                      const SizedBox(height: 32),
                      OrderVirtualItemsSection(items: order.virtualItems),
                    ],
                  ],
                ),
              ),
              const VerticalDivider(width: YLiftConstant.gap * 2),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Payment Details',
                      style: YLiftTextStyle.bodyLarge.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 32),
                    const Text('Billing Information'),
                    const SizedBox(height: 16),
                    Text(order.customerName ?? '(No name)'),
                    Text(order.shippingAddress?.twoLines ?? '(No address)'),
                    const SizedBox(height: 32),
                    // CartCostBreakdown(
                    //   subtotal: order.subTotal,
                    //   salesTax: order.taxTotal,
                    //   shippingCost: order.shippingTotal,
                    //   additionalCharges: order.additionalChargeAmount,
                    //   refundedAmount: order.refundedAmount,
                    //   total: order.orderTotal,
                    // ),
                    CostRow(
                      'Subtotal',
                      order.subTotal,
                      style: costStyle,
                    ),
                    const SizedBox(height: 16),
                    CostRow(
                      'Sales tax',
                      order.taxTotal,
                      style: costStyle,
                    ),
                    const SizedBox(height: 16),
                    CostRow(
                      'Shipping cost',
                      order.shippingTotal,
                      style: costStyle,
                    ),
                    if (order.additionalChargeAmount > 0) ...[
                      const SizedBox(height: 16),
                      CostRow(
                        'Additional Charges',
                        -order.additionalChargeAmount!,
                      ),
                    ],
                    if (order.refundedAmount > 0) ...[
                      const SizedBox(height: 16),
                      CostRow(
                        'Refunds',
                        -order.refundedAmount,
                        style: costStyle.copyWith(color: Colors.green),
                      ),
                    ],
                    if (order.storeCreditUsed != null &&
                        order.storeCreditUsed! > 0) ...[
                      const SizedBox(height: 16),
                      CostRow(
                        'Store Credit',
                        -order.storeCreditUsed!,
                        style: costStyle.copyWith(color: Colors.green),
                      ),
                    ],

                    const Divider(height: 32),
                    CostRow(
                      'Order Total',
                      orderTotal,
                      style: costStyle.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    if (order.termPayments != null &&
                        order.termPayments!.isNotEmpty) ...[
                      const SizedBox(height: 32),
                      Text(
                        'Term Payments',
                        style: YLiftTextStyle.bodyLarge.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      if (order.termPayments != null &&
                          order.termPayments!.isNotEmpty) ...[
                        Text(
                          'Initial Payment: ${order.termPayments!.first.termAmount.toCurrency()}',
                        ),
                        if (order.termPayments!.first.termPaymentDate != null)
                          Text(
                            'Paid on ${order.termPayments!.first.termPaymentDate!.yMMMd(withTime: true)}',
                            style: TextStyle(fontSize: 13.33),
                          ),
                        const SizedBox(height: 32),
                        Text(
                          'Next Payment: ${order.termPayments!.last.termAmount.toCurrency()}',
                        ),
                        if (order.termPayments!.last.termPaymentDate != null)
                          Text(
                            'Due on: ${order.termPayments!.last.termPaymentDate!.yMMMd(withTime: true)}',
                            style: TextStyle(fontSize: 13.33),
                          ),
                      ],
                    ],



                    // if(order.notes != null &&
                    // order.notes!.isNotEmpty && order.notes!.any((e) => e.text == "Venus et Fleur")) ...[
                    //   const SizedBox(height: 32),
                    //   Text(
                    //     'You are getting a free Venus et Fleur Diffuser with this order.',
                    //     style: YLiftTextStyle.bodyLarge.copyWith(
                    //       fontWeight: FontWeight.bold,
                    //     ),
                    //   ),
                    // ],

                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
