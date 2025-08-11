import 'package:YLift/core/constants/color.dart';
import 'package:YLift/core/constants/constant.dart';
import 'package:YLift/models/z-index_export.dart';
import 'package:YLift/presentation/components/navigation/search_bar/product_suggestion_tile.dart';
import 'package:YLift/presentation/components/z-index_export.dart';
import 'package:flutter/material.dart';
import 'package:galaxy_ui/galaxy_ui.dart';

class PopularProductsPanel extends StatefulWidget {
  final List<ProductSimple> products;
  final void Function(ProductSimple product) onProductSelected;
  final void Function() onSeeAllProducts;

  const PopularProductsPanel({
    super.key,
    required this.products,
    required this.onProductSelected,
    required this.onSeeAllProducts,
  });

  @override
  State<PopularProductsPanel> createState() => _PopularProductsPanelState();
}

class _PopularProductsPanelState extends State<PopularProductsPanel> {

  bool _showPromos = false;

  @override
  void initState() {
    super.initState();
    _showPromos = false;
  }

  void _togglePromo() {
    setState(() {
      _showPromos = !_showPromos;
    });
  }

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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 30,
              child: Row(
                children: [
                  const Text(
                    'Popular Products',
                    style: TextStyle(
                      fontSize: 13.33,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  // TODO remove this, for display purposes only
                  // const Spacer(),
                  // Expanded(
                  //   child: TextButton(
                  //     onPressed: _togglePromo,
                  //     child: const Text(
                  //       'Show Promos',
                  //       style: TextStyle(
                  //         fontSize: 10,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),

            const SizedBox(height: 8),
            const Divider(),
            ListView.separated(
              shrinkWrap: true,
              itemCount: widget.products.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final product = widget.products[index];
                return ProductSuggestionTile(
                  name: product.name,
                  subtitle: product.caption,
                  price: product.skus?.first.tieredPrice.toInt() ?? 0,
                  listPrice: product.skus?.first.listPrice,
                  imageUrl: product.imageUrl,
                  hasPromotion: _showPromos,
                  onTap: () => widget.onProductSelected(product),
                  isGalderma: product.vendorId == YLiftConstant.galdermaVendorId || product.name.contains('RYng'),
                  vendorId: product.vendorId,
                );
              },
            ),
            const SizedBox(height: 8),
            const Divider(),
            SizedBox(
              width: double.infinity,
              child: RoundedFilledButton(
                onPressed: widget.onSeeAllProducts,
                child: const Text('SEE ALL PRODUCTS'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
