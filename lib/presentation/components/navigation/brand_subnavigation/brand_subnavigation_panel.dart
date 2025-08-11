import 'package:YLift/core/constants/color.dart';
import 'package:YLift/core/constants/constant.dart';
import 'package:YLift/core/repositories/image_repository.dart';
import 'package:YLift/models/z-index_export.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'package:YLift/core/controllers/global.dart';
import 'package:YLift/presentation/components/z-index_export.dart';

final _galdermaImageUrl = ImageRepository.getBannerImage('801a5178-2864-4f05-aecf-30a019f6f757');
final _alastinImageUrl = ImageRepository.getBannerImage('70516ba2-90c1-49bd-b511-b4cc716cd0f4');

class BrandSubNavigationPanel extends StatefulWidget {
  final void Function(bool isHovered) onHover;
  final void Function() onBrandSelected;

  const BrandSubNavigationPanel({
    super.key,
    required this.onHover,
    required this.onBrandSelected,
  });

  @override
  State<BrandSubNavigationPanel> createState() => _BrandSubNavigationPanelState();
}

class _BrandSubNavigationPanelState extends State<BrandSubNavigationPanel> {
  final GlobalController global = Get.find<GlobalController>();
  static const titleTextStyle = TextStyle(fontSize: 13.33, fontWeight: FontWeight.bold, letterSpacing: 1.8);

  // TODO populate this list from real brands data
  final List<String> newBrands = ['Promoitalia', 'Préime', 'Evoskin'];

  final List<String> cultBrands = [
    'Restylane',
    'Sculptra',
    'Dysport',
    'Jeuveau',
    'Alastin',
    'Benev',
  ];

  ProductBrand? getBrand(String brandName) {
    final brand = global.brands.firstWhereOrNull((brand) {
      final a = brand.name.toLowerCase();
      final b = brandName.toLowerCase();
      return a.contains(b);
    });
    return brand;
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Column(
      children: [
        MouseRegion(
          onEnter: (event) => widget.onHover(true),
          onExit: (event) => widget.onHover(false),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: YLiftColor.grey3)),
            ),
            width: screenSize.width,
            height: 300,
            alignment: Alignment.center,
            child: SizedBox(
              width: YLiftConstant.pageWidth,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('OUR NEW BRANDS', style: titleTextStyle),
                              const SizedBox(height: 8),
                              ...List.generate(newBrands.length, (index) {
                                return DropdownSelector(
                                  onTap: () {
                                    widget.onBrandSelected();

                                    final brandName = newBrands[index];
                                    final brand = global.brands
                                        .firstWhereOrNull((brand) => brand.name.toLowerCase() == brandName.toLowerCase());
                                    final brandId = brand?.brandId;

                                    if (brandId != null) {
                                      // use the new direct brand route
                                      global.vroute.navigateTo('/shop/brand/$brandId');
                                    } else {
                                      // fallback to shop/all if brand not found
                                      global.vroute.navigateTo('/shop/all');
                                    }
                                  },
                                  labelName: newBrands[index],
                                );
                              }),
                            ],
                          ),
                          const SizedBox(width: 56),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('OUR CULT BRANDS', style: titleTextStyle),
                              SizedBox(height: 8),
                              ...List.generate(cultBrands.length, (index) {
                                return DropdownSelector(
                                  onTap: () {
                                    widget.onBrandSelected();

                                    final brandName = cultBrands[index];
                                    final brand = global.brands
                                        .firstWhereOrNull((brand) => brand.name.toLowerCase().trim().contains(brandName.toLowerCase().trim()));
                                    final brandId = brand?.brandId;
                                    
                                    if (brandId != null) {
                                      // use the new direct brand route
                                      global.vroute.navigateTo('/shop/brand/$brandId');
                                    } else {
                                      // fallback to shop/all if brand not found
                                      global.vroute.navigateTo('/shop/all');
                                    }
                                  },
                                  labelName: cultBrands[index],
                                );
                              }),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: () {
                                  widget.onBrandSelected();

                                  final brand = getBrand('restylane');
                                  if (brand?.brandId != null) {
                                    // use the new direct brand route
                                    global.vroute.navigateTo('/shop/brand/${brand!.brandId}');
                                  } else {
                                    // fallback to shop/all if brand not found
                                    global.vroute.navigateTo('/shop/all');
                                  }
                                  widget.onHover(false);
                                },
                                child: Column(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.all(Radius.circular(15)),
                                      child: Image.network(
                                        _galdermaImageUrl,
                                        width: 320,
                                        height: 160,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Text('OUR RESTYLANE COLLECTION', style: TextStyle(fontWeight: FontWeight.w500)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 32),
                          Expanded(
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: () {
                                  widget.onBrandSelected();

                                  final brand = getBrand('alastin');
                                  if (brand?.brandId != null) {
                                    // use the new direct brand route
                                    global.vroute.navigateTo('/shop/brand/${brand!.brandId}');
                                  } else {
                                    // fallback to shop/all if brand not found
                                    global.vroute.navigateTo('/shop/all');
                                  }
                                  widget.onHover(false);
                                },
                                child: Column(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.all(Radius.circular(15)),
                                      child: Image.network(
                                        _alastinImageUrl,
                                        width: 320,
                                        height: 160,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Text('EXPLORE ALASTIN SKINCARE', style: TextStyle(fontWeight: FontWeight.w500)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 96),
                  ],
                ),
              ),
            ),
          ),
        ),
        MouseRegion(
          onEnter: (event) => widget.onHover(false),
          child: Container(
            width: screenSize.width,
            height: 2000,
            color: Colors.transparent,
          ),
        ),
      ],
    );
  }
}
