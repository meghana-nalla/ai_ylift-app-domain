


import 'package:YLift/models/z-index_export.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:galaxy_models/galaxy_models.dart';
import 'package:YLift/core/constants/index.dart';
import 'package:YLift/core/controllers/global.dart';
import 'package:YLift/presentation/components/z-index_export.dart';

class ProfileSettings extends StatefulWidget {
  @override
  _ProfileSettingsState createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  final GlobalController controller = Get.find<GlobalController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 16.0),
        RotatingProfilePicture(
          frontImageUrl: PLACEHOLDER_IMAGE,
          // frontImageUrl: controller
          //     .credentials.value.user.pictureUrl
          //     .toString()
          //     .replaceFirst('secure.gravatar.com', 'ylift.app'),
          backImageUrl: 'https://ylift.app/api/v2/mars/file/public/media/logo_white_circle.png',
          size: 160.0,
          rotationDuration: Duration(milliseconds: 100),
          stayDuration: Duration(seconds: 7),
        ),
        SizedBox(height: 32.0),
        Text('Welcome, ${controller.profile!.value.info?.name}'),
        SizedBox(height: 16.0),
        ElevatedButton(
          // onPressed: () => controller.auth0
          //     .logout(returnToUrl: CURRENT_REDIRECT_URI),

          // TODO: Change to new logout
            onPressed: (){},
            child: const Text("Log out")),
        SizedBox(height: 16.0),
        ProfileContactInfo(profile: controller.profile.value.info!),
        Divider(),
        ProfileEmail(profile: controller.profile.value.info!),
        Divider(),
        ProfileAdditionalEmails(),
        Divider(),
        ProfileTimezone(profile: controller.profile.value.info!),
        Divider(),
        PromotionEmails(profile: controller.profile.value.info!),
        Divider(),
        ShippingAddresses(
          addresses: controller.profile.value.addresses!,
          onAddAddress: addAddress,
          onEditAddress: editAddress,
          onDeleteAddress: deleteAddress,
        ),
      ],
    );
  }

  void addAddress(AddressSimple newAddress) {
    setState(() {
      controller.profile.value.addresses!.add(newAddress);
    });
  }

  void editAddress(String id, AddressSimple updatedAddress) {
    setState(() {
      final addressIndex = controller.profile.value.addresses!.indexWhere((address) => address.id == id);
      controller.profile.value.addresses![addressIndex] = updatedAddress;
    });
  }

  void deleteAddress(String id) {
    setState(() {
      controller.profile.value.addresses!.removeWhere((address) => address.id == id);
    });
  }
}

class ProfileContactInfo extends StatelessWidget {
  final AuthProfileUser profile;

  ProfileContactInfo({required this.profile});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text('Contact Information'),
      subtitle: Text('Basic contact information'),
      children: [
        ListTile(
          title: Text('Name'),
          subtitle: Text(profile.name ?? 'Set your name'),
        ),
        ListTile(
          title: Text('Phone'),
          subtitle: Text(profile.phone ?? 'Set your phone number'),
        ),
      ],
    );
  }
}

class ProfileEmail extends StatelessWidget {
  final AuthProfileUser profile;

  ProfileEmail({required this.profile});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text('Email'),
      subtitle: Text('Contact email is ${profile.email}'),
      children: [
        Padding(
          padding: EdgeInsets.all(16.0),
          child: TextField(
            decoration: InputDecoration(
              labelText: 'New Email',
              helperText: 'An email will be sent to ${profile.email} to confirm the change.',
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            // Update email logic
          },
          child: Text('Update Email'),
        ),
      ],
    );
  }
}

class ProfileAdditionalEmails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text('Additional Emails'),
      subtitle: Text('This profile has 2 linked email addresses.'),
      children: [
        ListTile(title: Text('john.work@example.com')),
        ListTile(title: Text('john.personal@example.com')),
        Padding(
          padding: EdgeInsets.all(16.0),
          child: TextField(
            decoration: InputDecoration(
              labelText: 'Add email',
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            // Add email logic
          },
          child: Text('Submit'),
        ),
      ],
    );
  }
}

class ProfileTimezone extends StatelessWidget {
  final AuthProfileUser profile;

  ProfileTimezone({required this.profile});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text('Timezone'),
      subtitle: Text('Current timezone: ${profile.timezone}'),
      children: [
        Padding(
          padding: EdgeInsets.all(16.0),
          child: DropdownButtonFormField<String>(
            decoration: InputDecoration(labelText: 'New Timezone'),
            items: ['America/New_York', 'Europe/London', 'Asia/Tokyo']
                .map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              // Update timezone logic
            },
          ),
        ),
        ElevatedButton(
          onPressed: () {
            // Update timezone logic
          },
          child: Text('Update Timezone'),
        ),
      ],
    );
  }
}

class PromotionEmails extends StatelessWidget {
  final AuthProfileUser profile;

