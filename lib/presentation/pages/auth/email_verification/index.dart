import 'package:YLift/core/controllers/global.dart';
import 'package:YLift/core/services/cookie_service.dart';
import 'package:YLift/models/z-index_export.dart';
import 'package:galaxy_models/galaxy_models.dart';
import 'package:YLift/presentation/components/z-index_export.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmailVerificationPage extends StatefulWidget {
  const EmailVerificationPage({super.key});

  @override
  State<EmailVerificationPage> createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  final global = Get.find<GlobalController>();

  bool _isVerifying = false;

  String? errorMessage;
  String? getCode() {
    final url = Uri.base.path.split('=');
    return url.length > 1 ? url[1] : null;
  }

  void _verifyEmail() async {
    try {
      debugPrint('Verifying user email...');
      setState(() {
        _isVerifying = true;
      });
      final code = getCode();
      if (code == null) throw Exception('Invalid verification code');

      final data = await global.auth.verifyEmail(code: code);
      if (data == null) {
        return;
      }

      final token = data['token'] as Map<String, dynamic>;
      final signup = data['signup'] as Map<String, dynamic>;
      final onboardingProcess = data['onboardingProcess'] as int;

      final authToken = AuthToken.fromJson(token);
      AuthCookieHandler.saveAuthData(authToken.tokToken);
      global.authToken.value = authToken;
      global.isAuthenticated.value = true;
      // Check for onboarding requirement
      if (onboardingProcess < 99) {
        global.onboardingProcessStep.value = onboardingProcess;
        global.isOnboarding.value = true;
        global.signUpPayload.value = signup;
        await global.vroute.navigateTo('/onboarding');
        return;
      }

      if (data['profile'] != null) {
        final profileData = data['profile'] as Map<String, dynamic>;
        global.user.value = AuthProfileUser.fromJson(profileData);
      }
      global.vroute.navigateTo('/shop');
    } catch (e, s) {
      debugPrint('$e\n$s');
      errorMessage = '$e'.replaceAll('Exception: ', '');
    } finally {
      setState(() {
        _isVerifying = false;
      });
    }
  }

  @override
  void initState() {
    _verifyEmail();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Email Verification',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const GapY(),
            if (_isVerifying)
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Verifying email...'),
                  SizedBox(width: 16),
                  CircularProgressIndicator(),
                ],
              )
            else if (errorMessage != null)
              Text(errorMessage!, textAlign: TextAlign.center)
            else
              const Column(
                children: [
                  Text('Your email has been verified!'),
                  Text('You will be redirected soon...'),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
