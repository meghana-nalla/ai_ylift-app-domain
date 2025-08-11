import 'package:YLift/core/controllers/global.dart';
import 'package:YLift/hardcodes/constants/ids.dart';
import 'package:YLift/hardcodes/promotions/summer_glow_july_15/summer_glow_promotion.dart';
import 'package:YLift/models/simple/home_promotion_banner_data.dart';
import 'package:YLift/models/z-index_export.dart';
import 'package:YLift/presentation/components/mobile_scaffold.dart';
import 'package:YLift/presentation/pages/desktop/cart/components/merz_promotion_dialog.dart';
import 'package:YLift/presentation/pages/mobile/promotion/mobile_fulfill_promotion_page.dart';
import 'package:YLift/presentation/pages/mobile/promotion/mobile_radiesse_promotion_info_page.dart';
import 'package:flutter/material.dart';
import 'package:galaxy_models/galaxy_models.dart';
import 'package:galaxy_ui/galaxy_ui.dart';
import 'package:get/get.dart';

import 'promotion_product_selection_screen.dart';

class MobileCartPromotionPage extends StatefulWidget {
  const MobileCartPromotionPage({super.key});

  @override
  State<MobileCartPromotionPage> createState() =>
      _MobileCartPromotionPageState();
}

class _MobileCartPromotionPageState extends State<MobileCartPromotionPage> {
  final GlobalController global = Get.find<GlobalController>();
  bool isLoading = false;

  late final List<HomePromotionBannerData> promotions;

  @override
  void initState() {
    promotions = HomePromotionBannerData.activePromotions;
    super.initState();
  }

  void goToCheckout() {
    global.vroute.navigateTo('/checkout');
  }

