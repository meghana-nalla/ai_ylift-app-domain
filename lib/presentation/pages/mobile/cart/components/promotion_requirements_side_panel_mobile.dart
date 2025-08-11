import 'package:galaxy_models/galaxy_models.dart';
import 'package:flutter/material.dart';

class PromotionRequirementsSidePanelMobile extends StatelessWidget {
  final List<CartItemSimple> cartItems;
  final void Function(SkuSimple sku, int newQuantity) onQuantityUpdate;

  const PromotionRequirementsSidePanelMobile({
    super.key,
    this.cartItems = const <CartItemSimple>[],
    required this.onQuantityUpdate,
  });

  void showPromotionBottomSheet(BuildContext context, CartItemSimple cartItem) {
    final promotion = cartItem.promotion!;
    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Promotion for ${cartItem.productName}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
            const SizedBox(height: 8),
            Text(promotion.promotionItemMessage, style: const TextStyle(fontSize: 13)),
            const SizedBox(height: 8),
            Text(
              promotion.isPromotionApplied
                  ? 'Promotion applied!'
                  : promotion.promotionCartMessage,
              style: TextStyle(
                  color: promotion.isPromotionApplied ? Colors.green : YLiftColor.orange,
                  fontSize: 13),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    minimumSize: Size(100, 36), backgroundColor: YLiftColor.orange),
                onPressed: () => Navigator.pop(context),
                child: const Text('Done', style: TextStyle(fontSize: 13)),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (cartItems.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Promotion Requirements',
              style: TextStyle(fontWeight: FontWeight.w600)),
          const Divider(height: 16),
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: cartItems.length,
            separatorBuilder: (_, __) => const Divider(height: 12),
            itemBuilder: (context, index) {
              final cartItem = cartItems[index];
              final promotion = cartItem.promotion!;
              return InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () => showPromotionBottomSheet(context, cartItem),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 6.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(cartItem.productName,
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                      const SizedBox(height: 3),
                      Text(promotion.promotionItemMessage,
                          style: const TextStyle(fontSize: 12)),
                      const SizedBox(height: 2),
                      Text(
                        promotion.promotionCartMessage,
                        style: TextStyle(
                            fontSize: 12,
                            color: promotion.isPromotionApplied ? null : YLiftColor.orange),
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
