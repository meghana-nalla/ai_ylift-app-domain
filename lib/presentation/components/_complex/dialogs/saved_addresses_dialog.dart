
import 'package:YLift/core/controllers/global.dart';
import 'package:YLift/models/z-index_export.dart';
import 'package:YLift/presentation/components/z-index_export.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:galaxy_ui/galaxy_ui.dart';
import 'package:galaxy_models/galaxy_models.dart';
class SavedAddressesDialog extends StatefulWidget {
  final void Function() update;
  final AddressSimple? address;
  final void Function(AddressSimple address) onSelectedAddress;
  final bool isFromProfile;

  const SavedAddressesDialog({
    super.key,
    required this.update,
    required this.onSelectedAddress,
    this.isFromProfile = false,
    this.address,
  });

  @override
  State<SavedAddressesDialog> createState() => _SavedAddressesDialogState();
}

class _SavedAddressesDialogState extends State<SavedAddressesDialog> {
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

  void selectAddress() {
    widget.onSelectedAddress(selectedAddress!);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    Widget content;
    if (isLoading) {
      content = const CircularProgressIndicator();
    } else if (addresses!.isEmpty) {
      content = const Text('No saved addresses');
    } else {
      content = SizedBox(
        height: 256,
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
                  setState(() {
                    selectedAddress = address;
                    widget.onSelectedAddress(selectedAddress!);
                  });
                }
                    : null,
                title: Text(address.display,
                    style: TextStyle(
                        color: address.isValid ? Colors.black : Colors.black26)),
                subtitle: Text(address.isValid
                    ? address.name
                    : 'Invalid address, please edit',
                    style: const TextStyle(
                        color: Colors.black38, fontSize: 13.33)),

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
        width: 640,
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
                    style: TextStyle(fontSize: 24),
                  ),
                  if (addresses != null && addresses!.isNotEmpty) Text(' (${addresses!.length})'),
                  const Spacer(),
                  CloseIconButton(),
                ],
              ),
              const SizedBox(height: 16),
              Text('Selected address', style: TextStyle(fontWeight: FontWeight.bold)),
              if (selectedAddress == null)
                const Text('No address selected')
              else
                ListTile(
                  title: Text(selectedAddress!.display),
                  subtitle: Text(selectedAddress!.name, style: const TextStyle(color: Colors.black38, fontSize: 13.33)),
                ),
              const Divider(height: 32),
              Text('Scroll for more addresses', style: TextStyle(fontSize: 11.11)),
              content,
              const SizedBox(height: 32),
              OverflowBar(
                alignment: MainAxisAlignment.end,
                spacing: 16,
                overflowSpacing: 8,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Close'),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AddAddressDialog(
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
                    child: const Text('Add new address'),
                  ),
                  RoundedFilledButton(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                    onPressed: selectAddress,
                    child: const Text('Select address'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
