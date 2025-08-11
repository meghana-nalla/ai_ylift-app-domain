import 'package:galaxy_models/galaxy_models.dart';
import 'package:galaxy_models/galaxy_models.dart';
class EvolyssePromotion {
  const EvolyssePromotion._();

  static final expirationDate = DateTime(
    2025,
    4,
    25,
    23,
    59,
    59,
  ); // April 25, 2025

  static const evolysseBrandId = 3094;
  static const evolysseFormProductId = 5874;
  static const evolysseSmoothProductId = 5873;

  static const minimumQuantity = 20;
  static const maximumQuantity = 300;

  static const originalPrice = 19500; // $195.00
  static const exclusivePrice = 15000; // $150.00

  static const bannerImageUrl =
      'https://d26n8ibxbj8243.cloudfront.net/optimized/custom_images/april_18_evolus.png';

  static bool isEvolysseProduct(CartItemSimple cartItem) {
    return cartItem.productId == evolysseFormProductId ||
        cartItem.productId == evolysseSmoothProductId;
  }

  static bool isQualified(List<CartItemSimple> cartItems) {
    final evolysseCartItems = cartItems.where(isEvolysseProduct).toList();
    final totalQuantity = evolysseCartItems.fold(
      0,
      (previousValue, cartItem) => previousValue + cartItem.quantity,
    );
    return totalQuantity >= minimumQuantity && totalQuantity <= maximumQuantity;
  }
}