  void _handleCartUpdate(Map<String, int> selectedQuantities) async {
    try {
      setState(() {
        isLoading = true;
      });
      final customerId = global.user.value.profileId.toString();

      for (var entry in selectedQuantities.entries) {
        final productId = int.parse(entry.key.split('-').first);
        final skuId = int.parse(entry.key.split('-').last);

        final existingItem = global.simpleCart.value.cartItems.firstWhereOrNull(
          (e) => e.productId == productId,
        );

        final existingQty = existingItem?.quantity ?? 0;
        final newQty = entry.value;

        // Only send request if quantity changed
        if (newQty != existingQty) {
          if (newQty > 0) {
            if (existingItem != null) {
              await global.basket.updateCartItemQuantity(
                profileId: customerId,
                quantity: newQty,
                product: '$productId-$skuId',
              );
            } else {
              await global.basket.addToCart(
                customerId: customerId,
                quantity: newQty,
                product: '$productId-$skuId',
              );
            }
          } else if (existingItem != null) {
            // Handle removal if user reduces quantity to 0
            await global.basket.deleteCartItem(
              productId: '$productId-$skuId',
              profileId: customerId,
            );
          }
        }
      }

      await global.basket.refreshCart();
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update cart, please try again later.'),
        ),
      );
      print('Error in _handleCartUpdate: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MobileScaffold(
      title: 'Promotions',
      onBackPressed: () {
        global.vroute.navigateTo('/cart');
      },
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Promotions Page Headline
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Maximize Your Savings Before Checkout!',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Here are promotions associated with items in your cart:',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (global.simpleCart.value.merzItems.isNotEmpty) ...[
                    Builder(
                      builder: (_) {
                        final merzTotalBoxes =
                            global.simpleCart.value.merzTotalBoxes;
                        final currentPromo = MerzSyringePromotion.getPromotion(
                          merzTotalBoxes,
                        );
                        final isCompleted =
                            global.simpleCart.value.isMerzPromotionSatisfied;

                        final hasEnoughBoxes = merzTotalBoxes >= 30;
                        final bootyLiftIncluded =
                            global.simpleCart.value.bootYliftIncluded;
                        final bootyLiftCompleted =
                            hasEnoughBoxes && bootyLiftIncluded;

                        final bootyLiftRewardsText =
                            bootyLiftCompleted
                                ? 'Free Items: BootyLift Training Video'
                                : hasEnoughBoxes
                                ? 'Eligible - Add Training at Checkout'
                                : 'Not Eligible for this offer';

                        return Column(
                          children: [
                            PromoContainer(
                              title: 'Merz Free Syringes',
                              isQualified: isCompleted,
                              imageUrl: MerzSyringePromotion.bannerImageUrl,
                              inCartText: 'Radiesse in cart: $merzTotalBoxes',
                              rewardsText:
                                  'Free Items: ${currentPromo?.freeBoxes ?? 0} Radiesse boxes',
                              progressText: MerzSyringePromotion.getMessage(
                                merzTotalBoxes,
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (
                                          context,
                                        ) => MobileRadiessePromotionInfoPage(
                                          promotionData: MobilePromotionData(
                                            imageUrl:
                                                MerzSyringePromotion
                                                    .bannerImageUrl,
                                            title: 'Merz Syringe Promotion',
                                            description:
                                                'Add Radiesse products and get more free Radiesse products!',
                                            productSkuIds: [
                                              '450-2024',
                                              '449-2022',
                                            ],
                                          ),
                                          // onComplete: (selectedQuantities) {},
                                        ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 16),
                            PromoContainer(
                              title: 'BootyLift Training Promotion',
                              isQualified:
                                  bootyLiftCompleted, // You might want logic here too
                              imageUrl: MerzSyringePromotion.bannerImageUrl,
                              inCartText: 'Radiesse in cart: $merzTotalBoxes',
                              rewardsText: bootyLiftRewardsText,
                              progressText:
                                  hasEnoughBoxes
                                      ? (bootyLiftIncluded
                                          ? 'Training added to cart'
                                          : 'Eligible for Training')
                                      : 'Add ${30 - merzTotalBoxes} more to get a free BootyLift Training Video',
                              onTap: () {
                                final radiesse =
                                    global.allProducts.value.getById(450)!;
                                final radiessePlus =
                                    global.allProducts.value.getById(449)!;

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) => PromotionProductSelectionScreen(
                                          promotionData: MobilePromotionData(
                                            imageUrl:
                                                MerzSyringePromotion
                                                    .bannerImageUrl,
                                            title: 'BootYLift',
                                            description:
                                                'Add Radiesse products to unlock BootyLift Training Video',
                                            productSkuIds: [
                                              '450-2024',
                                              '449-2022',
                                            ],
                                            minimumQuantity: 30,
                                          ),
                                          isLoading: isLoading,
                                          onComplete: _handleCartUpdate,
                                        ),
                                  ),
                                );
                              },
                            ),
                          ],
                        );
                      },
                    ),
                  ],

