import 'package:flutter/material.dart';
import 'package:galaxy_ui/galaxy_ui.dart';
import 'package:galaxy_models/galaxy_models.dart';
class EventDetailDialog extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String description;

  const EventDetailDialog({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SelectionArea(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          width: 1000,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Ticket Information',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              Image.network(imageUrl),
              Text(
                name,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                description,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              // Container(
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.all(Radius.circular(8)),
              //     border: Border.all(color: Colors.grey.shade200),
              //   ),
              //   padding: const EdgeInsets.all(16),
              //   child: CartVirtualItemTile(
              //     imageUrl: imageUrl,
              //     name: name,
              //     doctorName: description,
              //   ),
              // ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  _buildInfo('Location', '2 E 61st #413, New York, NY, 10065'),
                  _buildInfo(
                    'Time & Date',
                    'June 21 - 22, 2025. 8AM to Finish (EST)',
                  ),
                  _buildInfo(
                    'Contact Info',
                    'Contact us at (212) 861-7787 or email us at info@ylift.com.',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfo(String label, String value) {
    return Row(
      children: [
        Text(
          '$label: ',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(value),
        ),
      ],
    );
  }
}
