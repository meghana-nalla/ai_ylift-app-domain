import 'package:YLift/models/z-index_export.dart';
import 'package:galaxy_models/galaxy_models.dart';

/// Here we build the information needed for the cartItems themselves
class CartItems {
  // call the sku itself
  StoreSku? sku;
  // next call product
  ProductSimple? product;
  // then we need the vendor
  VendorSimple? vendor;
  int? quantity;
  int? cartItemId;
  CartItems({
    this.sku,
    this.product,
    this.vendor,
    this.quantity,
    this.cartItemId,
  });

  // convert the data to json
  Map<String, dynamic> toJson() => {
    "sku": sku?.toJson(),
    "product": product?.toJson(),
    // "vendor": vendor?.toJson(),
    "quantity": quantity,
  };
}
