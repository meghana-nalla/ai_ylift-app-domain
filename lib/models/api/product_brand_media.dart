import 'dart:convert';

import 'package:YLift/models/api/product_brand.dart';

class ProductBrandMedia {
  int id;
  String url;
  bool mimeType;
  int productBrandId;
  DateTime createdAt;
  DateTime updatedAt;
  ProductBrand productBrand;

  ProductBrandMedia({
    required this.id,
    required this.url,
    required this.mimeType,
    required this.productBrandId,
    required this.createdAt,
    required this.updatedAt,
    required this.productBrand,
  });

  // Convert JSON to ProductBrandMedia object
  factory ProductBrandMedia.fromJson(Map<String, dynamic> json) {
    return ProductBrandMedia(
      id: json['id'] ?? 0,
      url: json['url'] ?? '',
      mimeType: json['mimeType'] ?? '',
      productBrandId: json['productBrandId'] ?? 0,
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
      productBrand: json['productBrand'] != null ? ProductBrand.fromJson(json['productBrand']) : ProductBrand.fromJson({}),
    );
  }

  // Convert ProductBrandMedia object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'mimeType': mimeType,
      'productBrandId': productBrandId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'productBrand': productBrand.toJson(),
    };
  }
}


