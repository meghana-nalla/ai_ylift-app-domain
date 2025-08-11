import 'package:YLift/core/controllers/global.dart';
import 'package:YLift/presentation/components/mobile_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:galaxy_models/galaxy_models.dart';
import 'package:galaxy_ui/galaxy_ui.dart';
import 'package:get/get.dart';

class MobileAddressFormPage extends StatefulWidget {
  final AddressSimple? address;
  const MobileAddressFormPage({
    super.key,
    this.address,
  });

  @override
  State<MobileAddressFormPage> createState() => _MobileAddressFormPageState();
}

class _MobileAddressFormPageState extends State<MobileAddressFormPage> {
  final global = Get.find<GlobalController>();
  final addressController = AddressController();
  final formKey = GlobalKey<FormState>();

  AddressSimpleType addressType = AddressSimpleType.SHIPPING;

  String? stateErrorMessage;

  bool isLoading = false;
  bool get isEditing => widget.address != null;

  bool validateForm() {
    setState(() {
      stateErrorMessage = null;
    });
    bool isValid = true;

    final state = USState.values.firstWhereOrNull(
      (state) => state.label == addressController.stateController.text,
    );
    if (state == null) {
      setState(() {
        isValid = false;
        stateErrorMessage = 'Enter your state';
      });
    }

    return formKey.currentState!.validate() && isValid;
  }

  void addAddress() async {
    try {
      setState(() {
        isLoading = true;
      });
      final isFormValid = validateForm();
      if (!isFormValid) return;

      final state = USState.values.firstWhere(
        (e) => e.label == addressController.stateController.text,
      );

      final profileId = global.user.value.profileId;
      final address = AddressSimple(
        profileId: '$profileId',
        name:
            '${addressController.firstNameController.text} ${addressController.lastNameController.text}',
        line1: addressController.streetAddressController.text,
        line2: addressController.suiteController.text,
        city: addressController.cityController.text,
        state: state.code,
        zip: addressController.zipController.text,
        country: 'United States',
        type: addressType,
        phone: '',
        createdAt: DateTime.now(),
        isValid: widget.address?.isValid ?? false,
        isDefault: widget.address?.isDefault,
        addressId: widget.address?.addressId ?? '',
        id: widget.address?.id ?? '',
      );
      if (isEditing) {
        await global.addressBook.updateAddress(address, widget.address!);
      } else {
        await global.userController.addAddress(address);
      }
      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error adding address: $e'),
        ),
      );
      return;
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    if (widget.address != null) {
      final address = widget.address!;
      final names = address.name.split(' ');
      final state = USState.values.firstWhereOrNull(
        (s) =>
            s.name.toLowerCase() == address.state.toLowerCase() ||
            s.code == address.state.toUpperCase(),
      );
      addressController.firstNameController.text = names.firstOrNull ?? '';
      addressController.lastNameController.text = names.lastOrNull ?? '';
      addressController.streetAddressController.text = address.line1 ?? '';
      addressController.suiteController.text = address.line2 ?? '';
      addressController.cityController.text = address.city;
      addressController.stateController.text = state?.label ?? address.state;
      addressController.zipController.text = address.zip;
    }
    super.initState();
  }

  @override
  void dispose() {
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MobileScaffold(
      title: isEditing ? 'Edit Address' : 'Add New Address',
      onBackPressed: () => Navigator.pop(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(
              key: formKey,
              child: Column(
                spacing: 8,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: addressController.firstNameController,
                          decoration: const InputDecoration(
                            labelText: 'First Name',
                            helperText: '',
                          ),
                          validator: (value) {
                            if (value?.isEmpty ?? false) {
                              return 'Enter your first name';
                            }
                            return null;
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp("[a-zA-Z ]"),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: addressController.lastNameController,
                          decoration: const InputDecoration(
                            labelText: 'Last Name',
                            helperText: '',
                          ),
                          validator: (value) {
                            if (value?.isEmpty ?? false) {
                              return 'Enter your last name';
                            }
                            return null;
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp("[a-zA-Z ]"),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  TextFormField(
                    controller: addressController.streetAddressController,
                    decoration: const InputDecoration(
                      labelText: 'Address Line 1',
                      helperText: '',
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? false) {
                        return 'Enter a valid address';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: addressController.suiteController,
                    decoration: const InputDecoration(
                      labelText: 'Address Line 2 (optional)',
                      helperText: '',
                    ),
                  ),
                  DropdownMenu(
                    controller: addressController.stateController,
                    menuHeight: 320,
                    expandedInsets: EdgeInsets.zero,
                    label: const Text('State'),
                    dropdownMenuEntries:
                        USState.values.map(
                          (e) {
                            return DropdownMenuEntry(
                              value: e,
                              label: e.label,
                            );
                          },
                        ).toList(),
                    helperText: '',
                    errorText: stateErrorMessage,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: addressController.cityController,
                          decoration: const InputDecoration(
                            labelText: 'City',
                            helperText: '',
                          ),
                          validator: (value) {
                            if (value?.isEmpty ?? false) {
                              return 'Enter your city';
                            }
                            return null;
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp("[a-zA-Z ]"),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: addressController.zipController,
                          decoration: const InputDecoration(
                            labelText: 'Zip Code',
                            helperText: '',
                            counterText: '',
                          ),
                          maxLength: 5,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          keyboardType: TextInputType.number,
                          validator: validateZip,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Address Type',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 4),
            Row(
              spacing: 16,
              children:
                  AddressSimpleType.values.reversed.map((e) {
                    final isSelected = addressType == e;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          addressType = e;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(4),
                          ),
                          color: isSelected ? YLiftColor.orange : null,
                          border: Border.all(
                            color: YLiftColor.orange,
                            width: 1,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Text(
                          e.name,
                          style: TextStyle(
                            fontSize: 12,
                            color:
                                isSelected ? Colors.white : YLiftColor.orange,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ],
        ),
      ),
      bottomBar: MobileBar(
        padding: const EdgeInsets.all(16),
        child: GalaxyFilledButton(
          backgroundColor: YLiftColor.orange,
          isExpanded: true,
          onPressed: isLoading ? null : addAddress,
          // onPressed: null,
          child:
              isEditing
                  ? const Text('Update Address')
                  : const Text('Add Address'),
        ),
      ),
    );
  }

  String? validateZip(String? value) {
    if (value == null || value.isEmpty) return 'Enter your zip code';
    if (value.length != 5) return 'Zip code must be 5 digits';
    return null;
  }
}
