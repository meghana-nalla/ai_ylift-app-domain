import 'package:YLift/core/constants/color.dart';
import 'package:YLift/models/z-index_export.dart';
import 'package:YLift/presentation/components/navigation/search_bar/product_suggestion_tile.dart';
import 'package:flutter/material.dart';
import 'package:galaxy_ui/galaxy_ui.dart';

import '../../../../core/constants/constant.dart';

class ProductsSuggestionPanel extends StatelessWidget {
  final List<ProductSimple> products;
  final void Function(ProductSimple product) onProductSelected;
  final void Function() onSeeAllProducts;

  const ProductsSuggestionPanel({
    super.key,
    required this.products,
    required this.onProductSelected,
    required this.onSeeAllProducts,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      shadowColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: YLiftColor.grey3),
        ),
        width: 480,
        height: 560,

        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: products.length,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemBuilder: (context, index) {
                  final product = products[index];
                  return ProductSuggestionTile(
                    name: product.name,
                    subtitle: product.caption,
                    price: product.skus?.first.tieredPrice.toInt() ?? 0,
                    listPrice: product.skus?.first.listPrice,
                    imageUrl: product.imageUrl,
                    onTap: () => onProductSelected(product),
                    isGalderma: product.vendorId == YLiftConstant.galdermaVendorId || product.name.contains('RYng'),
                    vendorId: product.vendorId,
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: RoundedFilledButton(
                  onPressed: onSeeAllProducts,
                  child: Text('SEE ALL ${products.length} RESULTS'),
                ),
              ),
            ),
          ],
        ),
        //   child: Column(
        //     children: products.map(
        //       (product) {
        //         return ProductSuggestionTile(
        //           name: product.name,
        //           subtitle: product.caption,
        //           price: product.skus?.first.tieredPrice.toInt() ?? 0,
        //           imageUrl: product.imageUrl!,
        //           onTap: () => onProductSelected(product),
        //         );
        //       },
        //     ).toList(),
        //   ),
      ),
    );
  }
}
