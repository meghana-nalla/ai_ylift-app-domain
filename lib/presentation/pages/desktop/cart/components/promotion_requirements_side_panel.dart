
import 'package:YLift/core/controllers/global.dart';
import 'package:galaxy_models/galaxy_models.dart';
import 'package:galaxy_models/galaxy_models.dart';
import 'package:YLift/presentation/components/_complex/desktop_view/panel.dart';
import 'package:YLift/presentation/components/_complex/dialogs/mix_match_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:galaxy_ui/galaxy_ui.dart';
import 'package:galaxy_models/galaxy_models.dart';

class PromotionRequirementsSidePanel extends StatelessWidget {
  final List<CartItemSimple> cartItems;
  final void Function(SkuSimple sku, int newQuantity) onQuantityUpdate;

  const PromotionRequirementsSidePanel({
    super.key,
    this.cartItems = const <CartItemSimple>[],
    required this.onQuantityUpdate,
  });

  void showPromotionDialog(BuildContext context, CartItemSimple cartItem) {
    final global = Get.find<GlobalController>();
    final product =
        global.allProducts.value.products.firstWhereOrNull((product) => product.productId == cartItem.productId);
    if (product == null) return;


    showDialog(
        context: context,
        builder: (context) {

          return Obx(() {
            final globalCartItem = global.simpleCart.value.cartItems.firstWhere((element) => element.skuId == cartItem.skuId);
            final promotion = globalCartItem.promotion!;

            return Dialog(
              child: SizedBox(
                width: 640,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Promotion Details for ${cartItem.productName}', style: TextStyle(fontSize: 24)),
                              Text(promotion.promotionItemMessage, style: TextStyle(fontSize: 13.33)),
                            ],
                          ),
                          const Spacer(),
                          CloseIconButton(),
                        ],
                      ),
                    ),
                    Container(
                      color: promotion.isPromotionApplied ? Colors.green : YLiftColor.orange,
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Text(
                        promotion.isPromotionApplied ? 'Promotion applied!' : promotion.promotionCartMessage,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13.33,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Center(
                            child: MixMaxProductTile(
                              product: product,
                              skuId: globalCartItem.skuId,
                              cartItem: globalCartItem,
                              onQuantityChanged: onQuantityUpdate,
                              showSkuLabel: true,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(
                                width: 120,
                                child: RoundedFilledButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Done'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    if (cartItems.isEmpty) return const SizedBox.shrink();

    return GalaxyPanel(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Promotion Requirements',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const Divider(height: 16),
          ListView.separated(
            shrinkWrap: true,
            itemCount: cartItems.length,
            separatorBuilder: (context, index) => const Divider(height: 16),
            itemBuilder: (context, index) {
              final cartItem = cartItems[index];
              final promotion = cartItem.promotion!;

              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => showPromotionDialog(context, cartItem),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cartItem.productName,
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13.33),
                      ),
                      const SizedBox(height: 4),
                      Text(promotion.promotionItemMessage, style: const TextStyle(fontSize: 11.11)),
                      const SizedBox(height: 4),
                      Text(
                        promotion.promotionCartMessage,
                        style: TextStyle(
                          fontSize: 11.11,
                          color: promotion.isPromotionApplied ? null : Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
