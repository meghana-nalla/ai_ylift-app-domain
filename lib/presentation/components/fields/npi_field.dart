import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NPIField extends StatelessWidget {
  final TextEditingController controller;

  const NPIField({
    super.key,
    required this.controller,
  });

  String? validateNPI(String? value) {
    if (value != null && value.isNotEmpty && value.length != 10) {
      return 'Enter a valid 10-digit NPI number';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: 'National Provider Identifier (NPI) #',
        helperText: 'Optional. NPI is required to purchase peptides products.',
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10),
      ],
      validator: validateNPI,
    );
  }
}
