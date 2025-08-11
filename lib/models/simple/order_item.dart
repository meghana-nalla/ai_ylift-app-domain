import 'package:YLift/core/constants/index.dart';
import 'package:YLift/core/controllers/carts/cart_validator.dart';
import 'package:YLift/core/extensions/num_extension.dart';
import 'package:YLift/core/utils/date_time_util.dart';
import 'package:galaxy_models/galaxy_models.dart';
import 'package:YLift/models/z-index_export.dart';

enum ShippingType {
  none('None'),
  regular('Regular'),
  express('Express'),
  overnight('Overnight');

  final String label;
  const ShippingType(this.label);

  String toJson() => name.toUpperCase();
  factory ShippingType.fromJson(dynamic name) {
    if (name is! String) return ShippingType.none;
    name = name.toLowerCase();
    return ShippingType.values.byName(name.toLowerCase());
  }
}

class OrderItem {
  String? id;
  int? productId;
  int skuId;
  final int vendorId;
  final String vendorName;
  final int brandId;
  final String brandName;
  final String productName;
  final String? imageUrl;
  String? caption;
  int quantity;
  int total;
  int taxPrice;
  int taxRate;
  int itemTaxTotalAsInteger;
  int shippingPrice;
  // int? discountedPrice;
  int unitPrice;
  DateTime createdAt;
  DateTime updatedAt;
  SkuSimple sku;
  bool customShippingAddress;
  bool moveToCheckOut;
  dynamic pricingRule;
  ShippingSettingsSimple? shippingSettings;
  ShippingType shippingType;
  List<ShippingQuantity>? shippingQuantities;
  bool satisfiesPricingRule;
  double needsMoreForPricingRule;
  String? shippingAddress;
  String? cartNote;

  bool get isFreeShipping => shippingSettings == null;

  bool get hasSplit => shippingQuantities != null;

  CartItemPromotion? promotion;

  int? promotionalQuantity;

  String get combinedId => '$productId-$skuId';

  OrderItem({
    this.id,
    required this.skuId,
    required this.vendorId,
    required this.vendorName,
    required this.brandId,
    required this.brandName,
    required this.productName,
    this.imageUrl,
    this.caption,
    required this.quantity,
    required this.total,
    required this.taxPrice,
    required this.itemTaxTotalAsInteger,
    required this.taxRate,
    required this.shippingPrice,
    required this.createdAt,
    required this.updatedAt,
    required this.sku,
    required this.customShippingAddress,
    this.moveToCheckOut = true,
    this.pricingRule,
    this.shippingType = ShippingType.none,
    this.shippingSettings,
    this.shippingQuantities,
    required this.satisfiesPricingRule,
    required this.needsMoreForPricingRule,
    this.shippingAddress,
    this.productId,
    // this.discountedPrice,
    required this.unitPrice,
    this.promotion,
    this.cartNote,
    this.promotionalQuantity,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    final shippingSettings =
        json['shippingSettings'] != null
            ? ShippingSettingsSimple.fromJson(json['shippingSettings'])
            : null;


    return OrderItem(
      id: '${json['id']}',
      skuId: json['skuId'] ?? 0,
      vendorId: json['vendorId'] ?? -1,
      vendorName: json['vendorName'] ?? '(no vendor name)',
      brandId: json['brandId'] ?? -1,
      brandName: json['brandName'] ?? '(no brand name)',
      productName: json['productName'] ?? '(no product name)',
      imageUrl: json['imageUrl'],
      quantity: IntConverter.fromJson(json['quantity']),
      total: IntConverter.fromJson(json['total']),
      taxPrice: IntConverter.fromJson(json['totalTaxPrice']),
      itemTaxTotalAsInteger: IntConverter.fromJson(
        json['itemTaxTotalAsInteger'],
      ),
      taxRate: IntConverter.fromJson(json['totalTaxRate']),
      shippingPrice: IntConverter.fromJson(json['totalShippingPrice']),
      createdAt: DateTimeUtils.fromJson(json['createdAt']),
      updatedAt: DateTimeUtils.fromJson(json['updatedAt']),
      sku: SkuSimple.fromJson(json['sku']),
      customShippingAddress: json['customShippingAddress'],
      caption: json['caption'],
      shippingType: ShippingType.fromJson(json['shippingType']),
      shippingQuantities: ShippingQuantity.fromList(
        '${json['skuId']}',
        json['shippingQuantities'],
      ),
      pricingRule: json['pricingRule'],
      shippingSettings: shippingSettings,
      satisfiesPricingRule: json['satisfiesPricingRule'],
      needsMoreForPricingRule:
          (json['needsMoreForPricingRule'] as num).toDouble(),
      shippingAddress: '${json['shippingAddress']}',
      productId: IntConverter.fromJson(json['productId']),
      moveToCheckOut: json['moveToCheckOut'] ?? true,
      unitPrice: IntConverter.fromJson(json['unitPrice']),
      cartNote: json['cartNote'],
      promotion: CartItemPromotion.fromJson(json['promotionalCartItem']),
      promotionalQuantity: IntConverter.fromJsonNullable(
        json['promotionalQuantity'],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'skuId': skuId,
      'quantity': quantity,
      'total': total,
      'taxPrice': taxPrice,
      'taxRate': taxRate,
      'shippingPrice': shippingPrice,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'sku': sku.toJson(),
      'customShippingAddress': customShippingAddress,
      // 'shippingAddress': shippingAddress?.toJson(),
      'pricingRule': pricingRule,
      'shippingSettings': shippingSettings?.toJson(),
      'satisfiesPricingRule': satisfiesPricingRule,
      'needsMoreForPricingRule': needsMoreForPricingRule,
      'shippingAddress': shippingAddress,
      'productId': productId,
      'moveToCheckOut': moveToCheckOut,
      // 'discountedPrice': discountedPrice,
      'cartNote': cartNote,
    };
  }
}

class CartItemPromotion {
  final bool hasActivePromotion;
  final String promotionCartMessage;
  final String promotionItemMessage;
  final bool isPromotionApplied;
  final List<String> promotionIds;

  const CartItemPromotion({
    required this.hasActivePromotion,
    required this.promotionCartMessage,
    required this.promotionItemMessage,
    required this.isPromotionApplied,
    required this.promotionIds,
  });

  factory CartItemPromotion.fromJson(Map<String, dynamic> json) {
    final hasActivePromotion = json['hasActivePromotion'] ?? false;
    final promotionCartMessage = json['promotionCartMessage'] ?? '';
    return CartItemPromotion(
      hasActivePromotion: hasActivePromotion && promotionCartMessage.isNotEmpty,
      promotionCartMessage: json['promotionCartMessage'] ?? '',
      promotionItemMessage: json['promotionItemMessage'] ?? '',
      isPromotionApplied: json['isPromotionApplied'] ?? false,
      promotionIds: List<String>.from(json['promotionIds']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hasActivePromotion': hasActivePromotion,
      'promotionCartMessage': promotionCartMessage,
      'promotionItemMessage': promotionItemMessage,
      'isPromotionApplied': isPromotionApplied,
      'promotionIds': promotionIds,
    };
  }
}
