import 'dart:convert';
import 'package:YLift/app_controller.dart';
import 'package:YLift/models/api/product_brand_media.dart';
import 'package:YLift/models/z-index_export.dart';
import 'package:YLift/core/constants/index.dart';

class ProductBrand {
  int? id;

  int? brandId;
  int clicks;
  String name;
  String? description;
  String? homepageDescription;
  String? logoUrl;
  bool isActive;
  bool featured;
  bool isNavigable;
  int position;
  String? safeBrandName;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<ProductSimple>? products;
  List<ProductBrandMedia>? productBrandMedia;

  // new fields
  List<int> vendorIds;
  int? skuCount;

  ProductBrand({
    this.id,
    this.brandId,
    required this.clicks,
    required this.name,
    this.description,
    this.homepageDescription,
    this.logoUrl,
    required this.isActive,
    required this.featured,
    required this.isNavigable,
    required this.position,
    this.createdAt,
    this.updatedAt,
    this.safeBrandName,
    this.products,
    this.productBrandMedia,

    // new fields
    this.vendorIds = const <int>[],
    this.skuCount,
  });

  // Dummy constructor with default values
  ProductBrand.dummy()
      : id = 2112,
        clicks = 0,
        name = 'Dummy Brand',
        description = 'This is a dummy description.',
        homepageDescription = 'This is a dummy homepage description.',
        logoUrl = PLACEHOLDER_IMAGE,
        isActive = true,
        featured = false,
        isNavigable = true,
        position = 0,
        createdAt = DateTime.now(),
        updatedAt = DateTime.now(),
        products = [],
        productBrandMedia = [],

        // new fields
        vendorIds = <int>[],
        skuCount = 0;

  factory ProductBrand.fromJson(Map<String, dynamic> json) {
    return ProductBrand(
      brandId: json['brandId'] ?? 0,
      clicks: json['clicks'] ?? 0,
      name: (json['name'] as String).trim(),
      description: json['description'] ?? '',
      homepageDescription: json['homepageDescription'] ?? '',
      logoUrl: json['logoUrl'] ?? '',
      isActive: json['isActive'] ?? false,
      featured: json['featured'] ?? false,
      isNavigable: json['isNavigable'] ?? false,
      position: json['position'] ?? 0,
      safeBrandName: json['safeBrandName'] ?? '',
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      // products: json['products'] != null
      //     ? (json['products'] as List).map((i) => Product.fromJson(i)).toList()
      //     : null,
      productBrandMedia: json['productBrandMedia'] != null
          ? (json['productBrandMedia'] as List).map((i) => ProductBrandMedia.fromJson(i)).toList()
          : null,

      // new fields
      vendorIds: List<int>.from(json['parentVendors']),
      skuCount: json['skuCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'brandId': brandId,
      'clicks': clicks,
      'name': name,
      'description': description,
      'homepageDescription': homepageDescription,
      'logoUrl': logoUrl,
      'isActive': isActive,
      'featured': featured,
      'isNavigable': isNavigable,
      'position': position,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'products': products?.map((product) => product.toJson()).toList(),
      'productBrandMedia': productBrandMedia?.map((media) => media.toJson()).toList(),

      // new fields
      'parentVendors': vendorIds,
      'skuCount': skuCount ?? 0,
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  /// Convert Category into Product display for navigation
  ProductSimple toSimpleProduct() {
    return ProductSimple(name: this.name, imageUrl: '', price: 0, isActive: this.isActive, productId: brandId);
  }

  @override
  bool operator ==(covariant ProductBrand other) =>
      runtimeType == other.runtimeType && brandId == other.brandId && name == other.name;

  @override
  int get hashCode => Object.hash(id, brandId, name);
}
