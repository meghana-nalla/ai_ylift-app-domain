import 'package:YLift/core/constants/color.dart';
import 'package:YLift/core/constants/constant.dart';
import 'package:YLift/presentation/components/z-index_export.dart';
import 'package:flutter/material.dart';
import 'package:galaxy_ui/galaxy_ui.dart';
// Save for Later feature
class SavedProductsPanel extends StatelessWidget {
  const SavedProductsPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: 5,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        return Row(
          children: [
            SizedBox.square(
              dimension: 120,
              child: Image.network(YLiftConstant.productImageUrlFallback),
            ),
            const SizedBox(width: 24),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Product name',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Quantity: 4 | Product caption/cost/etc',
                  style: TextStyle(color: YLiftColor.grey3),
                ),
              ],
            ),
            const Spacer(),
            Row(
              children: [
                OutlinedButton(
                  onPressed: () {},
                  child: const Text('Delete'),
                ),
                const SizedBox(width: 16),
                SizedBox(
                  width: 160,
                  child: RoundedFilledButton(
                    onPressed: () {},
                    child: const Text('Add to Cart'),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
