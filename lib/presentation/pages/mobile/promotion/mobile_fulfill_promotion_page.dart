import 'package:YLift/core/controllers/global.dart';
import 'package:YLift/models/_clean/product.dart';
import 'package:YLift/presentation/components/mobile_scaffold.dart';
import 'package:YLift/presentation/pages/mobile/cart/components/mobile_cart_item_tile.dart';
import 'package:flutter/material.dart';
import 'package:galaxy_models/core/constants/y_lift_color.dart';
import 'package:galaxy_ui/galaxy_ui.dart';
import 'package:get/get.dart';

class MobileFulfillPromotionPage extends StatefulWidget {
  final String title;
  final String imageUrl;
  final bool isQualified;
  final int? vendorId;
  final String description;
  final String requirementText;

  const MobileFulfillPromotionPage({
    super.key,
    required this.title,
    required this.imageUrl,
    this.vendorId,
    this.isQualified = false,
    required this.description,
    required this.requirementText,
  });

  @override
  State<MobileFulfillPromotionPage> createState() =>
      _MobileFulfillPromotionPageState();
}

class _MobileFulfillPromotionPageState
    extends State<MobileFulfillPromotionPage> {
  final global = Get.find<GlobalController>();
  final products = <ProductSimple>[];

  bool isLoading = false;

  void addItem(String productSkuId, int quantity) async {
    try {
      setState(() {
        isLoading = true;
      });

      final profileId = global.user.value.profileId;
      await global.basket.addToCart(
        customerId: '$profileId',
        quantity: quantity,
        product: productSkuId,
      );
      setState(() {
        isLoading = false;
      });
      if (!mounted) return;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add item, please try again later'),
        ),
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    products.addAll(
      global.allProducts.value.getProductsByVendorIds(
        vendorIds: [widget.vendorId!],
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MobileScaffold(
      onBackPressed: () => Navigator.pop(context),
      title: widget.title,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16,
          children: [
            Image.network(widget.imageUrl),
            Text(
              widget.description,
              style: const TextStyle(fontSize: 14),
            ),
            ...products.map((product) {
              final quantity =
                  global.simpleCart.value.cartItems.firstWhereOrNull(
                    (item) {
                      return item.skuId == int.parse(product.skus!.first.skuId);
                    },
                  )?.quantity ??
                  0;

              final productSkuId =
                  '${product.productId}-${product.skus!.first.skuId}';

              final item = MobileProductData(
                productId: product.productId!,
                skuId: int.parse(product.skus!.first.skuId),
                productName: product.name,
                imageUrl: product.imageUrl,
                price: product.skus!.first.tieredPrice,
                skuAttributes: product.skus!.first.attributeName,
                quantity: quantity,
              );
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  color: Colors.white,
                ),
                padding: const EdgeInsets.all(16),
                child: MobileCartItemTile(
                  item: item,
                  onQuantityChanged: (value) => addItem(productSkuId, value),
                ),
              );
            }),
          ],
        ),
      ),
      bottomBar: MobileBar(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.requirementText,
              style: TextStyle(
                fontSize: 12,
                color:
                    widget.isQualified ? YLiftColor.green : YLiftColor.orange,
              ),
            ),
            const SizedBox(height: 8),
            GalaxyFilledButton(
              isExpanded: true,
              onPressed: isLoading ? null : () => Navigator.pop(context),
              child: const Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }
}
