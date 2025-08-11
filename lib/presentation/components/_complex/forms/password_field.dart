import 'package:flutter/material.dart';

class YLiftPasswordField extends StatefulWidget {
  final TextEditingController? controller;
  final String labelText;
  final String? errorText;
  final FormFieldValidator? validator;
  final bool showRequirements;
  final void Function(String password)? onFieldSubmitted;
  final bool withValidator;

  const YLiftPasswordField({
    super.key,
    this.controller,
    this.labelText = 'Password',
    this.errorText,
    this.validator,
    this.onFieldSubmitted,
    this.showRequirements = false,
    this.withValidator = true,
  });

  @override
  State<YLiftPasswordField> createState() => _YLiftPasswordFieldState();
}

class _YLiftPasswordFieldState extends State<YLiftPasswordField> {
  final focusNode = FocusNode();
  OverlayEntry? _overlayEntry;
  bool _obscureText = true;

  bool has8Characters = false;
  bool hasCapitalLetter = false;
  bool hasNumber = false;
  bool hasSpecialCharacter = false;

  void passwordListener() {
    final password = widget.controller?.text;
    if (password == null) return;

    has8Characters = password.length >= 8;
    hasCapitalLetter = password.contains(RegExp(r'[A-Z]'));
    hasNumber = password.contains(RegExp(r'[0-9]'));
    hasSpecialCharacter = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    setState(() {});
    // Rebuild the overlay
    if (focusNode.hasFocus) {
      _hidePasswordPopup(); // Remove existing overlay
      _showPasswordPopup(); // Reinsert updated overlay
    }
  }

  void _handleFocusChange() {
    if (focusNode.hasFocus) {
      _showPasswordPopup();
    } else {
      _hidePasswordPopup();
    }
  }

  void _hidePasswordPopup() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void initState() {
    super.initState();
    focusNode.addListener(_handleFocusChange);

    if (widget.controller != null && widget.withValidator) widget.controller!.addListener(passwordListener);
  }

  @override
  void dispose() {
    focusNode.dispose();
    _hidePasswordPopup();
    widget.controller?.removeListener(passwordListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: focusNode,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      obscureText: _obscureText,
      onChanged: (value) {
        setState(() {});
      },
      validator: widget.validator ?? (widget.withValidator ? _validatePassword : null),
      controller: widget.controller,
      decoration: InputDecoration(
        labelText: widget.labelText,
        errorText: widget.errorText,
        helperText: '',
        suffixIcon: ExcludeFocus(
          child: IconButton(
            icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
            onPressed: () => setState(() => _obscureText = !_obscureText),
          ),
        ),
      ),
      onFieldSubmitted: widget.onFieldSubmitted,
    );
  }

  String? _validatePassword(String? value) {
    bool isValid = true;
    String msg = "";

    if (value == null || value.length < 8) {
      isValid = false;
      msg = 'Password must be at least 8 characters long';
    } else if (!value.contains(RegExp(r'[A-Z]'))) {
      isValid = false;
      msg = 'Password is missing a capital letter';
    } else if (!value.contains(RegExp(r'[0-9]'))) {
      isValid = false;
      msg = 'Password is missing a number';
    } else if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      isValid = false;
      msg = 'Password must contain a special character';
    }

    return (isValid) ? null : msg;
  }

  void _showPasswordPopup() {
    if (!widget.showRequirements) return;
    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox?;
    final position = renderBox?.localToGlobal(Offset(-280, -160)) ?? Offset.zero;

    final password = widget.controller?.text ?? '';

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: position.dx + 20, // Adjust position as needed
        top: position.dy + 150, // Position below the text field
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: 250,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 5,
                )
              ],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Password Requirements', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                _requirementItem("At least 8 characters", has8Characters),
                _requirementItem("At least 1 number", hasNumber),
                _requirementItem("At least 1 uppercase letters", hasCapitalLetter),
                _requirementItem("At least 1 special character", hasSpecialCharacter),
              ],
            ),
          ),
        ),
      ),
    );
    overlay?.insert(_overlayEntry!);
  }

  Widget _requirementItem(String text, bool isMet) {
    return Row(
      children: [
        Icon(
          isMet ? Icons.check_circle : Icons.circle,
          color: isMet ? Colors.green : Colors.grey,
          size: 16,
        ),
        SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(fontSize: 14, color: Colors.black87),
        ),
      ],
    );
  }
}