  PromotionEmails({required this.profile});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text('Promotions Emails'),
      subtitle: Text('Change settings for Y Lift promotions.'),
      children: [
        SwitchListTile(
          title: Text('Opt in/out of future Y Lift promotional emails.'),
          value: profile.notifyOnNewOrder!,
          onChanged: (bool value) {
            // TODO: Update promotion email preferences logic
          },
        ),
        ElevatedButton(
          onPressed: () {
            // TODO: Update preferences logic
          },
          child: Text('Update Preferences'),
        ),
      ],
    );
  }
}

class ShippingAddresses extends StatefulWidget {
  final List<AddressSimple> addresses;
  final Function(AddressSimple) onAddAddress;
  final Function(String, AddressSimple) onEditAddress;
  final Function(String) onDeleteAddress;

  ShippingAddresses({
    required this.addresses,
    required this.onAddAddress,
    required this.onEditAddress,
    required this.onDeleteAddress,
  });

  @override
  _ShippingAddressesState createState() => _ShippingAddressesState();
}

class _ShippingAddressesState extends State<ShippingAddresses> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _isExpanded = !isExpanded;
        });
      },
      children: [
        ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: Text('Shipping Addresses'),
              subtitle: Text(
                  'You have ${widget.addresses.length} saved address${widget.addresses.length != 1 ? 'es' : ''}.'),
            );
          },
          body: Column(
            children: [
              ...widget.addresses.map((address) => AddressCard(
                address: address,
                onEdit: () => _editAddress(address),
                onDelete: () => widget.onDeleteAddress(address.id.toString()),
              )),
              ElevatedButton(
                onPressed: _addNewAddress,
                child: Text('Add New Address'),
              ),
            ],
          ),
          isExpanded: _isExpanded,
        ),
      ],
    );
  }

  void _addNewAddress() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddressFormDialog(
          onSave: (newAddress) {
            widget.onAddAddress(newAddress);
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  void _editAddress(AddressSimple address) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddressFormDialog(
          address: address,
          onSave: (updatedAddress) {
            widget.onEditAddress(address.id.toString(), updatedAddress);
            Navigator.of(context).pop();
          },
        );
      },
    );
  }
}

class AddressCard extends StatelessWidget {
  final AddressSimple address;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  AddressCard({
    required this.address,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (address.allerganId != null)
              Text('McKesson ID: ${address.allerganId}'),
            Text(address.name),
            Text(address.line1!),
            if (address.line2 != null && address.line2!.isNotEmpty)
              Text(address.line2 ?? ''),
            Text('${address.city}, ${address.state} ${address.zip}'),
            if (address.phone != null) Text('Phone: ${address.phone}'),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: onEdit,
                  child: Text('Edit'),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: onDelete,
                  child: Text('Delete'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AddressFormDialog extends StatefulWidget {
  final AddressSimple? address;
  final Function(AddressSimple) onSave;

  AddressFormDialog({this.address, required this.onSave});

  @override
  _AddressFormDialogState createState() => _AddressFormDialogState();
}

class _AddressFormDialogState extends State<AddressFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late AddressSimple _address;

  @override
  void initState() {
    super.initState();
    _address =  widget.address!;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.address == null ? 'Add New Address' : 'Edit Address'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                initialValue: _address.name,
                decoration: InputDecoration(labelText: 'Name'),
                onSaved: (value) => _address.name = value ?? '',
                validator: (value) =>
                value?.isEmpty ?? true ? 'Name is required' : null,
              ),
              TextFormField(
                initialValue: _address.allerganId,
                decoration: InputDecoration(labelText: 'Allergan ID'),
                onSaved: (value) => _address.allerganId = value,
              ),
              TextFormField(
                initialValue: _address.line1,
                decoration: InputDecoration(labelText: 'Address'),
                onSaved: (value) => _address.line1 = value ?? '',
                validator: (value) =>
                value?.isEmpty ?? true ? 'Address is required' : null,
              ),
              TextFormField(
                initialValue: _address.line2,
                decoration: InputDecoration(labelText: 'Line 2'),
                onSaved: (value) => _address.line2 = value,
              ),
              TextFormField(
                initialValue: _address.city,
                decoration: InputDecoration(labelText: 'City'),
                onSaved: (value) => _address.city = value ?? '',
                validator: (value) =>
                value?.isEmpty ?? true ? 'City is required' : null,
              ),
              TextFormField(
                initialValue: _address.state,
                decoration: InputDecoration(labelText: 'State'),
                onSaved: (value) => _address.state = value ?? '',
                validator: (value) =>
                value?.isEmpty ?? true ? 'State is required' : null,
              ),
              TextFormField(
                initialValue: _address.zip,
                decoration: InputDecoration(labelText: 'Zip'),
                onSaved: (value) => _address.zip = value ?? '',
                validator: (value) =>
                value?.isEmpty ?? true ? 'Zip is required' : null,
              ),
              TextFormField(
                initialValue: _address.phone,
                decoration: InputDecoration(labelText: 'Phone'),
                onSaved: (value) => _address.phone = value!,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState?.validate() ?? false) {
              _formKey.currentState?.save();
              widget.onSave(_address);
            }
          },
          child: Text('Save'),
        ),
      ],
    );
  }
}