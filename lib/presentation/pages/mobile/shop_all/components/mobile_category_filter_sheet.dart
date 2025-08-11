import 'package:YLift/core/controllers/global.dart';
import 'package:YLift/models/simple/z-index_export.dart';
import 'package:YLift/presentation/components/mobile_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:galaxy_models/core/constants/y_lift_color.dart';
import 'package:galaxy_ui/galaxy_ui.dart';
import 'package:get/get.dart';

final _global = Get.find<GlobalController>();

class MobileCategoryFilterSheet extends StatelessWidget {
  final List<ProductCategory> categories;
  final Set<int> selectedCategoryIds;
  final void Function(int value) onCategorySelected;

  const MobileCategoryFilterSheet({
    super.key,
    required this.categories,
    required this.selectedCategoryIds,
    required this.onCategorySelected,
  });

  String get buttonText {
    final productCount =
        _global.allProducts.value
            .getProductsByCategoryIds(categoryIds: selectedCategoryIds.toList())
            .length;
    if (productCount > 0) return 'Show $productCount Products';
    return 'Show All Products';
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
                  'Category Filter',
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
              itemCount: categories.length,
              separatorBuilder:
                  (context, index) => const Divider(
                    height: 8,
                    thickness: 0.8,
                    color: YLiftColor.divider,
                  ),
              itemBuilder: (context, index) {
                final category = categories[index];

                final isSelected = selectedCategoryIds.contains(
                  category.categoryId,
                );
                return GestureDetector(
                  onTap: () => onCategorySelected(category.categoryId),
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      children: [
                        Checkbox(
                          value: isSelected,
                          onChanged:
                              (_) => onCategorySelected(category.categoryId),
                        ),
                        const SizedBox(width: 8),
                        SizedBox.square(
                          dimension: 24,
                          child: Image.network(category.imageUrl),
                        ),
                        const SizedBox(width: 8),
                        Text(category.name),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          MobileBar(
            padding: const EdgeInsets.all(16),
            child: GalaxyFilledButton(
              backgroundColor: YLiftColor.orange,
              onPressed: () => Navigator.pop(context),
              child: Text(buttonText),
            ),
          ),
        ],
      ),
    );
  }
}
