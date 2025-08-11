import 'package:YLift/core/constants/constant.dart';
import 'package:YLift/core/constants/sample_index.dart';
import 'package:YLift/core/controllers/global.dart';
import 'package:YLift/models/z-index_export.dart';

import 'package:galaxy_ui/galaxy_ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:YLift/presentation/components/z-index_export.dart';

class MoreLikeThisDialog extends StatelessWidget {
  final String productName;
  final void Function(ProductSimple product)? onSimilarProductSelected;
  final List<ProductSimple> similarProducts;

  const MoreLikeThisDialog({
    super.key,
    required this.productName,
    this.similarProducts = const <ProductSimple>[],
    this.onSimilarProductSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: SizedBox(
          width: 640,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.green),
                  const SizedBox(width: 16),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(fontSize: 18),
                        children: [
                          TextSpan(text: productName, style: const TextStyle(fontWeight: FontWeight.bold)),
                          const TextSpan(text: ' has been added to cart'),
                        ],
                      ),
                    ),
                  ),
                  YLiftFilledButton(
                    backgroundColor: Colors.green,
                    onPressed: () async {
                      Navigator.pop(context);
                      final controller = Get.find<GlobalController>();
                      await controller.vroute.navigateTo('/order/cart');
                    },
                    child: const Text('View Cart'),
                  ),
                ],
              ),
              const GapY(),
              SizedBox(
                height: 640,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('More like this', style: TextStyle(fontSize: 18)),
                    if (similarProducts.isNotEmpty)
                      Expanded(
                        child: GridView.count(
                          mainAxisSpacing: YLiftConstant.gap,
                          crossAxisSpacing: YLiftConstant.gap,
                          crossAxisCount: 2,
                          children: List.generate(
                            similarProducts.length,
                            (index) {
                              final similarProduct = similarProducts[index];
                              print(similarProduct.productId);
                              return InkWell(
                                onTap: () {
                                  onSimilarProductSelected?.call(similarProduct);
                                  Navigator.pop(context);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: Image.network(
                                          similarProduct.imageUrl ?? PLACEHOLDER_IMAGE,
                                          errorBuilder: (context, error, stackTrace) => Image.asset('msc/images/Placeholder_Product.png'),
                                        ),
                                      ),
                                      Text(similarProduct.name),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
