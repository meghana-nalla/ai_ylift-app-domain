import 'package:YLift/core/controllers/global.dart';
import 'package:YLift/presentation/components/buttons/line_text_button.dart';
import 'package:YLift/presentation/components/buttons/mobile_icon.dart';
import 'package:YLift/presentation/components/dialogs/remove_address_dialog.dart';
import 'package:YLift/presentation/components/mobile_scaffold.dart';
import 'package:YLift/presentation/pages/mobile/account/address_book/address_page.dart';
import 'package:flutter/material.dart';
import 'package:galaxy_models/galaxy_models.dart';
import 'package:get/get.dart';

class MobileAddressBookPage extends StatefulWidget {
  const MobileAddressBookPage({
    super.key,
  });

  @override
  State<MobileAddressBookPage> createState() => _MobileAddressBookPageState();
}

class _MobileAddressBookPageState extends State<MobileAddressBookPage> {
  final global = Get.find<GlobalController>();

  final addresses = <AddressSimple>[];

  String? errorMessage;

  void addNewAddress() async {
    final isAdded = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (context) => const MobileAddressFormPage()),
    );
    if (isAdded ?? false) fetchAddresses();
  }

  void editAddress(AddressSimple address) async {
    final isEdited = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => MobileAddressFormPage(address: address),
      ),
    );
    if (isEdited ?? false) fetchAddresses();
  }

  void removeAddress(AddressSimple address) async {
    final isRemoved = await showDialog<bool>(
      context: context,
      builder: (context) => RemoveAddressDialog(address: address),
    );
    if (isRemoved ?? false) fetchAddresses();
  }

  void setAsDefault(AddressSimple address) async {
    try {
      await global.userProfile.setUserDefaultAddress(address.addressId);
      fetchAddresses();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to set "${address.display}" as default address. Please try again later.',
            style: const TextStyle(fontSize: 14),
          ),
        ),
      );
    }
  }

  bool isLoadingAddresses = false;

  void fetchAddresses() async {
    try {
      setState(() {
        isLoadingAddresses = true;
      });
      await global.addressBook.loadAddresses();
      setState(() {
        addresses.clear();
        addresses.addAll(global.addressBook.addresses);
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load addresses: $e';
      });
    } finally {
      setState(() {
        isLoadingAddresses = false;
      });
    }
  }

  @override
  void initState() {
    fetchAddresses();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MobileScaffold(
      title: 'Address Book',
      onBackPressed: () => Navigator.pop(context),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LineTextButton(
                  onPressed: addNewAddress,
                  text: 'Add a new address',
                  icon: const Icon(Icons.add),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Tap on an address to set it as default',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: addresses.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final address = addresses[index];

                return _AddressTile(
                  address: address,
                  onSelected: () => setAsDefault(address),
                  onEdit: () => editAddress(address),
                  onRemove: () => removeAddress(address),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _AddressTile extends StatelessWidget {
  final AddressSimple address;
  final void Function() onSelected;
  final void Function() onEdit;
  final void Function()? onRemove;

  const _AddressTile({
    super.key,
    required this.address,
    required this.onEdit,
    required this.onSelected,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelected,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          color: Colors.white,
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    address.display,
                    style: const TextStyle(fontSize: 14),
                  ),
                  Text(
                    address.name,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  if (address.isDefault ?? false)
                    Text(
                      'Default',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  if (!address.isValid)
                    Text(
                      'Invalid address, please edit or remove',
                      style: TextStyle(fontSize: 12, color: Colors.red),
                    ),
                ],
              ),
            ),
            MobileIcon(
              onPressed: onEdit,
              icon: Icons.edit_outlined,
            ),
            if (onRemove != null)
              MobileIcon(
                onPressed: onRemove,
                icon: Icons.delete_outline_rounded,
                color: Colors.red,
              ),
          ],
        ),
      ),
    );
  }
}
