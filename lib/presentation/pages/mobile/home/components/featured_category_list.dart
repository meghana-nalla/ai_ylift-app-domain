import 'package:YLift/core/constants/color.dart';
import 'package:YLift/core/controllers/global.dart';
import 'package:YLift/models/simple/ProductCategory.dart';
import 'package:YLift/presentation/pages/mobile/categories/mobile_categories_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FeaturedCategoryList extends StatefulWidget {
  const FeaturedCategoryList({super.key});
  @override
  State<FeaturedCategoryList> createState() => _FeaturedCategoryListState();
}

class _FeaturedCategoryListState extends State<FeaturedCategoryList> {
  final global = Get.find<GlobalController>();

  static const categoryWidth = 150.0;
  static const categoryHeight = 35.0;

  bool isAtStart = true;
  bool isAtEnd = false;

  void goToCategoriesPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MobileCategoriesPage(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Trending Categories',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: goToCategoriesPage,
                child: Text(
                  'See All',
                  style: const TextStyle(fontSize: 14, color: YLiftColor.orange),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        SizedBox(
            height: 32,
            child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                itemCount: global.categories.length,
                scrollDirection: Axis.horizontal,
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final category = global.categories[index];
                  return CapsuleCategory(
                      categoryWidth: categoryWidth, categoryHeight: categoryHeight, category: category);
                }
            )
        )
      ],
    );
  }
}

class CapsuleCategory extends StatefulWidget {
  final double categoryWidth;
  final double categoryHeight;
  final ProductCategory category;
  const CapsuleCategory({
    super.key,
    required this.categoryWidth,
    required this.categoryHeight,
    required this.category
  });

  @override
  State<CapsuleCategory> createState() => _CapsuleCategoryState();
}

final GlobalController global = Get.find<GlobalController>();

class _CapsuleCategoryState extends State<CapsuleCategory> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: Container(
          color: YLiftColor.grey2,
          child: Center(
              child: GestureDetector(
                onTap: () {
                  final queryParameters = <String, String>{
                    'categoryIds': '${widget.category.categoryId}',
                  };
                  final uri = Uri(path: '/shop/all', queryParameters: queryParameters);
                  global.vroute.navigateTo('$uri');
                  // global.selectedBrandId.value = 'categoryId=' + widget.category.categoryId.toString();
                  // global.vroute.navigateTo('/categories');
                  //global.vroute.navigateQuickLinksTap(4);
                },
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                          width: 30,
                          height: 30,
                          margin: EdgeInsets.symmetric(horizontal: 3, vertical: 3),
                          clipBehavior: Clip.antiAlias,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: Image.network(widget.category.imageUrl,
                               height: 10,
                              alignment: Alignment.center,
                              width: 10,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) => Image.asset('msc/images/ys_logo.png')
                          )
                      ),
                      Text(
                        widget.category.name,
                        style: const TextStyle(
                          fontSize: 13,
                            fontWeight: FontWeight.w500, height: 1.6,
                            color: Colors.black
                        ),
                      ),
                      SizedBox(width: 16),
                    ]
                ),
              )
          ),
        ),
      ),
    );
  }
}
