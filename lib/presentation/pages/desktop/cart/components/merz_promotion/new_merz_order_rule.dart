import 'package:YLift/core/constants/color.dart';
import 'package:YLift/core/controllers/global.dart';
import 'package:YLift/presentation/components/_complex/dialogs/select_merz_dialog.dart';
import 'package:YLift/presentation/pages/desktop/cart/components/merz_promotion_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewMerzOrderRule extends StatelessWidget {
  const NewMerzOrderRule({super.key});

  static final global = Get.find<GlobalController>();
  MerzSyringePromotion get merzPromotion =>
      global.simpleCart.value.merzPromotion!;
  bool get isQualified =>
      global.simpleCart.value.merzTotalFreeSyringes ==
      merzPromotion.freeSyringes;

  void showMerzDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Obx(() {
          final merzPromotion = global.simpleCart.value.merzPromotion!;
          return SelectMerzDialog(
            merzPromotion: global.simpleCart.value.merzPromotion!,
            title:
                'Select your ${merzPromotion.freeBoxes} free boxes (${merzPromotion.freeSyringes} syringes)',
            products: global.allProducts.value.getProductsByBrandIds(
              brandIds: [MerzSyringePromotion.brandId],
            ),
            freeItems: global.simpleCart.value.merzFreeItems,
            maxQuantity: merzPromotion.freeBoxes,
            onProductQuantityChanged: (sku, newQuantity) {
              global.basket.addFreeItem(
                product: sku.combinedId,
                quantity: newQuantity,
              );
            },
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Text(
                  'Merz',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13.33,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                isQualified
                    ? Icon(Icons.check, color: Colors.green, size: 13.33)
                    : const Icon(
                      Icons.info_outline,
                      color: YLiftColor.orange,
                      size: 13.33,
                    ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: InkWell(
              onTap: () {
                showMerzDialog(context);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                width: double.infinity,
                child:
                    isQualified
                        ? Text(
                          'Reward selected, click to edit.',
                          style: TextStyle(
                            fontSize: 13.33,
                            color: Colors.white,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.white,
                          ),
                        )
                        : Text(
                          'Select your ${merzPromotion.freeBoxes} free boxes (${merzPromotion.freeSyringes} syringes)',
                          style: TextStyle(
                            fontSize: 13.33,
                            color: YLiftColor.orange,
                            decoration: TextDecoration.underline,
                            decorationColor: YLiftColor.orange,
                          ),
                        ),
              ),
            ),
          ),
          ...global.simpleCart.value.merzFreeItems.map((freeItem) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                '${freeItem.productName}: ${freeItem.quantity} boxes (${freeItem.quantity * 2} syringes)',
                style: TextStyle(
                  fontSize: 11.11,
                  height: 1.6,
                  color: Colors.white,
                ),
              ),
            );
          }),
        ],
      );
    });
  }
}
