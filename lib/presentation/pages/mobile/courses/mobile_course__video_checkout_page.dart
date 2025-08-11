import 'package:YLift/core/controllers/carts/index.dart';
import 'package:YLift/core/controllers/global.dart';
import 'package:file_picker/file_picker.dart';
import 'package:galaxy_models/galaxy_models.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:galaxy_ui/galaxy_ui.dart';
import 'package:galaxy_models/galaxy_models.dart';
import 'package:YLift/models/z-index_export.dart';
import 'mobile_course_free_item_page.dart';
import 'package:YLift/presentation/pages/mobile/cart/components/mobile_cart_item_tile.dart';
import 'package:YLift/presentation/components/mobile_scaffold.dart';




class MobileCourseCheckoutScreen extends StatefulWidget {
  final VirtualProduct product;
  const MobileCourseCheckoutScreen({super.key, required this.product});

  @override
  State<MobileCourseCheckoutScreen> createState() => _MobileCourseCheckoutScreenState();
}


class _MobileCourseCheckoutScreenState extends State<MobileCourseCheckoutScreen> {
  final global = Get.find<GlobalController>();
  int selectedBundleIndex = 0;
  ProductSimple get radiesseProduct => global.allProducts.value.getById(450)!;
  ProductSimple get radiessePlusProduct => global.allProducts.value.getById(449)!;
  int radiesseQuantity = 0;
  int radiessePlusQuantity = 0;
  int radiesseFreeQuantity = 0;
  int radiessePlusFreeQuantity = 0;



  @override
  Widget build(BuildContext context) {
    final allowNextStep = (radiesseQuantity + radiessePlusQuantity) >= 10;
    return MobileScaffold(
      title: 'Course Checkout',
      onBackPressed: () {
        Navigator.pop(context);
      },
      backgroundColor: const Color(0xFFF8F8F8),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            _buildProductCard(),
            const SizedBox(height: 16),
            _buildRadiesseSelection(),
            const SizedBox(height: 16),

          ]
      ),
      ),
        bottomBar:
        _buildBottomBar(
          allowNextStep: (radiesseQuantity + radiessePlusQuantity) >= 10,
          totalQuantity: radiesseQuantity + radiessePlusQuantity,
          onNext: _handleProductNext,
        )
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

  Widget _buildRadiesseSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Add minimum of 10 boxes to unlock video course.',
          style: TextStyle(
            color: Color(0xFF0F0F0F),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Select Your Mix & Match',
          style: TextStyle(
            color: Color(0xFF787878),
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
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
              setState(() {
                radiesseQuantity = qty;
              });
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
              setState(() {
                radiessePlusQuantity = qty;
              });
            },
            hidePrice: false,
          ),
        ),


        // Product 1 - Radiesse
        // MobileRadiesseProductView(
        //   name: radiesseProduct.name,
        //   imageUrl: radiesseProduct.imageUrl,
        //   price: radiesseProduct.skus!.first.tieredPrice.toCurrency(),
        //   skuAttributes: radiesseProduct.skus!.first.attributeName,
        //   quantity: radiesseQuantity,
        //   maxQuantity: 200,
        //   onQuantityChanged: (qty) {
        //     setState(() {
        //       radiesseQuantity = qty;
        //     });
        //   },
        // ),
        //
        // // Product 2 - Radiesse Plus
        // MobileRadiesseProductView(
        //   name: radiessePlusProduct.name,
        //   imageUrl: radiessePlusProduct.imageUrl,
        //   price: radiessePlusProduct.skus!.first.tieredPrice.toCurrency(),
        //   skuAttributes: radiessePlusProduct.skus!.first.attributeName,
        //   quantity: radiessePlusQuantity,
        //   maxQuantity: 200,
        //   onQuantityChanged: (qty) {
        //     setState(() {
        //       radiessePlusQuantity = qty;
        //     });
        //   },
        // ),
      ],
    );
  }


  Widget _buildProductTile({
    required String name,
    required String imageUrl,
    required String skuAttributes,
    required String price,
    required int quantity,
    required Function(int) onQuantityChanged,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  skuAttributes,
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF343434),
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      price,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF343434),
                      ),
                    ),
                    _quantitySelector(quantity, onQuantityChanged),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _quantitySelector(int quantity, Function(int) onQuantityChanged) {
    return Container(
      width: 83,
      height: 24,
      decoration: BoxDecoration(
        color: Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              if (quantity > 0) onQuantityChanged(quantity - 1);
            },
            child: Icon(Icons.remove, size: 16, color: Color(0xFF343434)),
          ),
          SizedBox(width: 12),
          Text(
            '$quantity',
            style: TextStyle(
              fontSize: 13.33,
              color: Color(0xFF343434),
            ),
          ),
          SizedBox(width: 12),
          GestureDetector(
            onTap: () {
              onQuantityChanged(quantity + 1);
            },
            child: Icon(Icons.add, size: 16, color: Color(0xFF343434)),
          ),
        ],
      ),
    );
  }


  // Widget _buildBundleOptions() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text(
  //         'Select Your Bundle',
  //         style: TextStyle(
  //           fontSize: 14,
  //           fontWeight: FontWeight.w600,
  //         ),
  //       ),
  //       const SizedBox(height: 16),
  //       _buildBundleOption('Minimum: Buy 10 to 19', 'Get 3 FREE', 0),
  //       _buildBundleOption('Buy 20 to 29', 'Get 7 FREE', 1),
  //       _buildBundleOption('Buy 30 to 39', 'Get 10 FREE', 2),
  //       _buildBundleOption('Buy 40 to 49', 'Get 13 FREE', 3),
  //       _buildBundleOption('Buy 50 to 59', 'Get 20 FREE', 4),
  //       _buildBundleOption('Customize Quantity', '', 5),
  //     ],
  //   );
  // }

  // Widget _buildBundleOption(String title, String subtitle, int index) {
  //   final bool selected = selectedBundleIndex == index;
  //   return GestureDetector(
  //     onTap: () {
  //       setState(() {
  //         selectedBundleIndex = index;
  //       });
  //     },
  //     child: Container(
  //       margin: const EdgeInsets.only(bottom: 16),
  //       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
  //       decoration: BoxDecoration(
  //         color: Colors.white,
  //         border: Border.all(
  //           color: selected ? const Color(0xFF006AFF) : const Color(0xFFBABABA),
  //           width: selected ? 2 : 1,
  //         ),
  //         borderRadius: BorderRadius.circular(5),
  //       ),
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: [
  //           Row(
  //             children: [
  //               Container(
  //                 width: 13,
  //                 height: 13,
  //                 decoration: BoxDecoration(
  //                   shape: BoxShape.circle,
  //                   border: Border.all(
  //                     color: selected ? const Color(0xFF006AFF) : const Color(0xFF787878),
  //                     width: selected ? 4 : 1,
  //                   ),
  //                 ),
  //               ),
  //               const SizedBox(width: 8),
  //               Text(
  //                 title,
  //                 style: TextStyle(
  //                   color: selected ? const Color(0xFF006AFF) : const Color(0xFF343434),
  //                   fontWeight: FontWeight.w500,
  //                 ),
  //               ),
  //             ],
  //           ),
  //           Text(
  //             subtitle,
  //             style: TextStyle(
  //               color: selected ? const Color(0xFF006AFF) : const Color(0xFF343434),
  //               fontWeight: FontWeight.w700,
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }




  Widget _buildBottomBar({
    required bool allowNextStep,
    required int totalQuantity,
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
            backgroundColor: const Color(0xFF006AFF),
            onPressed: allowNextStep ? onNext : null,
            child: const Text(
              'Next Step',
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



  void _handleProductNext() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MobileFreeItemScreen(
            product: widget.product,
            radiesseQuantity:     radiesseQuantity,
            radiessePlusQuantity:    radiessePlusQuantity

        ),
      ),
    );
  }
}



