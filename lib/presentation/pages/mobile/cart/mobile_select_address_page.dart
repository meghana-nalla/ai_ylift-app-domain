import 'package:YLift/core/controllers/global.dart';
import 'package:YLift/presentation/components/mobile_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:galaxy_models/galaxy_models.dart';
import 'package:get/get.dart';

class MobileSelectAddressPage extends StatefulWidget {
  const MobileSelectAddressPage({
    super.key,
  });

  @override
  State<MobileSelectAddressPage> createState() =>
      _MobileSelectAddressPageState();
}

class _MobileSelectAddressPageState extends State<MobileSelectAddressPage> {
  final global = Get.find<GlobalController>();

  final addresses = <AddressSimple>[];
  AddressSimple? selectedAddress;

  String? errorMessage;

  void addNewAddress() async {
    // TODO: Implement the logic to add a new address
  }

  bool isLoadingAddresses = false;
  bool isSelectingAddress = false;

  void fetchAddresses() async {
    try {
      setState(() {
        isLoadingAddresses = true;
      });
      await global.addressBook.loadAddresses();
      setState(() {
        addresses.addAll(global.addressBook.addresses);
        selectedAddress = global.simpleCart.value.shippingAddress;
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

  void selectAddress(AddressSimple address) async {
    final previousSelected = selectedAddress;
    setState(() {
      selectedAddress = address;
      isSelectingAddress = true;
    });
    try {
      final profileId = '${global.user.value.profileId}';

      await global.basket.setCartAddress(
        profileId: profileId,
        addressId: address.addressId,
      );
      setState(() {
        selectedAddress = global.simpleCart.value.shippingAddress;
      });

      if (!mounted) return;
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to select address, please try again later.';
        selectedAddress = previousSelected;
      });
    } finally {
      setState(() {
        isSelectingAddress = false;
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
      title: 'Select an address',
      onBackPressed: () => Navigator.pop(context),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Padding(
          //   padding: const EdgeInsets.only(left: 16),
          //   child: LineTextButton(
          //     onPressed: addNewCard,
          //     text: 'Add a new address',
          //     icon: const Icon(Icons.add),
          //   ),
          // ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: addresses.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final address = addresses[index];
                final isSelected =
                    selectedAddress?.addressId == address.addressId;

                return _AddressTile(
                  address: address,
                  isSelected: isSelected,
                  onSelected: () => selectAddress(address),
                );
              },
            ),
          ),
        ],
      ),
      bottomBar: MobileBar(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  errorMessage!,
                  style: TextStyle(color: Colors.red, fontSize: 14),
                ),
              ),
            FilledButton(
              style: FilledButton.styleFrom(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                backgroundColor: YLiftColor.orange,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 48),
              ),
              // onPressed: selectCard,
              onPressed:
                  isSelectingAddress
                      ? null
                      : () {
                        Navigator.pop(context);
                      },
              child: const Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddressTile extends StatelessWidget {
  final AddressSimple address;
  final bool isSelected;
  final void Function() onSelected;

  const _AddressTile({
    super.key,
    required this.address,
    required this.onSelected,
    this.isSelected = false,
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
            if (isSelected)
              const Icon(
                Icons.radio_button_checked,
                size: 16,
                color: YLiftColor.orange,
              )
            else
              const Icon(
                Icons.radio_button_unchecked,
                size: 16,
                color: Colors.grey,
              ),
            const SizedBox(width: 12),
            Column(
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}
