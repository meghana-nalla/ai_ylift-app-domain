import 'package:YLift/core/controllers/carts/index.dart';
import 'package:YLift/core/controllers/global.dart';
import 'package:galaxy_models/galaxy_models.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:galaxy_ui/galaxy_ui.dart';
import 'package:YLift/models/z-index_export.dart';
import 'mobile_course__video_checkout_page.dart';
import 'package:YLift/presentation/pages/mobile/cart/components/mobile_cart_item_tile.dart';
import 'package:YLift/presentation/components/mobile_scaffold.dart';
import 'package:YLift/presentation/pages/desktop/cart/components/merz_promotion_dialog.dart';


class MobileFreeItemScreen extends StatefulWidget {
  final VirtualProduct product;
  final int radiesseQuantity;
  final int radiessePlusQuantity;

  const MobileFreeItemScreen({
    super.key,
    required this.product,
    required this.radiesseQuantity,
    required this.radiessePlusQuantity,});


  @override
  State<MobileFreeItemScreen> createState() => _MobileFreeItemScreenState();
}

class _MobileFreeItemScreenState extends State<MobileFreeItemScreen> {
  int radiesseFreeQuantity = 0;
  int radiessePlusFreeQuantity = 0;
  final global = Get.find<GlobalController>();
  MerzSyringePromotion? get merzSyringePromotion =>
      MerzSyringePromotion.getPromotion(
        widget.radiesseQuantity + widget.radiessePlusQuantity,
      );

  int get sharedMaxFreeQuantity {
    final merzPromotion = MerzSyringePromotion.getPromotion(
      widget.radiesseQuantity + widget.radiessePlusQuantity,
    );
    if (merzPromotion == null) return 0;

    return merzPromotion.freeBoxes -
        radiesseFreeQuantity -
        radiessePlusFreeQuantity;
  }


  ProductSimple get radiesseProduct => global.allProducts.value.getById(450)!;
  ProductSimple get radiessePlusProduct => global.allProducts.value.getById(449)!;


  bool isAddingToCart = false;
  bool isSuccessful = false;
  String? errorMessage;
  String? freeItemErrorMessage;

