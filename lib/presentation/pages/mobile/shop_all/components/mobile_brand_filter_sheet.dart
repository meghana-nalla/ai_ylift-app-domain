import 'package:YLift/core/controllers/global.dart';
import 'package:YLift/models/api/product_brand.dart';
import 'package:YLift/presentation/components/mobile_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:galaxy_models/galaxy_models.dart';
import 'package:galaxy_ui/galaxy_ui.dart';
import 'package:get/get.dart';

final _global = Get.find<GlobalController>();

class MobileBrandFilterSheet extends StatelessWidget {
  final List<VendorSimple> vendors;
  final List<ProductBrand> brands;

  final Set<int> selectedBrandIds;

  final void Function(Set<int> brandIds) onBrandsUpdated;

  const MobileBrandFilterSheet({
    super.key,
    required this.vendors,
    required this.brands,
    required this.selectedBrandIds,
    required this.onBrandsUpdated,
  });

  void onVendorCheckboxChanged(
    Iterable<ProductBrand> brandsByVendor,
    bool? isChecked,
  ) {
    final brandIds = brandsByVendor.map(
      (brand) => brand.brandId!,
    );

    switch (isChecked) {
      case true:
        selectedBrandIds.removeAll(brandIds);
        break;
      case false || null:
        selectedBrandIds.addAll(brandIds);
        break;
    }

    onBrandsUpdated(selectedBrandIds);
  }

  bool? getVendorCheckboxState(VendorSimple vendor) {
    final vendorBrands =
        brands
            .where((brand) => brand.vendorIds.contains(vendor.vendorId))
            .toList();

    if (vendorBrands.isEmpty) return false;

    final selectedBrandsCount =
        vendorBrands
            .where((brand) => selectedBrandIds.contains(brand.brandId))
            .length;

    if (selectedBrandsCount == 0) {
      return false;
    } else if (selectedBrandsCount == vendorBrands.length) {
      return true;
    } else {
      return null;
    }
  }

  String getButtonText() {
    if (selectedBrandIds.isEmpty) return 'Select All Products';
    final productCount =
        _global.allProducts.value
            .getProductsByBrandIds(brandIds: selectedBrandIds.toList())
            .length;
    return 'Show $productCount Products';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: YLiftColor.divider,
                  width: 0.8,
                ),
              ),
            ),
            height: 48,
            width: double.infinity,
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Text(
                  'Brand Filter',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Positioned(
                  right: 8,
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: vendors.length,
              separatorBuilder:
                  (context, index) => const Divider(
                    height: 16,
                    thickness: 0.8,
                    color: YLiftColor.divider,
                  ),
              itemBuilder: (context, index) {
                final vendor = vendors[index];
                final brandsByVendor = brands.where(
                  (brand) => brand.vendorIds.contains(vendor.vendorId),
                );

                final isVendorSelected = getVendorCheckboxState(vendor);

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap:
                          () => onVendorCheckboxChanged(
                            brandsByVendor,
                            isVendorSelected,
                          ),
                      child: Container(
                        color: Colors.white,
                        child: Row(
                          children: [
                            Checkbox(
                              tristate: true,
                              value: isVendorSelected,
                              onChanged:
                                  (value) => onVendorCheckboxChanged(
                                    brandsByVendor,
                                    value,
                                  ),
                            ),
                            Text(
                              vendor.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (brandsByVendor.length > 1 ||
                        (brandsByVendor.length == 1 &&
                            !brandsByVendor.first.name.contains(vendor.name)))
                      Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: Column(
                          children: brandsByVendor
                              .map(
                                (brand) {
                                  final isBrandSelected = selectedBrandIds
                                      .contains(brand.brandId);

                                  return GestureDetector(
                                    onTap: () {
                                      if (isBrandSelected) {
                                        selectedBrandIds.remove(
                                          brand.brandId!,
                                        );
                                      } else {
                                        selectedBrandIds.add(
                                          brand.brandId!,
                                        );
                                      }
                                      onBrandsUpdated(selectedBrandIds);
                                    },
                                    child: Container(
                                      color: Colors.white,
                                      child: Row(
                                        children: [
                                          Checkbox(
                                            value: isBrandSelected,
                                            onChanged: (value) {
                                              if (selectedBrandIds.contains(
                                                brand.brandId,
                                              )) {
                                                selectedBrandIds.remove(
                                                  brand.brandId!,
                                                );
                                              } else {
                                                selectedBrandIds.add(
                                                  brand.brandId!,
                                                );
                                              }
                                              onBrandsUpdated(selectedBrandIds);
                                            },
                                          ),
                                          Text(
                                            brand.name,
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              )
                              .toList(growable: false),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
          MobileBar(
            padding: const EdgeInsets.all(16),
            child: GalaxyFilledButton(
              backgroundColor: YLiftColor.orange,
              onPressed: () => Navigator.pop(context),
              child: Text(getButtonText()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow({
    required bool? value,
    required void Function(bool? value) onChanged,
    required Widget title,
    double leftPadding = 0.0,
  }) {
    return GestureDetector(
      onTap: () => onChanged(!(value ?? false)),
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.only(left: leftPadding),
        child: Row(
          children: [Checkbox(value: value, onChanged: onChanged), title],
        ),
      ),
    );
  }
}
