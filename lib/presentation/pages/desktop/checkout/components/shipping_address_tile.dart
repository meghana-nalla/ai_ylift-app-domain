import 'package:YLift/core/controllers/global.dart';
import 'package:galaxy_models/galaxy_models.dart';
import 'package:YLift/presentation/components/_complex/dialogs/saved_addresses_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:galaxy_models/galaxy_models.dart';
class ShippingAddressTile extends StatefulWidget {
  ShippingAddressTile({
    super.key,
    required this.controller,
    // required this.onAddressCreated,
  });

  final GlobalController controller;
  // final void Function(Address address) onAddressCreated;

  @override
  State<ShippingAddressTile> createState() => _ShippingAddressTileState();
}

class _ShippingAddressTileState extends State<ShippingAddressTile> {
  // boolean to keep track if there are no addresses
  bool _noAddresses = true;

  @override
  void initState() {
    super.initState();
    _noAddresses = true;
    initializeAddress();
  }

  void initializeAddress() async {
    await Future.delayed(const Duration(milliseconds: 3000));
    if (widget.controller.cart.value.checkout?.address != null) return;
    if (widget.controller.user.value.defaultAddress == null) return;
    final defaultAddress = widget.controller.user.value.defaultAddress!;

    // here, we confidently know we have an address
    setState(() {
      _noAddresses = false;
      // widget.controller.cart.value.checkout?.address = defaultAddress;
    });
  }

  String? _formatAddress(AddressSimple? address) {
    if (address == null) return null;
    return '${address.line1}, ${address.city}, ${address.state} ${address.zip}';
  }

  String? _formatNamePhone(AddressSimple? address) {
    if (address == null) return null;
    // split name using space and the last split is character with trailing comma
    return '${address.name.split(' ').first} ${address.name.split(' ').last}, ${address.phone}';
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final selectedAddress = widget.controller.cart.value.checkout?.address;
        print(_formatAddress(selectedAddress) ?? 'No selected address');

        return Card(
          child: ListTile(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => SavedAddressesDialog(
                  update: () {
                    setState(() {});
                  },
                  onSelectedAddress: (address) {

                  },
                  // onAddressCreated: widget.onAddressCreated,
                ),
              );
            },
            title: ((selectedAddress != null)
                ? Text(_formatAddress(selectedAddress) ?? 'Select an address')
                : Text('You have no saved addresses. Click here to add one.')),
            subtitle: Text(_formatNamePhone(selectedAddress) ?? ''), // I changed this bc dany didn't like it
          ),
        );
      },
    );
  }
}
