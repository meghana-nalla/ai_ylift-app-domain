import 'package:YLift/models/z-index_export.dart';

class SearchResult {
  final int? count;
  final List<ProductSimple>? products;
  final Map<String, dynamic>? aggregations;

  SearchResult({
    this.count,
    this.products,
    this.aggregations,
  });

  factory SearchResult.fromJson(Map<String, dynamic> json) {
    return SearchResult(
      count: json['count'] ?? 0,
      products: (json['rows'] as List<dynamic>?)
          ?.map((productJson) => ProductSimple.fromJson(productJson))
          .toList() ?? [],
      aggregations: json['aggregations'] ?? {},
    );
  }
}