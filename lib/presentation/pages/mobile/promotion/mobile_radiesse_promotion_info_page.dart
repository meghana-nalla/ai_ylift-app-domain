import 'package:YLift/core/controllers/global.dart';
import 'package:YLift/presentation/components/mobile_scaffold.dart';
import 'package:YLift/presentation/pages/desktop/cart/components/merz_promotion_dialog.dart';
import 'package:YLift/presentation/pages/mobile/cart/components/mobile_cart_item_tile.dart';
import 'package:YLift/presentation/pages/mobile/promotion/mobile_free_radiesse_page.dart';
import 'package:YLift/presentation/pages/mobile/promotion/promotion_product_selection_screen.dart';
import 'package:flutter/material.dart';
import 'package:galaxy_models/core/constants/y_lift_color.dart';
import 'package:galaxy_ui/galaxy_ui.dart';
import 'package:get/get.dart';

class MobileRadiessePromotionInfoPage extends StatefulWidget {
  final MobilePromotionData promotionData;

  const MobileRadiessePromotionInfoPage({
    super.key,
    required this.promotionData,
  });

  @override
  State<MobileRadiessePromotionInfoPage> createState() =>
      _MobileRadiessePromotionInfoPageState();
}

class _MobileRadiessePromotionInfoPageState
    extends State<MobileRadiessePromotionInfoPage> {
  final global = Get.find<GlobalController>();

  final selectedQuantities = <String, int>{};

  int get totalQuantity =>
      selectedQuantities.values.fold(0, (sum, qty) => sum + qty);

  MerzSyringePromotion? get merzPromotion =>
      global.simpleCart.value.merzPromotion;
  bool get canContinue => merzPromotion != null && totalQuantity > 0;

  @override
  void initState() {
    super.initState();

    for (final productSkuId in widget.promotionData.productSkuIds) {
      final productId = productSkuId.split('-').first;
      final quantity =
          global.simpleCart.value.cartItems
              .firstWhereOrNull(
                (item) => item.productId == int.parse(productId),
              )
              ?.quantity;
      selectedQuantities[productSkuId] = quantity ?? 0;
    }
  }

  void goToFreeProductSelection() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MobileFreeRadiessePage(),
      ),
    );
  }

  bool isLoading = false;

  void addItem(String productSkuId, int quantity) async {
    try {
      setState(() {
        isLoading = true;
        selectedQuantities[productSkuId] = quantity;
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
  Widget build(BuildContext context) {
    return MobileScaffold(
      title: 'Merz Syringe Promotion',
      onBackPressed: () => Navigator.pop(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.network(
                  MerzSyringePromotion.bannerImageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Add Radiesse products and get more free Radiesse products!',
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: [
                _rowInfo('Buy 5 boxes of Radiesse, get 1 additional free'),
                _rowInfo('Buy 10 boxes of Radiesse, get 3 additional free'),
                _rowInfo('Buy 20 boxes of Radiesse, get 7 additional free'),
                _rowInfo('Buy 30 boxes of Radiesse, get 12 additional free'),
                _rowInfo('Buy 40 boxes of Radiesse, get 18 additional free'),
                _rowInfo('Buy 60 boxes of Radiesse, get 25 additional free'),
              ],
            ),

            const SizedBox(height: 32),
            Text(
              'Choose your products',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            ListView.separated(
              shrinkWrap: true,
              itemCount: widget.promotionData.productSkuIds.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (_, index) {
                final productSkuId = widget.promotionData.productSkuIds[index];
                final productId = productSkuId.split('-').first;
                final skuId = productSkuId.split('-').last;
                final product = global.allProducts.value.getById(
                  int.parse(productId),
                );
                final sku = product!.skus!.firstWhere(
                  (e) => e.skuId == skuId,
                );
                final quantity = selectedQuantities[productSkuId] ?? 0;

                final item = MobileProductData(
                  productId: int.parse(productId),
                  skuId: int.parse(skuId),
                  productName: product.name,
                  imageUrl: product.imageUrl,
                  price: sku.tieredPrice,
                  skuAttributes: sku.attributeName,
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
              },
            ),
          ],
        ),
      ),
      bottomBar: MobileBar(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              MerzSyringePromotion.getMessage(totalQuantity),
              style: const TextStyle(fontSize: 14, color: YLiftColor.orange),
            ),
            const SizedBox(height: 8),
            GalaxyFilledButton(
              isExpanded: true,
              backgroundColor: YLiftColor.orange,
              onPressed:
                  canContinue && !isLoading
                      ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => const MobileFreeRadiessePage(),
                          ),
                        );
                      }
                      : null,
              child:
                  canContinue
                      ? Text(
                        'Choose your ${merzPromotion!.freeBoxes} free products',
                      )
                      : const Text('Add products to continue'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _rowInfo(String message) {
    return Row(
      children: [
        const Icon(Icons.circle, size: 8),
        const SizedBox(width: 8),
        Text(
          message,
          style: TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}
