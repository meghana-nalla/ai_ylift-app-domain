import 'package:YLift/models/simple/order_item.dart';
import 'package:YLift/presentation/components/_simple/product_image_view.dart';
import 'package:flutter/material.dart';
import 'package:galaxy_models/galaxy_models.dart';

class OrderItemCard extends StatelessWidget {
  final GalaxyOrderItem cartItem;

  const OrderItemCard({
    super.key,
    required this.cartItem,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProductImageView(imageUrl: cartItem.imageUrl),
          Text(
            cartItem.productName,
            style: const TextStyle(
              fontSize: 11.11,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            'Quantity: ${cartItem.quantity}',
            style: const TextStyle(
              color: Color(0xFFBBBBBB),
              fontSize: 11.11,
            ),
          ),
        ],
      ),
    );
  }
}