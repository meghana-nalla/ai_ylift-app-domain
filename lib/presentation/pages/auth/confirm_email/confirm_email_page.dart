import 'dart:async';
import 'dart:convert';

import 'package:YLift/core/controllers/global.dart';
import 'package:YLift/models/urls/api.dart';
import 'package:galaxy_ui/galaxy_ui.dart';
import 'package:YLift/presentation/pages/auth/two_factor_authentication/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ConfirmEmailPage extends StatefulWidget {
  const ConfirmEmailPage({super.key});

  @override
  State<ConfirmEmailPage> createState() => _ConfirmEmailPageState();
}

class _ConfirmEmailPageState extends State<ConfirmEmailPage> {
  final global = Get.find<GlobalController>();

  String? code;
  String? errorMessage;

  late Future<String?> emailFuture;

  @override
  void initState() {
    final prefs = SharedPreferencesAsync();
    emailFuture = prefs.getString('email');
    super.initState();
  }

  void verifyCode() async {
    if (code == null) return;

    final queryParameters = <String, String>{'passcode': code!};
    final url = Uri.parse('${ApiUrl.base.path}/${ApiUrl.migrationVerifyPasscode.withQuery(queryParameters)}');
    final response = await http.post(url);

    if (!mounted) return;

    // Parse the response body first to check for the "already used" message
    final responseBody = utf8.decode(response.bodyBytes);

    // Check for already used passcode before handling success/failure
    if (responseBody.contains('Passcode already used and user migration was successful')) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: const Text('Passcode Already Used'),
            content: const Text(
              'This passcode has already been used to migrate your account. '
              'If you believe this is an error, please contact support.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    code = null;
                  });
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      return; // Exit early since we've handled the "already used" case
    }

    // Now handle the regular success/failure cases
    if (response.statusCode >= 200 && response.statusCode < 300) {
      global.isAuthenticated.value = true;

      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            title: Text('Account Migration Successful!'),
            content: Text('Your account has been migrated!\nYou will be redirected soon...'),
          );
        },
      );

      Timer(
        const Duration(seconds: 5),
        () {
          global.isAuthenticated.value = true;
          global.vroute.navigateTo('/shop');
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid passcode')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('A passcode has been sent to your email:'),
            const SizedBox(height: 32),
            FutureBuilder<String?>(
              future: emailFuture,
              builder: (context, snapshot) {
                final data = snapshot.data;
                if (data == null) return const Text('(No email found)');
                return Text(data);
              },
            ),
            const SizedBox(height: 32),
            const Text('Please check your email and verify the passcode'),
            const SizedBox(height: 64),
            CodeField(
              codeLength: 6,
              onSaved: (code) {
                setState(() {
                  this.code = code;
                });
              },
            ),
            const SizedBox(height: 32),
            YLiftFilledButton(
              onPressed: verifyCode,
              child: const Text('Verify passcode'),
            ),
          ],
        ),
      ),
    );
  }
}
