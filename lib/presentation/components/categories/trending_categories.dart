import 'package:YLift/models/simple/ProductCategory.dart';
import 'package:YLift/presentation/components/categories/trending_category_card.dart';
import 'package:flutter/material.dart';

class TrendingCategories extends StatelessWidget {
  final List<ProductCategory> categories;
  final VoidCallback onSeeAll;
  ValueSetter<ProductCategory> onCategorySelect;
  TrendingCategories({
    super.key,
    required this.categories,
    required this.onSeeAll,
    required this.onCategorySelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Trending Categories',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            TextButton(
              onPressed: onSeeAll,
              child: Text('See All'),
            ),
          ]
        ),),
        SizedBox(height: 8,),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ListView.separated(
              itemCount: categories.length,
              scrollDirection: Axis.horizontal,
              separatorBuilder: (context, index) => const SizedBox(width: 6),
              itemBuilder: (context, index) {
                return TrendingCategoryCard(productCategory: categories[index],
                    onCategorySelected: () => onCategorySelect(categories[index]));
                // return CapsuleCategory(
                //     categoryWidth: categoryWidth, categoryHeight: categoryHeight, category: category);
              }
          )
        )
      ]
    );
  }
}
