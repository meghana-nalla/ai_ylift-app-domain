import 'package:YLift/core/constants/constant.dart';
import 'package:galaxy_models/galaxy_models.dart';
import 'package:YLift/models/api/z-index_export.dart';

class ProductSimple {
  static const String _defaultProductImage =
      'https://ylift.app/api/v3/phantom/media/api/optimized/variant/image/file/2c0a8920-f7da-45f7-97dc-12569896eb80';

  final String id;
  final int? productId;
  final int? vendorId;
  final String? vendorName;
  final int? brandId;
  final String? brandName;
  final String name;
  final String? caption;
  final String? description;
  final String imageUrl;
  final int? defaultSkuId;
  final List<SkuSimple>? skus;
  final bool isOutOfStock;
  final double? price;
  final bool? isActive;
  final int? displayRetailPrice;
  final int? displayPrice;
  final List<ProductBrand>? productBrands;
  final List<int>? categoryId;
  final List<String>? categoryName;
  final bool featured;
  final int featuredOrder;
  final bool isBestSeller;
  final int? bestSellerRank;
  final bool hasActivePromotion;
  final String? promotionMessage;
  final String? promotionMessageForCart;
  final List<String>? tags;
  final DateTime? createdAt;

  int? get firstPrice => skus?.firstOrNull?.tieredPrice;

  List<int> get skuIds => skus?.map((sku) => int.parse(sku.skuId)).toList(growable: false) ?? <int>[];

  bool get hasPrice => skus?.any((element) => element.tieredPrice != 0) ?? false;

  bool get isGaldermaProduct => vendorId == YLiftConstant.galdermaVendorId;

  const ProductSimple({
    this.id = '',
    required this.name,
    String? imageUrl,
    this.price,
    this.isActive,
    this.productId,
    this.description,
    this.brandName,
    this.displayRetailPrice,
    this.displayPrice,
    this.caption,
    this.isOutOfStock = true,
    this.skus,
    this.productBrands,
    this.vendorId,
    this.vendorName,
    this.brandId,
    this.defaultSkuId,
    this.categoryId,
    this.categoryName,
    this.featured = false,
    this.featuredOrder = 0,
    this.isBestSeller = false,
    this.bestSellerRank,
    this.hasActivePromotion = false,
    this.promotionMessage,
    this.promotionMessageForCart,
    this.tags,
    this.createdAt,
  }) : imageUrl = imageUrl ?? _defaultProductImage;

  static List<SkuSimple>? _parseSkus(dynamic skusJson) {
    if (skusJson == null) return null;
    if (skusJson is! List) return null;

    return skusJson
        .map((item) => SkuSimple.fromJson((item as Map<String, dynamic>?) ?? {}))
        .where((sku) => sku.isActive == true)
        .toList();
  }

  factory ProductSimple.fromJson(Map<String, dynamic> json) {
    if (json.isEmpty) {
      throw ArgumentError('ProductSimple.fromJson called with empty json map');
    }

    String imageUrl = json['imageUrl'] ?? "https://ylift.app/static/assets/optimized/custom_images/placeholder_product.png"; // product images will never be null
    if (imageUrl != '' && imageUrl.contains('d26n8ibxbj8243.cloudfront.net/optimized/')) {
      // imageUrl = imageUrl.replaceFirst('d26n8ibxbj8243.cloudfront.net/', 'ylift.app/static/assets/');
    }

    // Direct type conversion for numeric fields
    int? parseIntSafely(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      if (value is String) {
        return int.tryParse(value);
      }
      return null;
    }

    // Direct type conversion for double fields
    double? parseDoubleSafely(dynamic value) {
      if (value == null) return null;
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) {
        return double.tryParse(value);
      }
      return null;
    }

    return ProductSimple(
      id: json['id']?.toString() ?? '',
      productId: parseIntSafely(json['productId']),
      vendorId: parseIntSafely(json['vendorId']),
      vendorName: json['vendorName']?.toString(),
      brandId: parseIntSafely(json['brandId']),
      brandName: json['brandName']?.toString(),
      bestSellerRank: json['bestSellerRank'],
      caption: json['caption']?.toString(),
      categoryId: json['categoryId'] != null ? List<int>.from(json['categoryId']) : null,
      categoryName: json['categoryName'] != null ? List<String>.from(json['categoryName']) : null,
      createdAt: DateTimeUtils.fromJson(json['createdAt']),
      description: json['description']?.toString(),
      displayPrice: parseIntSafely(json['displayPrice']),
      displayRetailPrice: parseIntSafely(json['displayRetailPrice']),
      featured: json['featured'] ?? false,
      featuredOrder: parseIntSafely(json['featuredOrder']) ?? 0,
      name: json['name']?.toString() ?? '',
      imageUrl: imageUrl,
      defaultSkuId: parseIntSafely(json['defaultSkuId']),
      skus: _parseSkus(json['skus']),
      isActive: json['isActive'] as bool?,
      isBestSeller: json['isBestSeller'] ?? false,
      isOutOfStock: json['outOfStock'] ?? json['isOutOfStock'] ?? true,
      price: parseDoubleSafely(json['price']),
      productBrands: json['productBrands'] != null
          ? (json['productBrands'] as List).map((e) => ProductBrand.fromJson(e)).toList()
          : null,
      hasActivePromotion: json['hasActivePromotion'] ?? false,
      promotionMessage: json['promotionMessage'],
      promotionMessageForCart: json['promotionMessageForCart'],

      tags: json['tags'] != null ? List<String>.from(json['tags']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'productId': productId,
    'vendorId': vendorId,
    'vendorName': vendorName,
    'brandId': brandId,
    'brandName': brandName,
    'name': name,
    'caption': caption,
    'description': description,
    'imageUrl': imageUrl,
    'defaultSkuId': defaultSkuId,
    'skus': skus?.map((sku) => sku.toJson()).toList(),
    'isOutOfStock': isOutOfStock,
    'price': price,
    'isActive': isActive,
    'displayRetailPrice': displayRetailPrice,
    'displayPrice': displayPrice,
    'productBrands': productBrands?.map((brand) => brand.toJson()).toList(),
    'categoryId': categoryId,
    'categoryName': categoryName,
    'featured': featured,
    'tags': tags
  };
}
