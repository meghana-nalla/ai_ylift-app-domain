import 'package:YLift/core/controllers/global.dart';
import 'package:galaxy_models/galaxy_models.dart';
import 'package:YLift/presentation/components/_complex/dialogs/billing_addresses_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:galaxy_ui/galaxy_ui.dart';
class SelectAddressField extends StatefulWidget {
  final void Function(AddressSimple address) onSelectedAddress;
  const SelectAddressField({super.key, required this.onSelectedAddress});

  @override
  State<SelectAddressField> createState() => _SelectAddressFieldState();
}

class _SelectAddressFieldState extends State<SelectAddressField> {
  final global = Get.find<GlobalController>();

  AddressSimple? selectedAddress;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Billing address', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 4),
            if (selectedAddress != null) ...[
              Text(selectedAddress!.display, style: TextStyle(fontSize: 16)),
              Text(selectedAddress!.name),
            ] else
              Text('Select a billing address'),
          ],
        ),
        const SizedBox(width: 16),
        IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder:
                  (context) => BillingAddressesDialog(
                    onSelectedAddress: (address) {
                      setState(() {
                        selectedAddress = address;
                      });
                      widget.onSelectedAddress(address);
                    },
                  ),
            );
          },
          icon: Icon(Icons.edit),
        ),
      ],
    );
  }
}
