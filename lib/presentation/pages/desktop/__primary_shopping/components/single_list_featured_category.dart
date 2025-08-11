import 'package:YLift/core/constants/color.dart';
import 'package:YLift/core/controllers/global.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:galaxy_ui/galaxy_ui.dart';
import 'package:YLift/models/simple/ProductCategory.dart';

class CategoryListView extends StatefulWidget {
  const CategoryListView({super.key});

  @override
  State<CategoryListView> createState() => _CategoryListViewState();
}

class _CategoryListViewState extends State<CategoryListView> {
  final global = Get.find<GlobalController>();

  static const categoryWidth = 150.0;
  static const nextCategory = categoryWidth + 24;
  static const nextCategories = nextCategory * 3;

  bool isAtStart = true;
  bool isAtEnd = false;

  void scrollListener() {
    final position = scrollController.position;
    setState(() {
      isAtStart = position.pixels == position.minScrollExtent;
      isAtEnd = position.pixels == position.maxScrollExtent;
    });
  }

  final scrollController = ScrollController();
  void scrollLeft() async {
    var nextPosition = scrollController.position.pixels - nextCategories;
    if (nextPosition < 0 || nextPosition < nextCategories) nextPosition = 0;
    await scrollController.animateTo(
      nextPosition,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void scrollRight() async {
    var nextPosition = scrollController.position.pixels + nextCategories;
    final max = scrollController.position.maxScrollExtent;
    if (nextPosition > max) nextPosition = max;
    await scrollController.animateTo(
      nextPosition,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void initState() {
    scrollController.addListener(scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Trending Categories',
              style: textTheme.titleLarge,
            ),
            const Spacer(),
            ArrowButton(
              direction: ArrowDirection.left,
              onPressed: isAtStart ? null : scrollLeft,
            ),
            const SizedBox(width: 18),
            ArrowButton(
              direction: ArrowDirection.right,
              onPressed: isAtEnd ? null : scrollRight,
            ),
          ],
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 160,
          child: ListView.separated(
            controller: scrollController,
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: global.categories.length,
            separatorBuilder: (context, index) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final category = global.categories[index];
              return HoverableCategory(
                categoryWidth: categoryWidth,
                category: category,
              );
            },
          ),
        ),
      ],
    );
  }
}

class HoverableCategory extends StatefulWidget {
  final double categoryWidth;
  final ProductCategory category;

  const HoverableCategory({
    super.key,
    required this.categoryWidth,
    required this.category,
  });

  @override
  State<HoverableCategory> createState() => _HoverableCategoryState();
}

class _HoverableCategoryState extends State<HoverableCategory> {
  bool isHovered = false;
  final global = Get.find<GlobalController>();

  Widget buildImage() {
    if (widget.category.name == 'Decor') {
      return Image.asset(
        'msc/images/categories/decor_icon.png',
        fit: BoxFit.cover,
      );
    } else {
      return Image.network(widget.category.imageUrl);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: GestureDetector(
        onTap: () {
          // global.vroute.navigateTo('/shop/all', extra: 'category=${widget.category.categoryId}');
          global.selectedBrandId.value =
              'category=${widget.category.categoryId}';
          debugPrint(
            'CATEGORY SELECTED: ${widget.category.name} ${widget.category.categoryId}',
          );
          global.vroute.navigateTo('/shop/all');
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            color: Colors.white,
            border:
                isHovered ? Border.all(color: Colors.black, width: 2) : null,
            boxShadow: const <BoxShadow>[
              BoxShadow(color: Colors.black26, blurRadius: 4),
            ],
          ),
          width: widget.categoryWidth,
          height: widget.categoryWidth,
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.all(4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(4),
                child: SizedBox.square(
                  dimension: 40,
                  child: buildImage(),
                ),
              ),
              const SizedBox(height: 8),
              if (widget.category.name
                  case 'Pharmaceuticals' || 'DermaCeuticals')
                Text(
                  widget.category.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    letterSpacing: -0.1,
                  ),
                )
              else
                Text(
                  widget.category.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    height: 1.6,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