  void addToCart() async {
    try {
      setState(() {
        isAddingToCart = true;
      });

      final lastMinuteItems = [
        LastMinuteItem(
          radiesseProduct.skus!.first.combinedId,
          widget.radiesseQuantity,
        ),
        LastMinuteItem(
          radiessePlusProduct.skus!.first.combinedId,
          widget.radiessePlusQuantity,
        ),
      ];

      await global.basket.addVirtualItemToCart(
        virtualProductId: widget.product.id,
        lastMinuteItems: lastMinuteItems,
      );

      await global.basket.addFreeItem(
        product: '${radiesseProduct.productId!}-${radiesseProduct.skus!.first.skuId}',
        quantity: radiesseFreeQuantity,
      );
      await global.basket.addFreeItem(
        product: '${radiessePlusProduct.productId!}-${radiessePlusProduct.skus!.first.skuId}',
        quantity: radiessePlusFreeQuantity,
      );

      setState(() {
        isSuccessful = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Course and products added to cart successfully!'), backgroundColor: Colors.green),
      );

      global.simpleCart.refresh();

      Future.delayed(Duration(milliseconds: 1000), () {
        global.vroute.navigateTo('/cart');
      });
    } catch (e) {
      errorMessage = '$e';
    } finally {
      setState(() {
        isAddingToCart = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    final int totalSelected = radiesseFreeQuantity + radiessePlusFreeQuantity;
    final int allowed = merzSyringePromotion?.freeBoxes ?? 0;

    final bool allowNextSteps = totalSelected == allowed && freeItemErrorMessage == null;



    return MobileScaffold(
      title: "Free Items Selection",
      onBackPressed: () {
        Get.back();
      },
      backgroundColor: const Color(0xFFF8F8F8),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProductCard(),
                const SizedBox(height: 16),
                Text('Select Your ${merzSyringePromotion?.freeBoxes ?? 0} Free Items', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                const SizedBox(height: 16),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],

                  ),
                  child: MobileCartItemTile(
                    item: MobileProductData(
                      productId:  radiesseProduct.productId!,
                      skuId:       int.parse(radiesseProduct.skus!.first.skuId),
                      productName: radiesseProduct.name,
                      imageUrl:    radiesseProduct.imageUrl,
                      price:       radiesseProduct.skus!.first.tieredPrice,
                      skuAttributes: radiesseProduct.skus!.first.attributeName,
                      quantity:    radiesseFreeQuantity,
                      minimumQuantity: 0,
                      maximumQuantity: radiesseProduct.skus!.first.quantityMaximum,
                      incrementQuantity: radiesseProduct.skus!.first.quantityIncrement,
                    ),
                    onQuantityChanged: (qty) {
                      final allowed = merzSyringePromotion?.freeBoxes ?? 0;
                      final proposedTotal = qty + radiessePlusFreeQuantity;
                      if (qty < radiesseFreeQuantity || proposedTotal <= allowed) {
                        setState(() {
                          radiesseFreeQuantity = qty;
                          freeItemErrorMessage = null;
                        });
                      } else {
                        setState(() {
                          freeItemErrorMessage = 'You can only select $allowed free items in total.';
                        });
                      }
                    },



                    hidePrice: false,
                  ),
                ),
                SizedBox(height: 16,),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],

                  ),
                  child: MobileCartItemTile(
                    item: MobileProductData(
                      productId:  radiessePlusProduct.productId!,
                      skuId:       int.parse(radiessePlusProduct.skus!.first.skuId),
                      productName: radiessePlusProduct.name,
                      imageUrl:    radiessePlusProduct.imageUrl,
                      price:       radiessePlusProduct.skus!.first.tieredPrice,
                      skuAttributes: radiessePlusProduct.skus!.first.attributeName,
                      quantity:    radiessePlusFreeQuantity,
                      minimumQuantity: 0,
                      maximumQuantity: radiessePlusProduct.skus!.first.quantityMaximum,
                      incrementQuantity: radiessePlusProduct.skus!.first.quantityIncrement,
                    ),
                    onQuantityChanged: (qty) {
                      final allowed = merzSyringePromotion?.freeBoxes ?? 0;
                      final proposedTotal = qty + radiesseFreeQuantity;

                      if (qty < radiessePlusFreeQuantity ||  proposedTotal <= allowed) {
                        setState(() {
                          radiessePlusFreeQuantity = qty;
                          freeItemErrorMessage = null;
                        });
                      } else {
                        setState(() {
                          freeItemErrorMessage = 'You can only select $allowed free items in total.';
                        });
                      }
                    },


                    hidePrice: false,


                  ),
                ),




                // MobileRadiesseProductView(
                //   name: radiesseProduct.name,
                //   imageUrl: radiesseProduct.imageUrl,
                //   price: radiesseProduct.skus!.first.tieredPrice.toCurrency(),
                //   skuAttributes: radiesseProduct.skus!.first.attributeName,
                //   quantity: radiesseFreeQuantity,
                //   maxQuantity: 3,
                //   onQuantityChanged: (qty) {
                //     final total = qty + radiessePlusFreeQuantity;
                //     if (total <= 3) {
                //       setState(() => radiesseFreeQuantity = qty);
                //     }
                //   },
                // ),
                // MobileRadiesseProductView(
                //   name: radiessePlusProduct.name,
                //   imageUrl: radiessePlusProduct.imageUrl,
                //   price: radiesseProduct.skus!.first.tieredPrice.toCurrency(),
                //   skuAttributes: radiessePlusProduct.skus!.first.attributeName,
                //   quantity: radiessePlusFreeQuantity,
                //   maxQuantity: 3,
                //   onQuantityChanged: (qty) {
                //     final total = qty + radiesseFreeQuantity;
                //     if (total <= 3) {
                //       setState(() => radiessePlusFreeQuantity = qty);
                //     }
                //   },
                // ),
              ],
            ),
          ),
          if (freeItemErrorMessage != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                freeItemErrorMessage!,
                style: TextStyle(color: Colors.red, fontSize: 14),
              ),
            ),


        ],
      ),
      bottomBar: _buildBottomBar(
        allowNextSteps: allowNextSteps,
        isProcessing: isAddingToCart,
        totalQuantity: radiesseFreeQuantity + radiessePlusFreeQuantity,
        onNext: _handleFreeNext,
      ),

    );
  }

  Widget _buildTopBar() {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE2E2E2)),
      ),
      child: Center(
        child: Text(
          'Course Checkout',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomBar({
    required bool allowNextSteps,
    required int totalQuantity,
    required bool isProcessing,
    required VoidCallback onNext,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: const Color(0xFFE2E2E2)),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text(
                'Selected:',
                style: TextStyle(
                  color: Color(0xFF343434),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '$totalQuantity items',
                style: const TextStyle(
                  color: Color(0xFF787878),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          GalaxyFilledButton(
            shape: GalaxyButtonShape.stadium,
            isExpanded: true,
            backgroundColor: allowNextSteps
                ? (isProcessing ? const Color(0xFF004CBA)   // “pressed” blue
                : const Color(0xFF006AFF))  // normal blue
                : Colors.grey.shade400,
            onPressed: allowNextSteps ? onNext : null,
            child: const Text(
              'Checkout',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard() {
    return Row(
      children: [
        Container(
          width: 112,
          height: 63,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            image: DecorationImage(
              image: NetworkImage(widget.product.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.product.name,
                style: TextStyle(
                  color: const Color(0xFF0F0F0F),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Unlock with ${widget.product.tradingMetadata?.requirementQuantity ?? 10}-Radiesse Purchase',
                style: TextStyle(
                  color: const Color(0xFF787878),
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _handleFreeNext() {
    final allowed = merzSyringePromotion?.freeBoxes ?? 0;
    final totalSelected = radiesseFreeQuantity + radiessePlusFreeQuantity;

    if (totalSelected != allowed || freeItemErrorMessage != null) return;

    addToCart();
  }

}

// class MobileRadiesseProductView extends StatelessWidget {
//   final String name;
//   final String? skuAttributes;
//   final String imageUrl;
//   final String price;
//   final int quantity;
//   final int maxQuantity;
//   final void Function(int quantity) onQuantityChanged;
//
//   const MobileRadiesseProductView({
//     super.key,
//     required this.name,
//     required this.imageUrl,
//     required this.price,
//     this.skuAttributes,
//     required this.quantity,
//     this.maxQuantity = 200,
//     required this.onQuantityChanged,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: Colors.grey.shade300),
//       ),
//       child: Row(
//         children: [
//           ClipRRect(
//             borderRadius: BorderRadius.circular(8),
//             child: Image.network(
//               imageUrl,
//               width: 80,
//               height: 80,
//               fit: BoxFit.cover,
//             ),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
//                 if (skuAttributes != null)
//                   Text(
//                     skuAttributes!,
//                     style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
//                   ),
//                 const SizedBox(height: 8),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(price, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
//                     Row(
//                       children: [
//                         IconButton(
//                           icon: const Icon(Icons.remove_circle_outline),
//                           onPressed: quantity > 0 ? () => onQuantityChanged(quantity - 1) : null,
//                         ),
//                         Text('$quantity', style: const TextStyle(fontSize: 14)),
//                         IconButton(
//                           icon: const Icon(Icons.add_circle_outline),
//                           onPressed: quantity < maxQuantity ? () => onQuantityChanged(quantity + 1) : null,
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

