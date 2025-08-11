import 'package:YLift/core/constants/constant.dart';
import 'package:YLift/core/controllers/global.dart';

import 'package:YLift/presentation/components/z-index_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:galaxy_ui/galaxy_ui.dart';

class TwoFactorAuthentication extends StatefulWidget {
  const TwoFactorAuthentication({super.key});

  @override
  State<TwoFactorAuthentication> createState() => _TwoFactorAuthenticationState();
}

class _TwoFactorAuthenticationState extends State<TwoFactorAuthentication> {
  final formKey = GlobalKey<FormState>();
  final controller = Get.find<GlobalController>();
  static const int codeLength = 6;
  String? code;

  void verifyCode() async {
    if (code == null || code!.length != codeLength) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a complete verification code')),
      );
      return;
    }

    // Here you would typically verify the code with your backend
    controller.vroute.navigateTo('/new_password');
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: YLiftConstant.totalTopNavigation),
              SizedBox(height: screenHeight / 3),
              const Text(
                'Two-Factor Authentication',
                style: TextStyle(fontSize: 40),
              ),
              const Text(
                'A six digit code has been sent to your phone number ending with **7890',
              ),
              const GapY(factor: 2),
              CodeField(
                codeLength: codeLength,
                onSaved: (value) {
                  setState(() {
                    code = value;
                  });
                },
              ),
              const GapY(),
              SizedBox(
                width: 400,
                child: YLiftFilledButton(
                  onPressed: verifyCode,
                  child: const Text('Verify Code'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CodeField extends StatefulWidget {
  final int codeLength;
  final void Function(String? code)? onSaved;

  const CodeField({
    super.key,
    required this.codeLength,
    this.onSaved,
  });

  @override
  State<CodeField> createState() => _CodeFieldState();
}

class _CodeFieldState extends State<CodeField> {
  late final List<TextEditingController> controllers;
  late final List<FocusNode> focusNodes;

  void _handlePaste(String value, int startIndex) {
    final cleanValue = value.replaceAll(RegExp(r'[^0-9]'), '');

    for (int i = 0; i < cleanValue.length && (startIndex + i) < widget.codeLength; i++) {
      controllers[startIndex + i].text = cleanValue[i];
    }

    // Move focus to appropriate field
    final nextEmptyIndex = controllers.indexWhere((controller) => controller.text.isEmpty);
    if (nextEmptyIndex != -1 && nextEmptyIndex < widget.codeLength) {
      focusNodes[nextEmptyIndex].requestFocus();
    } else {
      focusNodes.last.requestFocus();
    }

    _updateParentCode();
  }

  void _handleChange(String value, int index) {
    if (value.length > 1) {
      _handlePaste(value, index);
      return;
    }

    if (value.isNotEmpty && index < widget.codeLength - 1) {
      focusNodes[index + 1].requestFocus();
    }

    _updateParentCode();
  }

  void _handleKeyPress(KeyEvent event, int index) {
    if (event is! KeyDownEvent) return;

    if (event.logicalKey == LogicalKeyboardKey.backspace &&
        controllers[index].text.isEmpty &&
        index > 0) {
      focusNodes[index - 1].requestFocus();
      controllers[index - 1].clear();
      _updateParentCode();
    }
  }

  void _updateParentCode() {
    final code = controllers.map((c) => c.text).join();
    widget.onSaved?.call(code.length == widget.codeLength ? code : null);
  }

  @override
  void initState() {
    super.initState();
    controllers = List.generate(widget.codeLength, (_) => TextEditingController());
    focusNodes = List.generate(widget.codeLength, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    for (var node in focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Wrap(
        spacing: 16,
        children: List.generate(
          widget.codeLength,
              (index) => SingleDigitField(
            controller: controllers[index],
            focusNode: focusNodes[index],
            onKeyPress: (event) => _handleKeyPress(event, index),
            onChanged: (value) => _handleChange(value, index),
          ),
        ),
      ),
    );
  }
}

class SingleDigitField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final void Function(KeyEvent) onKeyPress;
  final void Function(String) onChanged;

  const SingleDigitField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onKeyPress,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      child: KeyboardListener(

        focusNode: FocusNode(),
        onKeyEvent: onKeyPress,
        child: TextFormField(
          controller: controller,
          focusNode: focusNode,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 8),
            counterText: '',
          ),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
          ],
          onChanged: onChanged,
        ),
      ),
    );
  }
}