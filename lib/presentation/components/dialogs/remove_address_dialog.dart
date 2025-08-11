import 'package:YLift/core/controllers/global.dart';
import 'package:YLift/presentation/components/buttons/mobile_icon.dart';
import 'package:flutter/material.dart';
import 'package:galaxy_models/galaxy_models.dart';
import 'package:get/get.dart';

class RemoveAddressDialog extends StatefulWidget {
  final AddressSimple address;
  const RemoveAddressDialog({
    super.key,
    required this.address,
  });

  @override
  State<RemoveAddressDialog> createState() => _RemoveAddressDialogState();
}

class _RemoveAddressDialogState extends State<RemoveAddressDialog> {
  bool isLoading = false;
  String? errorMessage;

  void removeAddress() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });
      final global = Get.find<GlobalController>();
      await global.addressBook.deleteAddress(widget.address);
      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        errorMessage = 'Failed to remove address, please try again later.';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      insetPadding: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Remove Address',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                MobileIcon(
                  onPressed: () => Navigator.pop(context),
                  icon: Icons.close,
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Do you want to remove this address?',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),
            Text(
              widget.address.twoLines,
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 24),
            if (errorMessage != null)
              Text(
                errorMessage!,
                style: TextStyle(color: Colors.red),
              ),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  // backgroundColor: YLiftColor.orange,
                  foregroundColor: YLiftColor.orange,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  side: const BorderSide(color: YLiftColor.orange, width: 1),
                  textStyle: const TextStyle(fontSize: 14, letterSpacing: 1),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                ),
                onPressed: isLoading ? null : removeAddress,
                child: const Text('Remove Address'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
