import 'package:YLift/core/constants/color.dart';
import 'package:YLift/core/constants/constant.dart';
import 'package:YLift/models/z-index_export.dart';
import 'package:YLift/presentation/components/navigation/search_bar/product_suggestion_tile.dart';
import 'package:YLift/presentation/components/z-index_export.dart';
import 'package:flutter/material.dart';
import 'package:galaxy_ui/galaxy_ui.dart';
import 'package:YLift/core/extensions/price_extension.dart';

class PopularProductsPanelMobile extends StatefulWidget {
  final List<ProductSimple> products;
  final void Function(ProductSimple product) onProductSelected;
  final void Function() onSeeAllProducts;

  const PopularProductsPanelMobile({
    super.key,
    required this.products,
    required this.onProductSelected,
    required this.onSeeAllProducts,
  });

  @override
  State<PopularProductsPanelMobile> createState() => _PopularProductsPanelState();
}

class _PopularProductsPanelState extends State<PopularProductsPanelMobile> {

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
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 480, // Enforce limit on both mobile and desktop
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: YLiftColor.grey3),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 30,
                child: Row(
                  children: [
                    Text(
                      'Popular Products',
                      style: TextStyle(
                        fontSize: 13.33,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              const Divider(),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.products.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final product = widget.products[index];

                    return IntrinsicHeight( // Ensures proper layout height-wise
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 60,
                            height: 60,
                            child: Image.network(product.imageUrl, fit: BoxFit.contain),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.name,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                if ((product.caption ?? '').isNotEmpty)
                                  Text(
                                    product.caption!,
                                    style: Theme.of(context).textTheme.bodySmall,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Text(
                                      (product.skus?.first.tieredPrice ?? 0).toCurrency(),
                                      style: const TextStyle(
                                        color: Colors.deepOrange,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    const SizedBox(width: 6),
                                    if (product.skus?.first.listPrice != null)
                                      if (product.skus?.first.listPrice != null && product.skus!.first.listPrice! > 0)
                                        Text(
                                          product.skus!.first.listPrice!.toCurrency(),
                                          style: const TextStyle(
                                            decoration: TextDecoration.lineThrough,
                                            color: Colors.grey,
                                          ),
                                        ),

                                    const Spacer(),
                                    if (product.skus!.first.listPrice != null &&
                                        product.skus!.first.listPrice! > product.skus!.first.tieredPrice!)
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.orange),
                                        ),
                                        child: Text(
                                          'Save ${(100 * (product.skus!.first.listPrice! - product.skus!.first.tieredPrice!) ~/ product.skus!.first.listPrice!)}%',
                                          style: const TextStyle(fontSize: 10, color: Colors.orange),
                                        ),
                                      ),

                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 8),
              const Divider(),
              SizedBox(
                width: double.infinity,
                child: RoundedFilledButton(
                  onPressed: widget.onSeeAllProducts,
                  child: const Text('SEE ALL PRODUCTS'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
