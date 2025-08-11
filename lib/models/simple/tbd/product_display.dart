import 'package:YLift/models/z-index_export.dart';
import 'package:galaxy_models/galaxy_models.dart';

class DisplayProducts {
  final List<ProductSimple> items;
  final bool showPrice;

  DisplayProducts({
    required this.items,
    required this.showPrice,
  });
}

class DisplayProduct {
  final ProductSimple product;
  final SkuSimple? sku; //details of the selected variant
  final bool showPrice;
  final bool dataComplete;
  final List<SkuSimple>? skus; // we need this for the variant selection
  final List<ProductSimple>? relatedProducts;

  DisplayProduct({
    required this.product,
    this.sku,
    required this.showPrice,
    this.skus,
    this.dataComplete = false,
    this.relatedProducts,
  });
}

const _sku = StoreSku(
  cost: 100,
  defaultProductMediaId: 0,
  isArchived: false,
  isActive: false,
  isResellable: false,
  productId: 1,
  defaultPrice: 100,
  quantityIncrement: 1,
  quantityMin: 1,
  quantityMax: 200,
);
