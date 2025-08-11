import 'package:YLift/core/constants/color.dart';
import 'package:YLift/core/constants/constant.dart';
import 'package:flutter/material.dart';

class CartPageV2 extends StatelessWidget {
  const CartPageV2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: YLiftConstant.totalTopNavigation),
        child: SizedBox(
          width: double.infinity,
          child: Center(
            child: Container(
              width: YLiftConstant.pageWidth,
              margin: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 32),
                  Row(children: [Text('SHOP Y'), Text(' / '), Text('My Cart')]),
                  const SizedBox(height: 32),
                  Text(
                    'MY CART',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Divider(height: 32),
                  Text(
                    'Shipping Address',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: YLiftColor.divider),
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.location_on_outlined, size: 32),
                        const SizedBox(width: 16),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('67-22 Austin St'),
                            Text(
                              'Jason P | (646) 123-4567',
                              style: TextStyle(fontSize: 13.33),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Icon(Icons.edit_outlined),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Cart & Shipping Options',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  ExpansionTile(
                    initiallyExpanded: true,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      side: BorderSide(color: YLiftColor.divider),
                    ),
                    collapsedShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      side: BorderSide(color: YLiftColor.divider),
                    ),
                    title: Text('Galderma (4 products)'),
                    children: [CartItemTileV2()],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CartItemTileV2 extends StatelessWidget {
  // final CartItemSimple cartItem;
  final void Function()? onUpdateQuantity;
  final void Function()? onDelete;
  final void Function()? onSaveLater;

  const CartItemTileV2({
    super.key,
    // required this.cartItem,
    this.onUpdateQuantity,
    this.onDelete,
    this.onSaveLater,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: Row(
        children: [
          SizedBox.square(dimension: 64),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Product name',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              Row(
                children: [
                  // Delete button
                  TextButton.icon(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    ),
                    onPressed: () {},
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('Delete'),
                  ),
                  const SizedBox(width: 16),

                  // Save for later
                  TextButton.icon(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    ),
                    onPressed: () {},
                    icon: const Icon(Icons.favorite_outline),
                    label: const Text('Save for Later'),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
