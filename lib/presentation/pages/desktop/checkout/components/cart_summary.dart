import 'package:flutter/material.dart';
import 'package:galaxy_ui/galaxy_ui.dart';
import 'package:get/get.dart';
import 'package:YLift/core/constants/constant.dart';
import 'package:YLift/core/constants/text_style.dart';
import 'package:YLift/presentation/components/_complex/z-index_export.dart';
import 'package:YLift/presentation/components/z-index_export.dart';

import 'package:YLift/core/controllers/global.dart';


class CartSummary extends StatefulWidget {
  const CartSummary({super.key});

  @override
  State<CartSummary> createState() => _CartSummaryState();
}

class _CartSummaryState extends State<CartSummary> {
  final controller = Get.find<GlobalController>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  Widget _buildLoadingIndicator() {
    return const SizedBox(
      height: 200,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: Color.fromRGBO(114, 95, 95, 0.5019607843137255),
            ),
            SizedBox(height: YLiftConstant.gap),
            Text('Please wait loading your data...'),
          ],
        ),
      ),
    );
  }

  Widget _buildCartItem({
    required int vendorIndex,
    required int itemIndex,
  }) {
    final item = controller.cart.value.shoppingItems[vendorIndex].items![itemIndex];

    return FutureBuilder(
      future: controller.products.getSkuInfo(
        int.parse(item.sku ?? item.productId.toString()),
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 80,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return SizedBox(
            height: 80,
            child: Row(
              children: [
                const AspectRatio(
                  aspectRatio: 1,
                  child: Icon(Icons.error),
                ),
                const Gap(),
                Expanded(
                  child: Text(item.productName ?? 'Product Name Not Available'),
                ),
                const Gap(),
                Text(
                  '\$${(item.price as double) / 100.00}',
                  style: YLiftTextStyle.descriptionGrey,
                ),
              ],
            ),
          );
        }

        // final imageUrl = snapshot.data?.product?.productMedia?[0].url ?? '';

        return SizedBox(
          height: 80,
          child: Row(
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: Image.network(
                  // imageUrl, // TODO uncomment
                  "",
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                            : null,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.error);
                  },
                ),
              ),
              const Gap(),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.productName ?? ''),
                    Text(
                      'Qty: ${item.quantity ?? 1}',
                      style: const TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const Gap(),
              Text(
                '\$${(item.price ?? 0) * (item.quantity ?? 1) / 100.00}',
                style: YLiftTextStyle.descriptionGrey,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCartItems() {
    final items = controller.cart.value.shoppingItems;
    final maxHeight = items.length < 4 ? null : 440.0;

    return SizedBox(
      height: maxHeight,
      child: Column(
        children: [
          for (int vendorIndex = 0; vendorIndex < items.length; vendorIndex++)
            for (int itemIndex = 0; itemIndex < items[vendorIndex].items!.length; itemIndex++)
              _buildCartItem(
                vendorIndex: vendorIndex,
                itemIndex: itemIndex,
              ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (controller.cart.value.shoppingItems.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${controller.cart.value.numberOfVendorItems ?? 0} item(s)',
            ),
            // if (BETA) ...[
            //   UnderlinedTextButton(
            //     text: 'Edit',
            //     onPressed: () {},
            //   ),
            // ]
          ],
        ),
        const Divider(height: YLiftConstant.gap * 2),
        _buildCartItems(),
        const Divider(height: YLiftConstant.gap * 2),
        // TODO : WHY IS THIS DIVERGING FROM THE SIMPLE CART.. WHATS THE PURPOSE OF THIS
        CartCostBreakdown(
          subtotal: controller.cart.value.checkout?.subtotal ?? 0,
          salesTax: controller.cart.value.checkout?.tax ?? 0,
          shippingCost: controller.cart.value.checkout?.shipping ?? 0,
          total: controller.simpleCart.value.cartBillablePrice(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GalaxyPanel(
      child: _isLoading ? _buildLoadingIndicator() : _buildContent(),
    );
  }
}
