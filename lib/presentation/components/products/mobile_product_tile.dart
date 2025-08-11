import 'package:YLift/core/constants/color.dart';
import 'package:YLift/core/extensions/price_extension.dart';
import 'package:YLift/models/_clean/product.dart';
import 'package:YLift/presentation/components/_simple/lock_pricing_chip.dart';
import 'package:YLift/presentation/components/_simple/product_image_view.dart';
import 'package:flutter/material.dart';

class MobileProductTile extends StatelessWidget {
  final ProductSimple product;
  final void Function()? onProductTap;
  final bool hidePrice;

  const MobileProductTile({
    super.key,
    required this.product,
    this.onProductTap,
    this.hidePrice = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onProductTap,
      child: SizedBox(
        width: 128,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProductImageView(imageUrl: product.imageUrl),
            Text(
              product.name.trim(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (product.caption != null)
              Text(
                product.caption!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 11.11, color: Color(0xFF343434)),
              ),

            if (hidePrice || product.skus?.first.tieredPrice == 0) ...[
              const SizedBox(height: 8),
              LockPricingChip(vendorId: product.vendorId),
            ] else if (product.skus?.first.tieredPrice == 0 &&
                product.skus?.first.listPrice == 0) ...[
              const SizedBox(height: 8),
              LockPricingChip(vendorId: product.vendorId),
            ] else if (product.skus?.first.tieredPrice != null &&
                (product.skus?.first.listPrice != null &&
                    product.skus?.first.listPrice != 0) &&
                product.skus?.first.listPrice !=
                    product.skus?.first.tieredPrice) ...[
              const SizedBox(height: 4),
              Wrap(
                spacing: 16,
                children: [
                  Text(
                    product.skus!.first.tieredPrice.toCurrency(),
                    style: TextStyle(
                      color: YLiftColor.orange,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (product.skus?.first.listPrice != null &&
                      product.skus?.first.listPrice != 0)
                    Text(
                      product.skus!.first.listPrice!.toCurrency(),
                      style: TextStyle(
                        decoration: TextDecoration.lineThrough,
                        fontSize: 13,
                        color: Colors.grey,
                      ),
                    ),
                ],
              ),
            ] else if ((product.skus?.first.tieredPrice ?? 0) > 0) ...[
              Text(
                (product.skus?.first.tieredPrice ?? 0).toCurrency(),
                style: TextStyle(fontSize: 13.33),
              ),
            ] else
              LockPricingChip(vendorId: product.vendorId),
            if (product.hasActivePromotion && !hidePrice)
              Text(
                product.promotionMessage!,
                style: TextStyle(fontSize: 11.11, color: YLiftColor.orange),
              ),
          ],
        ),
      ),
    );
  }
}

class NewMobileProductTile extends StatelessWidget {
  final ProductSimple product;
  final void Function()? onProductTap;
  final bool hidePrice;

  final double? width;

  const NewMobileProductTile({
    super.key,
    required this.product,
    this.onProductTap,
    this.hidePrice = true,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onProductTap,
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProductImageView(imageUrl: product.imageUrl),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name.trim(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (product.caption != null)
                          Text(
                            product.caption!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 10,
                              color: Color(0xFF343434),
                            ),
                          ),
                      ],
                    ),

                    if (hidePrice || product.skus?.first.tieredPrice == 0) ...[
                      const SizedBox(height: 8),
                      LockPricingChip(vendorId: product.vendorId),
                    ] else if (product.skus?.first.tieredPrice == 0 &&
                        product.skus?.first.listPrice == 0) ...[
                      const SizedBox(height: 8),
                      LockPricingChip(vendorId: product.vendorId),
                    ] else if (product.skus?.first.tieredPrice != null &&
                        (product.skus?.first.listPrice != null &&
                            product.skus?.first.listPrice != 0) &&
                        product.skus?.first.listPrice !=
                            product.skus?.first.tieredPrice) ...[
                      const SizedBox(height: 4),
                      Wrap(
                        spacing: 16,
                        children: [
                          Text(
                            product.skus!.first.tieredPrice.toCurrency(),
                            style: TextStyle(
                              color: YLiftColor.orange,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (product.skus?.first.listPrice != null &&
                              product.skus?.first.listPrice != 0)
                            Text(
                              product.skus!.first.listPrice!.toCurrency(),
                              style: TextStyle(
                                decoration: TextDecoration.lineThrough,
                                fontSize: 13,
                                color: Colors.grey,
                              ),
                            ),
                        ],
                      ),
                    ] else if ((product.skus?.first.tieredPrice ?? 0) > 0) ...[
                      Text(
                        (product.skus?.first.tieredPrice ?? 0).toCurrency(),
                        style: TextStyle(fontSize: 13.33),
                      ),
                    ] else
                      LockPricingChip(vendorId: product.vendorId),
                    if (product.hasActivePromotion && !hidePrice)
                      Text(
                        product.promotionMessage!,
                        style: TextStyle(
                          fontSize: 11.11,
                          color: YLiftColor.orange,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
