import 'package:YLift/core/controllers/global.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordButton extends StatelessWidget {
  const ForgotPasswordButton({super.key});

  void _goToForgotPassword() {
    final global = Get.find<GlobalController>();
    global.vroute.navigateTo('/forgot_password');
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: _goToForgotPassword,
          child: const Text(
            'Forgot password?',
            style: TextStyle(color: Color(0xFF006AFF), fontSize: 12),
          ),
        ),
      ),
    );
  }
}