//   String _selectedBundleText() {
//     switch (selectedBundleIndex) {
//       case 0:
//         return 'Minimum: Buy 10 - Get 3 Free';
//       case 1:
//         return 'Buy 20 - Get 7 Free';
//       case 2:
//         return 'Buy 30 - Get 10 Free';
//       case 3:
//         return 'Buy 40 - Get 13 Free';
//       case 4:
//         return 'Buy 50 - Get 20 Free';
//       case 5:
//         return 'Custom Quantity';
//       default:
//         return '';
//     }
//   }
//
//   void _nextStep() async {
//     if ((radiesseQuantity + radiessePlusQuantity) < 10) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Please select at least 10 products to proceed.')),
//       );
//       return;
//     }
//
//     try {
//       final lastMinuteItems = [
//         LastMinuteItem(
//           radiesseProduct.skus!.first.combinedId,
//           radiesseQuantity,
//         ),
//         LastMinuteItem(
//           radiessePlusProduct.skus!.first.combinedId,
//           radiessePlusQuantity,
//         ),
//       ];
//
//       await global.basket.addVirtualItemToCart(
//         virtualProductId: widget.product.id,
//         lastMinuteItems: lastMinuteItems,
//       );
//
//       global.simpleCart.refresh();
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Products added to cart successfully!')),
//       );
//
//       Navigator.pushNamed(context, '/order/cart');
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error: $e')),
//       );
//     }
//   }
//
//
//   int? _getMinQuantityForBundle() {
//     switch (selectedBundleIndex) {
//       case 0:
//         return 10;
//       case 1:
//         return 20;
//       case 2:
//         return 30;
//       case 3:
//         return 40;
//       case 4:
//         return 50;
//       default:
//         return null;
//     }
//   }
// }

class MobileRadiesseProductView extends StatelessWidget {
  final String name;
  final String? skuAttributes;
  final String imageUrl;
  final String price;
  final int quantity;
  final int maxQuantity;
  final void Function(int quantity) onQuantityChanged;

  const MobileRadiesseProductView({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.price,
    this.skuAttributes,
    required this.quantity,
    this.maxQuantity = 200,
    required this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              imageUrl,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                if (skuAttributes != null)
                  Text(
                    skuAttributes!,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(price, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove_circle_outline),
                          onPressed: quantity > 0 ? () => onQuantityChanged(quantity - 1) : null,
                        ),
                        Text('$quantity', style: TextStyle(fontSize: 14)),
                        IconButton(
                          icon: Icon(Icons.add_circle_outline),
                          onPressed: quantity < maxQuantity ? () => onQuantityChanged(quantity + 1) : null,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

