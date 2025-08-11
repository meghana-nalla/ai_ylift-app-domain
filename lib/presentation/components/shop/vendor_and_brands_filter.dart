import 'package:YLift/core/controllers/global.dart';
import 'package:galaxy_models/galaxy_models.dart';
import 'package:YLift/models/z-index_export.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VendorAndBrandsFilter extends StatefulWidget {
  final Set<ProductBrand> selectedBrands;
  final void Function(Set<ProductBrand> brands) onSelected;

  const VendorAndBrandsFilter({
    super.key,
    required this.selectedBrands,
    required this.onSelected,
  });

  @override
  State<VendorAndBrandsFilter> createState() => _VendorAndBrandsFilterState();
}

class _VendorAndBrandsFilterState extends State<VendorAndBrandsFilter> {
  final global = Get.find<GlobalController>();
  late List<VendorSimple> vendors;
  late List<ProductBrand> brands;

  @override
  void initState() {
    loadData();
    print('Vendors count: ${vendors.length}');
    print('Brands count: ${brands.length}');

    super.initState();
  }

  void loadData() async {
    vendors = global.vendors;
    vendors.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase())); // Sort vendors A-Z (in place)
    brands = global.brands;
  }

  static const _titleStyle = TextStyle(fontSize: 13.33, letterSpacing: 1);

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text('VENDORS & BRANDS', style: _titleStyle.copyWith(fontWeight: FontWeight.w600)),
      initiallyExpanded: true,
      shape: const RoundedRectangleBorder(),
      childrenPadding: const EdgeInsets.only(left: 16),
      children: [
        ...vendors.map((vendor) {
          final brandsByVendor = brands
              .where((brand) => (vendor.brandIds.contains(brand.brandId) || brand.vendorIds.contains(vendor.vendorId)));

          final brandsForUI = brandsByVendor.length == 1 && brandsByVendor.first.name == vendor.name
              ? <ProductBrand>[]
              : brandsByVendor;
          final isAllChecked = brandsByVendor.every((brand) => widget.selectedBrands.contains(brand));
          final isAllUnchecked = brandsByVendor.every((brand) => !widget.selectedBrands.contains(brand));
          final tristateValue = isAllChecked
              ? true
              : isAllUnchecked
                  ? false
                  : null;

          return Column(
            children: [
              FilterTile(
                tristate: true,
                value: tristateValue,
                title: Text(
                  vendor.name,
                  style: _titleStyle.copyWith(fontWeight: FontWeight.w600),
                ),
                onChanged: (value) {
                  final prevBrands = widget.selectedBrands.toSet();
                  if (isAllChecked) {
                    prevBrands.removeAll(brandsByVendor);
                  } else {
                    prevBrands.addAll(brandsByVendor);
                  }
                  widget.onSelected(prevBrands);
                },
              ),
              ...brandsForUI.map((brand) {
                final isSelected = widget.selectedBrands.map((e) => e.brandId!).contains(brand.brandId) ?? false;

                return FilterTile(
                  value: isSelected,
                  onChanged: (value) {
                    final prevBrands = widget.selectedBrands.toSet();
                    if (widget.selectedBrands.contains(brand)) {
                      prevBrands.remove(brand);
                    } else {
                      prevBrands.add(brand);
                    }
                    widget.onSelected(prevBrands);
                  },
                  title: Text(
                    brand.name,
                    style: _titleStyle,
                  ),
                  contentPadding: const EdgeInsets.only(left: 32),
                );
              }),
            ],
          );
        }),
      ],
    );
  }
}

class FilterTile extends StatelessWidget {
  final Widget title;
  final bool? value;
  final void Function(bool? value) onChanged;
  final EdgeInsets contentPadding;

  final bool tristate;

  const FilterTile({
    super.key,
    required this.value,
    required this.title,
    required this.onChanged,
    this.contentPadding = EdgeInsets.zero,
    this.tristate = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(value),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Padding(
          padding: contentPadding,
          child: Row(
            children: [
              Transform.scale(
                scale: 0.8,
                child: Checkbox(
                  tristate: tristate,
                  value: value,
                  onChanged: onChanged,
                  side: BorderSide(color: Color(0xFFBBBBBB)),
                ),
              ),
              const SizedBox(width: 8),
              title,
            ],
          ),
        ),
      ),
    );
  }
}
