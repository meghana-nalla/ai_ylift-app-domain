import 'package:YLift/models/z-index_export.dart';
import 'package:YLift/presentation/components/z-index_export.dart';

import 'package:YLift/presentation/components/_complex/tiles/payment_method_tile.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:galaxy_ui/galaxy_ui.dart';
import 'package:YLift/core/controllers/global.dart';
import 'package:galaxy_models/galaxy_models.dart';
class AddressTileData {
  final AddressSimple addressSimple;
  final String fullName;
  final String companyName;
  final String line1;
  final String? line2;
  final String city;
  final String state;
  final String zipCode;
  final String? phoneNumber;
  final String? email;
  final AddressSimpleType? type;

  final bool isDefault;

  const AddressTileData({
    required this.addressSimple,
    required this.fullName,
    required this.companyName,
    required this.line1,
    this.line2,
    required this.city,
    required this.state,
    required this.zipCode,
    this.phoneNumber,
    this.email,
    this.isDefault = false,
    this.type,
  });
}

class AddressBookPanel extends StatefulWidget {
  const AddressBookPanel({super.key});

  @override
  State<AddressBookPanel> createState() => _AddressBookPanelState();
}

class _AddressBookPanelState extends State<AddressBookPanel> {
  final controller = Get.find<GlobalController>();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    await controller.addressBook.loadAddresses();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.addressBook.isLoading.value) {
        return const LinearProgressIndicator();
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FilledButton.icon(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AddAddressDialog(
                  // controller: widget.controller,
                  isFromProfile: true,
                  onAdd: (address) async {
                    await controller.addressBook.addAddress(address);
                  },
                  // onAddressCreated: onAddressCreated,
                ),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('Add Address'),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: controller.addressBook.addresses
                .map(
                  (userAddress) => AddressTile(
                    address: AddressTileData(
                      addressSimple: userAddress,
                      fullName: userAddress.name,
                      companyName: 'Company Needs Implementation',
                      // TODO add company name to AddressSimple model
                      line1: userAddress.line1 ?? '',
                      line2: userAddress.line2 ?? '',
                      city: userAddress.city,
                      state: userAddress.state,
                      zipCode: userAddress.zip,
                      phoneNumber: userAddress.phone,
                      // email: 'Email needs implementation',
                      // TODO add email to AddressSimple model
                      isDefault: userAddress.isDefault ?? false,
                      // TODO add isDefault logic
                      type: userAddress.type,
                    ),
                    onEdit: () {
                      showDialog(
                        context: context,
                        builder: (context) => EditAddressDialog(
                          address: userAddress,
                          onEdit: (AddressSimple newAddress) async {
                            await controller.addressBook
                                .updateAddress(newAddress, userAddress);
                          },
                        ),
                      );
                    },
                    onRemove: () async {
                      try {
                        await controller.addressBook.deleteAddress(userAddress);
                        await init();
                      } catch (e) {

                      }
                    },
                  ),
                )
                .toList(),
          ),
        ],
      );
    });
  }
}

class AddressTile extends StatefulWidget {
  final AddressTileData address;
  final void Function()? onSetAsDefault;
  final void Function()? onEdit;
  final void Function()? onRemove;

  const AddressTile({
    super.key,
    required this.address,
    this.onSetAsDefault,
    this.onEdit,
    this.onRemove,
  });

  static const greyStyle = TextStyle(fontSize: 14, color: Color(0xFF999999));

  @override
  State<AddressTile> createState() => _AddressTileState();
}

class _AddressTileState extends State<AddressTile> {
  bool _isChecked = false;

  @override
  void initState() {
    super.initState();
    _isChecked = widget.address.addressSimple.isDefault ?? false;
  }

  Future<void> _updateDefault(bool isChecked) async {
    // update UI state
    setState(() {
      _isChecked = !isChecked;
    });

    // update backend state
    // await global.userProfile.setUserDefaultAddress(widget.address.addressSimple.id);
  }

  @override
  Widget build(BuildContext context) {
    //final textTheme = Theme.of(context).textTheme;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 4,
          ),
        ],
      ),
      width: 320,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.address.fullName,
                style: GoogleFonts.poppins(
                    fontSize: 16, fontWeight: FontWeight.w500),
              ),
              if (widget.address.isDefault) const DefaultIcon(),
            ],
          ),
          const SizedBox(height: 16),
          Text(widget.address.line1, style: AddressTile.greyStyle),
          Text(
              '${widget.address.city}, ${widget.address.state}, ${widget.address
                  .zipCode}',
              style: AddressTile.greyStyle),
          const SizedBox(height: 16),
          if (widget.address.phoneNumber != null)
            Text(widget.address.phoneNumber!, style: AddressTile.greyStyle),
          if (widget.address.email != null) Text(
              widget.address.email!, style: AddressTile.greyStyle),
          const SizedBox(height: 32),
          IntrinsicHeight(
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Type',
                        style: TextStyle(
                          fontSize: 11.11
                        ),
                      ),
                      Text(
                        widget.address.type!.name,
                        style: GoogleFonts.poppins(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ]
                ),
                //This is commented while waiting to be implemented in the backend
                //Danny Orders on 02/06
                // Checkbox(
                //   value: _isChecked,
                //   onChanged: (isChecked) async {
                //     await _updateDefault(_isChecked);
                //   },
                // ),
                // const SizedBox(width: 4),
                // const Text(
                //   'Default',
                //   style: AddressTile.greyStyle,
                // ),
                // Text('Address Type: ${address.type?.label ?? '(Not set)'}', style: textTheme.bodySmall),
                const Spacer(),
                YLiftTextButton(
                  onPressed: widget.onEdit,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: const Text('Edit', style: AddressTile.greyStyle),
                ),
                const VerticalDivider(),
                YLiftTextButton(
                  onPressed: widget.onRemove,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: const Text('Remove', style: AddressTile.greyStyle),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
