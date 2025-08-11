import 'package:YLift/core/constants/color.dart';
import 'package:YLift/models/simple/ProductCategory.dart';
import 'package:flutter/material.dart';

class TrendingCategoryCard extends StatelessWidget {
  final ProductCategory productCategory;
  final VoidCallback onCategorySelected;

  const TrendingCategoryCard({
    super.key,
    required this.productCategory,
    required this.onCategorySelected
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: 140,
      // height: 36,
      // padding: EdgeInsets.only(left: 8.0, top: 0.0, right: 0.0, bottom: 0.0),
      // color: YLiftColor.orange,
      // decoration: BoxDecoration(
      //   borderRadius: BorderRadius.circular(32),
      // ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: Container(
          color: YLiftColor.orange,
          child: Center(
              child: Container(
                  child: GestureDetector(
                    onTap: onCategorySelected,
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                              borderRadius: BorderRadius.circular(32),
                              child: Image.network(productCategory.imageUrl, width: 28)
                          ),
                          Text(
                            productCategory.name,
                            style: const TextStyle(
                                fontWeight: FontWeight.w500, height: 1.6),
                          ),
                        ]
                    ),
                  )
              )
          ),
        )
      )
    );
  }
}