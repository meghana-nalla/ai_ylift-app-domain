import 'dart:math';

import 'package:YLift/core/constants/color.dart';
import 'package:YLift/core/constants/constant.dart';
import 'package:YLift/core/controllers/global.dart';
import 'package:YLift/core/repositories/image_repository.dart';
import 'package:YLift/models/z-index_export.dart';
import 'package:YLift/presentation/components/z-index_export.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

final _sculptraImageUrl = ImageRepository.getBannerImage('0c73e6c6-c796-4cd2-a7e5-3351189b41f1');
    // 'https://phantom.ylift.app/media/api/optimized/variant/image/banners/file/0c73e6c6-c796-4cd2-a7e5-3351189b41f1';
final _jeaveauImageUrl = ImageRepository.getBannerImage('867de940-9c65-4ae1-99e1-cf4b55736b96');
    // 'https://phantom.ylift.app/media/api/optimized/variant/image/banners/file/867de940-9c65-4ae1-99e1-cf4b55736b96';

class CategorySubNavigationPanel extends StatelessWidget {
  final void Function(bool isHovered) onHover;
  final void Function() onCategorySelected;

  CategorySubNavigationPanel({
    super.key,
    required this.onHover,
    required this.onCategorySelected,
  });

  static const titleTextStyle = TextStyle(fontSize: 13.33, fontWeight: FontWeight.bold, letterSpacing: 1.8);
  static const categoryTextStyle = TextStyle(color: Color(0xFF606060), fontSize: 13.33, letterSpacing: 1.8);

  final global = Get.find<GlobalController>();

  List<Widget> _createCategoriesGroupings(int groupSize) {
    List<Widget> groups = [];
    int numGroupings = (global.categories.length ~/ groupSize);
    if (global.categories.length % groupSize != 0) numGroupings++;

    for (int i = 0; i < numGroupings; i++) {
      List<Widget> subGrouping = [];

      for (int j = 0; j < min(groupSize, global.categories.length - (i * groupSize)); j++) {
        DropdownSelector dropdownSelector = DropdownSelector(
            labelName: global.categories[(i * groupSize) + j].name,
            onTap: () {
              onCategorySelected();

              final category = global.categories[(i * groupSize) + j];
              global.selectedBrandId.value = 'category=${category.categoryId}';

              global.vroute.navigateTo('/shop/all', extra: 'category=${category.categoryId}');
            });
        subGrouping.add(dropdownSelector);
      }

      Column subColumn = Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: subGrouping,
      );

      groups.add(subColumn);
      groups.add(SizedBox(
        width: 32,
      ));
    }

    return groups;
  }

  ProductCategory? getCategory(String categoryName) {
    final category = global.categories.firstWhereOrNull((category) {
      final a = category.name.toLowerCase().trim();
      final b = categoryName.toLowerCase();
      return a.contains(b);
    });
    return category;
  }

  ProductBrand? getBrand(String brandName) {
    final brand = global.brands.firstWhereOrNull((brand) {
      final a = brand.name.toLowerCase();
      final b = brandName.toLowerCase();
      return a.contains(b);
    });
    print('selected brand name ${brandName}');
    print('${brand?.name}');
    return brand;
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Column(
      children: [
        MouseRegion(
          onEnter: (event) => onHover(true),
          onExit: (event) => onHover(false),
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
                padding: const EdgeInsets.only(top: 32, bottom: 48),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('CATEGORIES', style: titleTextStyle),
                          const SizedBox(height: 8),
                          Expanded(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: _createCategoriesGroupings(7),
                            ),
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
                                  onCategorySelected();

                                  final brand = getBrand('SCULPTRA');
                                  if (brand?.brandId != null) {
                                    // use the new direct brand route
                                    global.vroute.navigateTo('/shop/brand/${brand!.brandId}');
                                  } else {
                                    // fallback to shop/all if brand not found
                                    global.vroute.navigateTo('/shop/all');
                                  }
                                  onHover(false);
                                },
                                child: Column(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.all(Radius.circular(15)),
                                      child: Image.network(
                                        _sculptraImageUrl,
                                        width: 320,
                                        height: 160,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Text('DISCOVER SCULPTRA', style: TextStyle(fontWeight: FontWeight.w500)),
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
                                  onCategorySelected();

                                  final brand = getBrand('Jeuveau');
                                  if (brand?.brandId != null) {
                                    // use the new direct brand route
                                    global.vroute.navigateTo('/shop/brand/${brand!.brandId}');
                                  } else {
                                    // fallback to shop/all if brand not found
                                    global.vroute.navigateTo('/shop/all');
                                  }
                                  onHover(false);
                                },
                                child: Column(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.all(Radius.circular(15)),
                                      child: Image.network(
                                        _jeaveauImageUrl,
                                        width: 320,
                                        height: 160,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Text('FIND YOUR JEUVEAU', style: TextStyle(fontWeight: FontWeight.w500)),
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
          onEnter: (event) => onHover(false),
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
