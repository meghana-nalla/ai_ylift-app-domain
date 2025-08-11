import 'package:YLift/presentation/components/z-index_export.dart';
import 'package:flutter/material.dart';
import 'package:galaxy_models/galaxy_models.dart';

class ShippingAddressTile extends StatelessWidget {
  final AddressSimple? address;
  final void Function()? onTap;
  final EdgeInsets padding;
  final bool? isMobile;

  const ShippingAddressTile({
    super.key,
    this.padding = const EdgeInsets.all(24),
    this.address,
    this.onTap,
    this.isMobile = false,
  });

  @override
  Widget build(BuildContext context) {
    final title = address == null ? const Text('Please select an address') : Text(address!.display, style: TextStyle(fontSize: isMobile == true ? 13: null));

    return GalaxyPanel(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            onTap: onTap,
            title: title,
            subtitle: address != null
                ? Text(
                    '${address!.name}     |      ${address!.phone}',
                    style: TextStyle(color: Color(0xFF818181), fontSize: isMobile == true ? 13: 13.33),
                  )
                : null,
            trailing: const Icon(Icons.edit),
          ),
          if (address?.isValid == false)
            Padding(
              padding: EdgeInsets.only(left: 16),
              child: Text(
                'Invalid address, please add or select another address',
                style: TextStyle(color: YLiftColor.orange, fontSize: 11.11),
              ),
            ),
        ],
      ),
    );
  }
}
