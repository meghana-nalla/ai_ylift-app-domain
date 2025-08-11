
import 'package:YLift/core/controllers/global.dart';
import 'package:YLift/models/z-index_export.dart';
import 'package:YLift/presentation/components/_complex/dialogs/add_address_dialog_mobile.dart';
import 'package:YLift/presentation/components/z-index_export.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:galaxy_ui/galaxy_ui.dart';
import 'package:galaxy_models/galaxy_models.dart';
class SavedAddressesDialogMobile extends StatefulWidget {
  final void Function() update;
  final AddressSimple? address;
  final void Function(AddressSimple address) onSelectedAddress;
  final bool isFromProfile;

  const SavedAddressesDialogMobile({
    super.key,
    required this.update,
    required this.onSelectedAddress,
    this.isFromProfile = false,
    this.address,
  });

  @override
  State<SavedAddressesDialogMobile> createState() => _SavedAddressesDialogState();
}

class _SavedAddressesDialogState extends State<SavedAddressesDialogMobile> {
  final GlobalController controller = Get.find<GlobalController>();
  List<AddressSimple>? addresses;
  bool get isLoading => addresses == null;

  void loadAddresses() async {
    List<AddressSimple> userAddresses = await controller.userController.getShippingAddressesByProfileId();
    print('userAddresses: ${userAddresses.length}');
    setState(() {
      addresses = userAddresses;
    });
    print('address has been updated');
  }

  AddressSimple? selectedAddress;

  @override
  void initState() {
    super.initState();
    selectedAddress = widget.address ?? global.simpleCart.value.shippingAddress;
    loadAddresses();
  }

  // final void Function(Address address) onAddressCreated;
  void selectAddress() {
    if (!_validateAddress(selectedAddress)) return;
    // widget.update();
    widget.onSelectedAddress(selectedAddress!);
    Navigator.pop(context);
  }

  bool _validateAddress(AddressSimple? address) {
    String msg = 'Error with address: ';

    if (address == null) {
      msg += 'address cannot be null';
      print(msg);
      return false;
    }
    if (address.line1 == null) {
      msg += 'address line 1 cannot be null';
      print(msg);
      return false;
    }
    if (address.line1!.length < 3) {
      msg += 'address line 1 must be at least 3 characters';
      print(msg);
      return false;
    }
    if (address.line1 == 'NULL') {
      msg += 'address is invalid';
      print(msg);
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    Widget content;
    if (isLoading) {
      content = const CircularProgressIndicator();
    } else if (addresses!.isEmpty) {
      content = Text('No saved addresses',
          style: TextStyle(fontSize: 13));
    } else {
      content = SizedBox(
        height: 256, // MediaQuery.of(context).size.height * 0.85,
        child: Material(
          color: Colors.white,
          child: ListView.builder(
            itemCount: addresses!.length,
            itemBuilder: (context, index) {
              final address = addresses![index];
              final isSelected = address.addressId ==
                  selectedAddress?.addressId;
              return ListTile(
                tileColor: isSelected ? YLiftColor.beige : null,
                onTap: address.isValid
                    ? () {
                  if (_validateAddress(address)) {
                    setState(() {
                      selectedAddress = address;
                      widget.onSelectedAddress(selectedAddress!);
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            'Error: selected address is invalid. Please select a different address')));
                  }
                }
                    : null,
                title: Text(address.display,
                    style: _validateAddress(address)
                        ? TextStyle(
                        color: address.isValid ? Colors.black : Colors.black26,
                        fontWeight: FontWeight.bold,
                        fontSize: 13)
                        : TextStyle(
                      color: address.isValid ? Colors.black38 : Colors
                          .black26,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    )),
                subtitle: Text(address.isValid
                    ? address.name
                    : 'Invalid address, please edit',
                    style: const TextStyle(
                        color: Colors.black38, fontSize: 13)),
                trailing: !address.isValid
                    ? IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return EditAddressDialog(
                          address: address,
                          onEdit: (editedAddress) async {
                            await controller.addressBook.updateAddress(
                                editedAddress, address);
                            loadAddresses();
                          },
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.edit),
                )
                    : isSelected
                    ? Icon(
                  Icons.check_circle,
                  color: Colors.green,
                )
                    : null,

              );
            },
          ),
        ),
      );
    }
    return Dialog(
      child: SizedBox(
        width: MediaQuery
            .of(context)
            .size
            .width * 0.9,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Saved addresses',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  if (addresses != null && addresses!.isNotEmpty) Text(
                      ' (${addresses!.length})',
                      style: TextStyle(
                          fontSize: 13, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  CloseIconButton(),
                ],
              ),
              const SizedBox(height: 8),
              Text('Selected address', style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold)),
              if (selectedAddress == null)
                Text('No address selected',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold
                    )
                )
              else
                ListTile(
                  title: Text(selectedAddress!.display,
                      style: TextStyle(fontSize: 13,
                          fontWeight: FontWeight.bold
                      )),
                  subtitle: Text(selectedAddress!.name,
                      style: TextStyle(color: Colors.black38, fontSize: 13)),
                ),
              const Divider(height: 16),
              Text('Scroll for more addresses',
                  style: TextStyle(fontSize: 11.11)),
              content,
              SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) =>
                          AddAddressDialogMobile(
                            onAdd: (address) async {
                              await controller.addressBook.addAddress(address);
                              setState(() {
                                selectedAddress = address;
                              });
                              loadAddresses();
                            },
                          ),
                    );
                  },
                  child: const Text(
                      'Add new address', style: TextStyle(fontSize: 13)),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              SizedBox(
                width: double.infinity,
                child:
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.black,
                  ),
                  // padding: const EdgeInsets.symmetric(
                  //     vertical: 20, horizontal: 24),
                  onPressed: selectAddress,
                  child: const Text(
                      'Select address', style: TextStyle(
                      color: Colors.white,
                      fontSize: 13)),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: YLiftColor.orange,
                  ),
                  // padding: const EdgeInsets.symmetric(
                  //     vertical: 20, horizontal: 24),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Close', style: TextStyle(fontSize: 13)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
