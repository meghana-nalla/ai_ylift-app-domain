import 'dart:developer';

import 'package:YLift/core/constants/constant.dart';
import 'package:YLift/models/simple/CartSimple.dart';

class CartValidator {
  const CartValidator._();

  static const _defaultErrorMessage =
      'Something went wrong, please try again.\nIf the problem persists, contact ${YLiftConstant.yliftPhoneNumber} or ${YLiftConstant.yliftEmail}.';

  static Exception? validateCart(CartSimple cart) {
    return null;
  }

  static CartItemError? validateCartItem(Map<String, dynamic> json) {
    final productId = json['productId'] as int;
    final skuId = json['skuId'] as int;
    final combinedId = '$productId-$skuId';

    if (json['shippingSettings'] == null) {
      log('Missing shipping settings for product $combinedId', name: 'CartItemSimple');
      return CartItemError(_defaultErrorMessage, combinedId);
    }
    return null;
  }
}

class CartError implements Exception {
  final int code;
  final String message;
  final List<String> productId;

  const CartError(this.code, this.message, {this.productId = const <String>[]});

  @override
  String toString() => 'CartError(code: $code, message: $message)';
}

class CartItemError implements Exception {
  final String message;
  final String productId;

  const CartItemError(this.message, this.productId);

  @override
  String toString() =>
      'CartItemError(message: $message, productId: $productId)';
}
