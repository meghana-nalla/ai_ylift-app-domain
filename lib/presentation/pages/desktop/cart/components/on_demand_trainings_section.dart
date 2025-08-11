import 'package:flutter/material.dart';
import 'package:galaxy_models/galaxy_models.dart';
import 'package:galaxy_ui/galaxy_ui.dart';

class OnDemandTrainingsSection extends StatelessWidget {
  final List<VirtualItem> virtualItems;
  const OnDemandTrainingsSection({super.key, required this.virtualItems});

  @override
  Widget build(BuildContext context) {
    if (virtualItems.isEmpty) {
      return Container();
    }
    return
        Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         SizedBox(height: 32),
        Text(
          'Video / Training Bundle',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
         SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          padding:  EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 16,
            children:
                virtualItems
                    .map(
                      (e) => CartVirtualItemTile(
                        imageUrl: e.imageUrl,
                        name: e.productName.isNotEmpty ? e.productName : e.description,
                        doctorName: e.authorName,
                        // unlockMessage: e.,
                        onDelete: () {},
                      ),
                    )
                    .toList(),
          ),
        ),
      ],
    );
  }
}
