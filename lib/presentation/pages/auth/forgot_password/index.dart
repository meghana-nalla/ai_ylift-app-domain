import 'package:YLift/core/constants/color.dart';
import 'package:YLift/core/controllers/global.dart';
import 'package:YLift/presentation/components/z-index_export.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:galaxy_ui/galaxy_ui.dart';
class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final global = Get.find<GlobalController>();
  final emailController = TextEditingController();
  String? message;

  void sendResetPassword() async {
    final email = emailController.text;
    await global.auth.sendPasswordReset(email: email);
    if(!mounted) return;
    setState(() {
      message = 'Reset password email sent to $email';
    });
    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: content))
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 400,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Forgot Password', style: TextStyle(fontSize: 32)),
              const GapY(factor: 2),
              // const Text('Your password was last changed from ...'),
              const SizedBox(height: 16),
              YLiftTextField(
                labelText: 'Email',
                controller: emailController,
              ),
              const GapY(),
              if (message != null)...[
                Text(message!, style: TextStyle(color: YLiftColor.orange)),
                const SizedBox(height: 8),
              ],
              YLiftFilledButton(
                isExpanded: true,
                onPressed: sendResetPassword,
                child: const Text('Send Reset Password'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
