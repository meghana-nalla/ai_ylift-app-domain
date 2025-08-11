import 'package:flutter/material.dart';

const _productPlaceholder = 'https://ylift.app/static/assets/optimized/custom_images/placeholder_product.png';

class ProductImageView extends StatelessWidget {
  final String? imageUrl;

  final BoxFit? fit;

  /// A widget that displays a product image.
  /// If image url is null, it will automatically use the product placeholder.
  const ProductImageView({
    super.key,
    required this.imageUrl,
    this.fit,
  });

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl ?? _productPlaceholder,
      fit: fit,
      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                : null,
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return Image.asset('msc/images/Placeholder_Product.png');
      },
    );
  }
}