                  // // Summer Glow Promotion
                  // if (SummerGlowPromotion.isOngoing &&
                  //     SummerGlowPromotion.galdermaItems.isNotEmpty) ...[
                  //   const SizedBox(height: 16),
                  //   PromoContainer(
                  //     title: 'Summer Glow Promotion',
                  //     isQualified:
                  //         SummerGlowPromotion.getCurrentPromotion() != null,
                  //     imageUrl: SummerGlowPromotion.imageUrl,
                  //     inCartText:
                  //         'Galderma products in cart: ${SummerGlowPromotion.totalGaldermaQuantity}',
                  //     rewardsText: '',
                  //     // rewardsText: SummerGlowPromotion.getRewardsText(global.simpleCart.value.summerGlowRewards),
                  //     progressText:
                  //         SummerGlowPromotion.getCurrentPromotion() != null
                  //             ? 'You get ${SummerGlowPromotion.getCurrentPromotion()?.providerCodes} provider codes'
                  //             : 'Add ${(SummerGlowPromotion.getNextPromotion()?.qualifyingQuantity ?? 0) - SummerGlowPromotion.totalGaldermaQuantity} more of Galderma products',
                  //     onTap: () {
                  //       Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //           builder: (context) {
                  //             return Obx(() {
                  //               return MobileFulfillPromotionPage(
                  //                 title: 'Summer Glow (Galderma)',
                  //                 imageUrl: SummerGlowPromotion.imageUrl,
                  //                 description: SummerGlowPromotion.list
                  //                     .map(
                  //                       (e) =>
                  //                           '- Buy ${e.qualifyingQuantity}, get ${e.providerCodes} provider codes',
                  //                     )
                  //                     .join('\n'),
                  //                 isQualified:
                  //                     SummerGlowPromotion.getCurrentPromotion() !=
                  //                     null,
                  //                 requirementText:
                  //                     SummerGlowPromotion.getCurrentPromotion() !=
                  //                             null
                  //                         ? 'You have ${SummerGlowPromotion.totalGaldermaQuantity} of Galderma products in cart\nYou get ${SummerGlowPromotion.getCurrentPromotion()?.providerCodes} provider codes.'
                  //                         : 'You have ${SummerGlowPromotion.totalGaldermaQuantity} of Galderma products in cart\nAdd ${(SummerGlowPromotion.getNextPromotion()?.qualifyingQuantity ?? 0) - SummerGlowPromotion.totalGaldermaQuantity} more of Galderma products.',
                  //                 vendorId: VendorId.galderma,
                  //               );
                  //             });
                  //           },
                  //         ),
                  //       );
                  //     },
                  //   ),
                  // ],
                  //
                  // if (SummerGlowPromotion.isOngoing &&
                  //     SummerGlowPromotion.galdermaItems.isNotEmpty) ...[
                  //   const SizedBox(height: 16),
                  //   PromoContainer(
                  //     title: 'Venus et Fleur Diffuser',
                  //     isQualified: SummerGlowPromotion.isEligibleForVEFDiffuser,
                  //     imageUrl: SummerGlowPromotion.imageUrl,
                  //     inCartText:
                  //         'Galderma purchase: ${SummerGlowPromotion.totalGaldermaPurchase.toCurrency()}',
                  //     rewardsText: '',
                  //     progressText:
                  //         SummerGlowPromotion.isEligibleForVEFDiffuser
                  //             ? 'Eligible for a complementary Venus et Fleur'
                  //             : 'Spend ${(1500000 - SummerGlowPromotion.totalGaldermaPurchase).toCurrency()} more and receive a complimentary Venus et Fleur Diffuser',
                  //     onTap: () {
                  //       Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //           builder: (context) {
                  //             return Obx(() {
                  //               return MobileFulfillPromotionPage(
                  //                 title: 'Venus et Fleur',
                  //                 imageUrl: SummerGlowPromotion.imageUrl,
                  //                 description:
                  //                     'Spend at least ${1500000.toCurrency()} on Galderma products to receive a complimentary Venus et Fleur Diffuser.',
                  //                 isQualified:
                  //                     SummerGlowPromotion
                  //                         .isEligibleForVEFDiffuser,
                  //                 requirementText:
                  //                     SummerGlowPromotion
                  //                             .isEligibleForVEFDiffuser
                  //                         ? 'Eligible for a complementary Venus et Fleur'
                  //                         : 'Spend ${(1500000 - SummerGlowPromotion.totalGaldermaPurchase).toCurrency()} more and receive a complimentary Venus et Fleur Diffuser',
                  //                 vendorId: VendorId.galderma,
                  //               );
                  //             });
                  //           },
                  //         ),
                  //       );
                  //     },
                  //   ),
                  // ],
                ],
              ),
            ),
          ),
        ],
      ),
      bottomBar: MobileBar(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
          children: [
            if (global.simpleCart.value.merzItems.isNotEmpty && !global.simpleCart.value.isMerzPromotionSatisfied)
              Text(
                'Please fulfill Merz Free Syringes promotion and select your free products.',
                style: const TextStyle(fontSize: 12, color: Colors.red),
              ),
            GalaxyFilledButton(
              isExpanded: true,
              backgroundColor: YLiftColor.orange,
              onPressed:
                  global.simpleCart.value.isCheckoutable ? goToCheckout : null,
              child: const Text('Checkout Now'),
            ),
          ],
        ),
      ),
    );
  }
}
