
// import 'package:YLift/models/api/cart.dart';
import 'package:galaxy_models/galaxy_models.dart';
import 'package:YLift/models/simple/CartSimple.dart';
import 'package:YLift/models/simple/z-index_export.dart';
// import '../../api/address.dart';
// import 'cart_item.dart';
import 'package:galaxy_models/galaxy_models.dart';

class CustomerCart {
  int? id;
  int? numberOfVendorItems;
  int? quantity;
  double? price;
  String? name;
  String? image;
  CartInfo? info;
  // Cart? details;
  List<ShoppingItemsByBrands> shoppingItems;
  Checkout? checkout;
  List<ProductShippingSettings>? productShippingSettings;
  List<VendorShippingSettings>? vendorShippingSettings;
  List<CardInformation>? cards;
  CartSimple? cartSimple;

  CustomerCart({
    this.id,
    this.numberOfVendorItems,
    this.quantity,
    this.price,
    this.name,
    this.image,
    this.checkout,
    // this.details,
    this.info,
    this.shoppingItems = const [],
    this.productShippingSettings = const [],
    this.vendorShippingSettings = const [],
    this.cards,
    this.cartSimple,
  });

  Map<String, dynamic> toJson() => {
    "id": id,
    "number_of_vendor_items": numberOfVendorItems,
    "quantity": quantity,
    "price": price,
    "name": name,
    "image": image,
    "info": info?.toJson(),
    // "details": details?.toJson(),
    "shoppingItems": shoppingItems.map((e) => e.toJson()).toList(),
  };

  void updateShippingInfo(List<ShippingSettings> newShippingInfo) {
    checkout?.shippingInfo = newShippingInfo;
    recalculateShipping();
  }

  void recalculateShipping() {
    if (checkout?.shippingInfo == null) return;

    checkout?.shipping = 0;
    for (var shippingSettings in checkout!.shippingInfo) {
      checkout?.shipping = (checkout?.shipping ?? 0) + (shippingSettings.selectedRate * shippingSettings.boxes!);
    }
  }

  @override
  String toString() {
    return '''
CustomerCart(
  id: $id,
  numberOfVendorItems: $numberOfVendorItems,
  quantity: $quantity,
  price: ${price != null ? price!.toStringAsFixed(2) : 'null'},
  name: $name,
  image: $image,
  info: ${info != null ? info.toString() : 'null'},

  shoppingItems: ${shoppingItems.map((item) => item.toString()).toList()},
  checkout: ${checkout != null ? checkout.toString() : 'null'},
  productShippingSettings: ${productShippingSettings?.map((s) => s.toString()).toList()},
  vendorShippingSettings: ${vendorShippingSettings?.map((s) => s.toString()).toList()},
  cards: ${cards?.map((c) => c.toString()).toList()},
)
    ''';
  }

}

class Checkout {
  int? shipping;
  int? tax;
  int? subtotal;
  int? discount;
  int? promoCodeDiscount;
  int? promotionalDiscount;
  int? pricingRuleDiscount;
  AddressSimple? address; // selected address
  CardInformation? card; // selected card
  List<ShippingSettings> shippingInfo;
  Map<String, dynamic>? ready;
  Checkout({
    this.shipping,
    this.tax,
    this.subtotal,
    this.discount,
    this.promoCodeDiscount,
    this.pricingRuleDiscount,
    this.promotionalDiscount,
    // this.address,
    this.card,
    this.shippingInfo = const [],
    this.ready,
  });

  int get total => (subtotal ?? 0) + (tax ?? 0) + (shipping ?? 0) - (discount ?? 0) - (promoCodeDiscount ?? 0) - (pricingRuleDiscount ?? 0) - (promotionalDiscount ?? 0);

  factory Checkout.fromJson(Map<String, dynamic> json) => Checkout(
    shipping: json["shipping"] as int?,
    tax: json["tax"] as int?,
    subtotal: json["subtotal"] as int?,
    discount: json["discount"] as int?,
    promoCodeDiscount: json["promoCodeDiscount"] as int?,
    pricingRuleDiscount: json["pricingRuleDiscount"] as int?,
    promotionalDiscount: json["promotionDiscount"] as int?,
  );

  // to string displays cart info

}