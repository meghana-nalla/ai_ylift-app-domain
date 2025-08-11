import 'package:flutter/material.dart';
import 'package:YLift/models/z-index_export.dart';

import 'large_item.dart';

class ProductLargeGrid extends StatelessWidget {
  final List<ProductSimple> products;
  final int crossAxisCount;
  final int itemCount;
  final bool defaultGrid;

  ProductLargeGrid({
    required this.products,
    this.crossAxisCount = 2,
    this.itemCount = 4,
    this.defaultGrid = false,
  });

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return Center(child: Text('No products available'));
    }

    if (defaultGrid) {
      return LayoutBuilder(
        builder: (context, constraints) {
          double itemWidth = constraints.maxWidth / crossAxisCount;
          double itemHeight = itemWidth * 1.4; // Adjust this ratio as needed

          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              childAspectRatio: itemWidth / itemHeight,
            ),
            itemCount: itemCount.clamp(0, products.length),
            itemBuilder: (context, index) {
              final product = products[index];
              return ProductItemVar(product:products[index]);
            },
          );
        },
      );
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        final double itemWidth = (constraints.maxWidth - (crossAxisCount + 1) * 10) / crossAxisCount;
        final double itemHeight = itemWidth / 2; // Assuming childAspectRatio of 2
        final int rowCount = (itemCount / crossAxisCount).ceil();
        final double gridHeight = rowCount * itemHeight + (rowCount + 1) * 10;

        return Container(
          // color: Colors.tealAccent,
          height: gridHeight,
          child: GridView.builder(
            padding: EdgeInsets.all(10),
            physics: NeverScrollableScrollPhysics(), // Disable scrolling
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 2, // smaller the number the larger the image
            ),
            itemCount: itemCount,
            itemBuilder: (ctx, i) => ProductLargeItem(products[i]),
          ),
        );
      },
    );

  }
}


class ProductItemVar extends StatelessWidget {
  final ProductSimple product;

  const ProductItemVar({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Image.network(
              product.imageUrl ?? 'placeholder_image_url',
              fit: BoxFit.cover,
              width: double.infinity,
              errorBuilder: (context, error, stackTrace) {
                return Center(child: Icon(Icons.error));
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: Theme.of(context).textTheme.labelSmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Text(
                  '\$${product.price?.toStringAsFixed(2) ?? 'N/A'}',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}