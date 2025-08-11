import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class YLiftTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String? errorText;
  final int? maxLength;
  final FormFieldValidator<String?>? validator;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final TextStyle? inputTextStyle;

  final Function(String?)? onChanged;

  const YLiftTextFormField({
    super.key,
    required this.controller,
    required this.labelText,
    this.errorText,
    this.maxLength,
    this.validator,
    this.keyboardType,
    this.inputFormatters,
    this.onChanged,
    this.inputTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLength: maxLength,
      validator: validator,
      keyboardType: keyboardType,
      onChanged: onChanged == null ? null : (value) {
        final text = controller.text;
        onChanged!(text);
      },
      decoration: InputDecoration(
        labelText: labelText,
        errorText: errorText,
        helperText: '',
        counterText: '',
      ),
      style: inputTextStyle,
      inputFormatters: inputFormatters,
    );
  }
}
