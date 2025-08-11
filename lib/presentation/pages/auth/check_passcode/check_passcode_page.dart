import 'package:galaxy_ui/galaxy_ui.dart';
import 'dart:async';
import 'package:YLift/core/controllers/global.dart';
import 'package:galaxy_models/galaxy_models.dart';
import 'package:YLift/models/urls/api.dart';
import 'package:YLift/presentation/pages/auth/two_factor_authentication/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckPasscodePage extends StatefulWidget {
  const CheckPasscodePage({super.key});

  @override
  State<CheckPasscodePage> createState() => _CheckPasscodePageState();
}

class _CheckPasscodePageState extends State<CheckPasscodePage> {
  final global = Get.find<GlobalController>();

  String? code;
  String? errorMessage;

  late Future<String?> emailFuture;

  void checkAuthenticated() async {
    if (global.isAuthenticated.value && global.onboardingProcessStep.value == 99) {
      await global.vroute.navigateTo('/shop');
    }
  }

  @override
  void initState() {
    checkAuthenticated();
    final prefs = SharedPreferencesAsync();
    emailFuture = prefs.getString('email');

    super.initState();
  }

  void verifyCode() async {
    if (code == null) return;
    final queryParameters = <String, String>{'passcode': code!};
    PhantomResponse response = await global.api.postData(ApiUrl.migrationVerifyPasscode.withQuery(queryParameters), {});
    if (!mounted) return;
    // Check for already used passcode before handling success/failure
    if (response.message == 'Passcode already used and user migration was successful') {
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

    // otherwise continue with the regular success/failure handling
    if (response.isSuccess){
      global.isAuthenticated.value = true;
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            title: Text('🥳 \nAccount Migration Successful!'),
            content: Text('Welcome to the new YLS system.\nYou will be redirected soon...'),
          );
        },
      );

      Timer(
        const Duration(seconds: 5),
            () async {
              Navigator.of(context).pop();
              await global.auth.processSuccessMigration(response);
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
    if (global.isMobile.value == true) {
      return Scaffold(
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 32),
                  const Text('Please use a desktop to verify your account'),
                  const SizedBox(height: 64),
                  const SizedBox(height: 32),
                  YLiftFilledButton(
                    onPressed: () => global.vroute.navigateTo('/shop'),
                    child: const Text('Go Shop'),
                  ),
                ],
              ),
            )
        ),
      );
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 32),
              const Text('Please enter the passcode that was sent to your email to verify your account.'),
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
        )
      ),
    );
  }
}
