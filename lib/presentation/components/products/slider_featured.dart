import 'package:YLift/models/z-index_export.dart';
import 'package:flutter/material.dart';
import 'package:galaxy_models/core/constants/y_lift_color.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../core/controllers/global.dart';
import 'cards_featured.dart';

class FeaturedProductsSlider extends StatelessWidget {
  final List<ProductSimple> products;
  final VoidCallback onSeeAll;
  ValueSetter<ProductSimple> onProductSelect;

  FeaturedProductsSlider({
    required this.products,
    required this.onSeeAll,
    required this.onProductSelect,
  });

  final GlobalController controller = Get.find<GlobalController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Featured Products',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: onSeeAll,
                child: Text(
                  'See All',
                  style: const TextStyle(fontSize: 14, color: YLiftColor.orange),
                ),
              ),
            ],
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(6, (index) {
              final int firstIndex = index * 2;
              final int secondIndex = firstIndex + 1;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProductCardFeatured(
                    product: products[firstIndex],
                    onProductSelected:
                        () => onProductSelect(products[firstIndex]),
                    hidePrice: controller.isAuthenticated.isFalse,
                  ),
                  ProductCardFeatured(
                    product: products[secondIndex],
                    onProductSelected:
                        () => onProductSelect(products[secondIndex]),
                    hidePrice: controller.isAuthenticated.isFalse,
                  ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}
