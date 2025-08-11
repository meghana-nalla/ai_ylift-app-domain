import 'package:YLift/core/controllers/global.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserAddressField extends StatefulWidget {
  const UserAddressField({super.key});

  @override
  State<UserAddressField> createState() => _UserAddressFieldState();
}

class _UserAddressFieldState extends State<UserAddressField> {
  final global = Get.find<GlobalController>();

  @override
  Widget build(BuildContext context) {
    return DropdownMenu(
      requestFocusOnTap: false,
      enableSearch: false,
      inputDecorationTheme: InputDecorationTheme(isDense: true),
      textStyle: TextStyle(fontSize: 11.11),
      dropdownMenuEntries:
          global.addressBook.validAddresses
              .map(
                (element) =>
                    DropdownMenuEntry(value: element, label: element.display),
              )
              .toList(),
    );
  }
}
