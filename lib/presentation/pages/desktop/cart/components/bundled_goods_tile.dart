import 'package:YLift/core/constants/color.dart';
import 'package:YLift/core/controllers/global.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BundledGoodsTile extends StatelessWidget {
  final String title;
  final String skuNumber;
  final void Function()? onDelete;

  const BundledGoodsTile({
    super.key,
    required this.title,
    required this.skuNumber,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Icon(Icons.shopping_bag_outlined),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                'YLS-SKU: #$skuNumber',
                style: TextStyle(fontSize: 13.33, color: YLiftColor.orange),
              ),
            ],
          ),

          const Spacer(),
          IconButton(
            onPressed: onDelete,
            icon: const Icon(Icons.delete, size: 16),
            padding: EdgeInsets.zero,
            // constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}

class DeleteBundleDialog extends StatefulWidget {
  final String tradeGoodId;
  final String title;
  final String skuNumber;

  const DeleteBundleDialog({
    super.key,
    required this.tradeGoodId,
    required this.title,
    required this.skuNumber,
  });

  @override
  State<DeleteBundleDialog> createState() => _DeleteBundleDialogState();
}

class _DeleteBundleDialogState extends State<DeleteBundleDialog> {
  bool isLoading = false;

  void deleteTradeGood() async {
    try {
      setState(() {
        isLoading = true;
      });
      final global = Get.find<GlobalController>();
      await global.basket.removeTradeGood(widget.tradeGoodId);
      if (!mounted) return;
      Navigator.pop(context);
    } catch (e, s) {
      print('$e\n$s');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Delete Bundle ${widget.title}'),
      content: Text('Are you sure you want to delete this bundle?'),
      actions: [
        TextButton(
          onPressed:
              isLoading
                  ? null
                  : () {
                    Navigator.pop(context);
                  },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: isLoading ? null : deleteTradeGood,
          child: const Text('Delete'),
        ),
      ],
    );
  }
}
