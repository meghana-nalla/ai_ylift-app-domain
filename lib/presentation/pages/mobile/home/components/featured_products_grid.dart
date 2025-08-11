import 'package:YLift/core/controllers/global.dart';
import 'package:YLift/models/_clean/product.dart';
import 'package:YLift/presentation/components/products/cards_featured.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/constants/color.dart';

class FeaturedProductsGrid extends StatefulWidget {
  final List<ProductSimple> products;
  final VoidCallback onSeeAll;
  //ValueSetter<ProductSimple> onProductSelected;
  const FeaturedProductsGrid({
    super.key,
    required this.products,
    required this.onSeeAll,
  });

  @override
  State<FeaturedProductsGrid> createState() => _FeaturedProductsGridState();
}

class _FeaturedProductsGridState extends State<FeaturedProductsGrid> {
  final GlobalController controller = Get.find<GlobalController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Featured Products',
                style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold
                ),
              ),
              TextButton(
                onPressed: widget.onSeeAll,
                child: Text('See All'),
              ),
            ],
          ),
        ),
        SizedBox(height: 8),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.3,
          width: 400,
          child: GridView.builder(
            scrollDirection: Axis.horizontal,
              padding: EdgeInsets.only(bottom: 120.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio:0.75
              ),
              //shrinkWrap: true,
              itemCount: widget.products.length,
              itemBuilder: (context, index) {
                var product = widget.products[index];
                // return GestureDetector(
                //     onTap: () {
                //       controller.products.select(widget.products[index]);
                //     },
                //     child:
                //     ProductCardMobile(
                //         productInfo: widget.products[index],
                //         isAuthenticated: controller.isAuthenticated.value));
                return GestureDetector(
                    onTap: () =>
                        controller.products.select(widget.products[index]),
                    child: ProductCardFeatured(
                      product: product,
                      onProductSelected: () =>
                          controller.products.select(widget.products[index]),
                      hidePrice: controller.isAuthenticated.isFalse,
                    )
                );
              }),
        ),
      ],
    );
  }
}


// class FeaturedProductsGridStateless extends StatelessWidget {
//   final List<ProductSimple> products;
//   final VoidCallback onSeeAll;
//   ValueSetter<ProductSimple> onProductSelected;
//   FeaturedProductsGridStateless({
//     super.key,
//     required this.products,
//     required this.onSeeAll,
//     required this.onProductSelected,
//   });
//
//   final GlobalController controller = Get.find<GlobalController>();
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 8.0),
//       child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Expanded(
//               child: Stack(
//                 children: [
//                 Obx(() => GridView.builder(
//                     padding: EdgeInsets.only(bottom: 120.0),
//                     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 2,
//                       crossAxisSpacing: 10,
//                       mainAxisSpacing: 10,
//                     ),
//                     itemCount: products.length,
//                     itemBuilder: (context, index) {
//                       var product = products[index];
//                       return ProductCardMobile(
//                           productInfo: products[index],
//                           isAuthenticated: controller.isAuthenticated.value);
//                       // return GestureDetector(
//                       //   onTap: () => onProductSelected(products[index]),
//                       //   child: ProductCardFeatured(
//                       //     display: product,
//                       //     onProductSelected: () => onProductSelected(products[index]),
//                       //   )
//                       // );
//                     })),
//                 ],
//               ),
//             ),
//           ],
//       ),
//     );
//   }
// }
