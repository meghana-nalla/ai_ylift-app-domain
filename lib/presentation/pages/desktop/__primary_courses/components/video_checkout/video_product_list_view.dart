import 'package:YLift/core/extensions/price_extension.dart';
import 'package:YLift/presentation/pages/desktop/__primary_courses/components/simple_quantity_dropdown.dart';
import 'package:YLift/presentation/pages/desktop/__primary_courses/components/video_checkout/dynamic_checkout_dialog.dart';
import 'package:flutter/material.dart';

class VideoProductListView extends StatelessWidget {
  final List<VideoProductItem> items;
  final void Function(VideoProductItem item, int newQuantity) onQuantityChanged;
  const VideoProductListView({
    super.key,
    required this.items,
    required this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    const radius = Radius.circular(8);

    return ListView.separated(
      itemCount: items.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      padding: const EdgeInsets.only(right: 8),
      itemBuilder: (context, index) {
        final item = items[index];
        return SizedBox(
          height: 64,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: Image.network(item.imageUrl),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: TextStyle(
                      fontSize: 13.33,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    item.skuAttributes,
                    style: TextStyle(fontSize: 11.11, color: Colors.grey),
                  ),
                ],
              ),
              const Spacer(),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: const BorderRadius.only(
                    topLeft: radius,
                    bottomLeft: radius,
                  ),
                ),
                padding: const EdgeInsets.only(
                  left: 12,
                  top: 12,
                  bottom: 12,
                  right: 8,
                ),
                child: Row(
                  children: [
                    Text(
                      item.price.toCurrency(),
                      style: TextStyle(
                        fontSize: 13.33,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 32),
                    const Text(
                      'Quantity:',
                      style: TextStyle(
                        fontSize: 11.11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SimpleQuantityDropdown(
                value: item.quantity,
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                border: Border(
                  top: BorderSide(color: Colors.grey.shade300),
                  bottom: BorderSide(color: Colors.grey.shade300),
                  right: BorderSide(color: Colors.grey.shade300),
                ),
                borderRadius: BorderRadius.only(
                  topRight: radius,
                  bottomRight: radius,
                ),
                padding: EdgeInsets.only(
                  left: 16,
                  top: 12,
                  bottom: 12,
                  right: 12,
                ),
                onChanged: (value) => onQuantityChanged(item, value),
              ),
              const SizedBox(width: 16),
            ],
          ),
        );
      },
    );
  }
}
