import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

class EmailField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String? errorText;
  final bool withClearButton;
  final void Function(String email)? onFieldSubmitted;
  final bool isOptional;

  const EmailField({
    super.key,
    required this.controller,
    this.labelText = 'Email',
    this.errorText,
    this.onFieldSubmitted,
    this.withClearButton = true,
    this.isOptional = false,
  });

  @override
  State<EmailField> createState() => _EmailFieldState();
}

class _EmailFieldState extends State<EmailField> {
  bool showClearButton = false;

  void _listener() {
    setState(() {
      showClearButton = widget.controller.text.isNotEmpty;
    });
  }

  String? emailValidator(String? value) {
    if (widget.isOptional && (value == null || value.isEmpty)) return null;
    final isEmailInvalid = value == null || !EmailValidator.validate(value);
    if (isEmailInvalid) return 'Enter a valid email address';
    return null;
  }

  @override
  void initState() {
    widget.controller.addListener(_listener);
    super.initState();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        labelText: widget.labelText,
        errorText: widget.errorText,
        helperText: '',
        suffixIcon: _buildClearButton(),
      ),
      validator: emailValidator,
      onFieldSubmitted: widget.onFieldSubmitted,
    );
  }

  Widget? _buildClearButton() {
    if (!showClearButton || !widget.withClearButton) return null;
    return ExcludeFocus(
      child: IconButton(
        onPressed: widget.controller.clear,
        icon: const Icon(Icons.clear),
      ),
    );
  }
}
