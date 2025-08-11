import 'dart:math';

import 'package:YLift/core/controllers/global.dart';
import 'package:YLift/presentation/components/mobile_scaffold.dart';
import 'package:YLift/presentation/pages/desktop/cart/components/merz_promotion_dialog.dart';
import 'package:YLift/presentation/pages/mobile/cart/components/mobile_cart_item_tile.dart';
import 'package:flutter/material.dart';
import 'package:galaxy_models/galaxy_models.dart';
import 'package:get/get.dart';

class MobileFreeRadiessePage extends StatefulWidget {
  const MobileFreeRadiessePage({super.key});

  @override
  State<MobileFreeRadiessePage> createState() => _MobileFreeRadiessePageState();
}

class _MobileFreeRadiessePageState extends State<MobileFreeRadiessePage> {
  final global = Get.find<GlobalController>();

  MerzSyringePromotion? get promotion => global.simpleCart.value.merzPromotion;

  FreeCartItem? get freeRadiesse =>
      global.simpleCart.value.freeItems.firstWhereOrNull(
        (element) => element.productId == 450,
      );

  FreeCartItem? get freeRadiessePlus =>
      global.simpleCart.value.freeItems.firstWhereOrNull(
        (element) => element.productId == 449,
      );

  MobileProductData get radiesse {
    final radiesse =
        global.allProducts.value.getById(
          450,
        )!;
    final sharedQuantity =
        promotion!.freeBoxes - (freeRadiessePlus?.quantity ?? 0);
    final maxQuantity = max(freeRadiesse?.quantity ?? 0, sharedQuantity);
    return MobileProductData(
      productId: radiesse.productId!,
      skuId: int.parse(radiesse.skus!.first.skuId),
      productName: radiesse.name,
      imageUrl: radiesse.imageUrl,
      price: radiesse.skus!.first.tieredPrice,
      skuAttributes: radiesse.skus!.first.attributeName,
      quantity: freeRadiesse?.quantity ?? 0,
      maximumQuantity: maxQuantity,
    );
  }

  MobileProductData get radiessePlus {
    final radiessePlus =
        global.allProducts.value.getById(
          449,
        )!;
    final sharedQuantity = promotion!.freeBoxes - (freeRadiesse?.quantity ?? 0);
    final maxQuantity = max(freeRadiesse?.quantity ?? 0, sharedQuantity);
    return MobileProductData(
      productId: radiessePlus.productId!,
      skuId: int.parse(radiessePlus.skus!.first.skuId),
      productName: radiessePlus.name,
      imageUrl: radiessePlus.imageUrl,
      price: radiessePlus.skus!.first.tieredPrice,
      skuAttributes: radiessePlus.skus!.first.attributeName,
      quantity: freeRadiessePlus?.quantity ?? 0,
      maximumQuantity: maxQuantity,
    );
  }

  bool get isContinue {
    final freeRadiesseQuantity = freeRadiesse?.quantity ?? 0;
    final freeRadiessePlusQuantity = freeRadiessePlus?.quantity ?? 0;
    return freeRadiesseQuantity + freeRadiessePlusQuantity ==
        promotion!.freeBoxes;
  }

  @override
  Widget build(BuildContext context) {
    if (promotion == null) {
      return const _FreeRadiesseUnavailablePage();
    }
    return MobileScaffold(
      title: 'Merz Syringe Promotion',
      onBackPressed: () => Navigator.pop(context),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Choose your ${promotion!.freeBoxes} free products',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Select your mix & match',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    color: Colors.white,
                  ),
                  padding: const EdgeInsets.all(16),
                  child: MobileCartItemTile(
                    item: radiesse,
                    hidePrice: true,
                    onQuantityChanged: (value) async {
                      await global.basket.addFreeItem(
                        product: '${radiesse.productId}-${radiesse.skuId}',
                        quantity: value,
                      );
                      setState(() {});
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    color: Colors.white,
                  ),
                  padding: const EdgeInsets.all(16),
                  child: MobileCartItemTile(
                    item: radiessePlus,
                    hidePrice: true,
                    onQuantityChanged: (value) async {
                      await global.basket.addFreeItem(
                        product:
                            '${radiessePlus.productId}-${radiessePlus.skuId}',
                        quantity: value,
                      );
                      setState(() {});
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomBar: MobileBar(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: YLiftColor.orange,
                  foregroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                ),
                onPressed:
                    isContinue
                        ? () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        }
                        : null,
                child: const Text('Continue'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FreeRadiesseUnavailablePage extends StatelessWidget {
  const _FreeRadiesseUnavailablePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MobileScaffold(
      onBackPressed: () => Navigator.pop(context),
      title: 'Merz Syringe Promotion',
      body: const Center(
        child: Column(
          children: [
            Text(
              'Merz Free Syringe promotion is not applicable at this time.\n Please add more radiesse to your cart.',
            ),
          ],
        ),
      ),
    );
  }
}
