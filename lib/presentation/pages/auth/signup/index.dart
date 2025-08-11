import 'package:YLift/core/constants/color.dart';
import 'package:YLift/core/controllers/global.dart';

import 'package:YLift/presentation/components/z-index_export.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:galaxy_ui/galaxy_ui.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});
  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool agreeTerms = false;
  bool referredByAffiliate = false;
  String? emailError;
  String? passwordError;
  String? confirmPasswordError;
  String? agreementsErrorMessage;

  String? errorMessage;

  void initializeFields() {
    emailController.text = '';
    passwordController.text = '123Abc@@';
    confirmPasswordController.text = '123Abc@@';
  }

  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      initializeFields();
    }
  }

  void clearErrors() {
    setState(() {
      errorMessage = null;
      emailError = null;
      passwordError = null;
      confirmPasswordError = null;
      agreementsErrorMessage = null;
    });
  }

  bool validateForm() {
    final isFormValid = _formKey.currentState!.validate();
    return isFormValid;
  }

  ({String type, String value})? getAffiliateCode() {
    final url = Uri.base;
    if(url.pathSegments.length < 2) return null;
    final afterSignup = url.pathSegments.sublist(1);
    if(afterSignup.first == 'via') return (type: 'name', value: afterSignup.last);
    return (type: 'code', value: afterSignup.last);
  }

  void signUp() async {
    final isFormValid = _formKey.currentState!.validate();
    if (!agreeTerms) {
      setState(() {
        agreementsErrorMessage = 'Please accept the terms to continue';
      });
    }
    if (!isFormValid || !agreeTerms) return;

    // read in the current route from the url
    var route = Get.currentRoute;
    if (route == '/signup/for/affiliate') {
      print('Current route: $route');
      setState(() {
        referredByAffiliate = true;
      });
    }

    try {
      final controller = Get.find<GlobalController>();
      final email = emailController.text.trim().toLowerCase();
      final affiliate = getAffiliateCode();

      await controller.auth.signUp(
        email: email,
        password: passwordController.text,
        wasReferred: referredByAffiliate,
        affiliateType: affiliate?.type,
        affiliateId: affiliate?.value,
      );
    } catch (e) {
      setState(() {
        final error = e.toString().split(': ');
        if (error.length > 1) {
          errorMessage = error.last;
        } else {
          errorMessage = '$e';
        }
        // emailError = 'Email is already taken';
      });
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: Container(
        width: double.infinity,
        alignment: Alignment.center,
        child: Column(
          children: [
            Expanded(
              child: SizedBox(
                width: 480,
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Create Your Y LIFT Store Account',
                        style: textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      const AlreadyHaveAnAccountText(),
                      const SizedBox(height: 16),
                      if (errorMessage != null) ...[
                        GalaxyErrorMessage(message: errorMessage!, color:  YLiftColor.errorContainer),
                        const SizedBox(height: 16),
                      ],
                      EmailField(
                        controller: emailController,
                        // errorText: emailError,
                        onFieldSubmitted: (password) => signUp,
                      ),
                      const SizedBox(height: 16),
                      YLiftPasswordField(
                        controller: passwordController,
                        errorText: passwordError,
                        onFieldSubmitted: (password) => signUp,
                        showRequirements: true,
                      ),
                      const SizedBox(height: 16),
                      YLiftPasswordField(
                        controller: confirmPasswordController,
                        labelText: 'Confirm Password',
                        validator: (confirmPassword) {
                          if (confirmPassword == null ||
                              confirmPassword!.isEmpty)
                            return 'Enter confirm password';
                          final password = passwordController.text;
                          if (confirmPassword != password) {
                            return 'Confirm password does not match';
                          }
                          return null;
                        },
                        onFieldSubmitted: (password) => signUp,
                        showRequirements: true,
                      ),
                      // const SizedBox(height: 16),

                      // Terms of Service
                      Row(
                        children: [
                          Checkbox(
                            value: agreeTerms,
                            onChanged: (value) {
                              setState(() {
                                agreeTerms = value ?? false;
                                agreementsErrorMessage = null;
                              });
                            },
                          ),
                          const SizedBox(width: 16),
                          const TermsText(),
                          const Spacer(),
                          if (agreementsErrorMessage != null)
                            Text(
                              agreementsErrorMessage!,
                              style: const TextStyle(
                                color: YLiftColor.darkOrange,
                                fontSize: 11.11,
                              ),
                            )
                          else
                            const SizedBox(height: 20),
                        ],
                      ),
                      const SizedBox(height: 8),

                      SizedBox(
                        width: double.infinity,
                        child: RoundedFilledButton(
                          onPressed: signUp,
                          child: const Text('Sign Up'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (global.isMobile.isFalse) GalaxyFooter(),
          ],
        ),
      ),
    );
  }
}

class TermsText extends StatefulWidget {
  const TermsText({super.key});

  @override
  State<TermsText> createState() => _TermsTextState();
}

class _TermsTextState extends State<TermsText> {
  final termsRecognizer = TapGestureRecognizer();

  @override
  void initState() {
    termsRecognizer.onTap = () {
      TermsDialog.show(context);
    };
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(fontSize: 16),
        text: 'Agree to ',
        children: [
          TextSpan(
            text: 'Y LIFT Terms',
            style: const TextStyle(decoration: TextDecoration.underline),
            recognizer: termsRecognizer,
          ),
        ],
      ),
    );
  }
}

class AlreadyHaveAnAccountText extends StatefulWidget {
  const AlreadyHaveAnAccountText({super.key});

  @override
  State<AlreadyHaveAnAccountText> createState() =>
      _AlreadyHaveAnAccountTextState();
}

class _AlreadyHaveAnAccountTextState extends State<AlreadyHaveAnAccountText> {
  final signInRecognizer = TapGestureRecognizer();
  void goToLogin() {
    final global = Get.find<GlobalController>();
    global.vroute.navigateTo('/login');
  }

  @override
  void initState() {
    signInRecognizer.onTap = goToLogin;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return RichText(
      text: TextSpan(
        style: textTheme.bodyMedium,
        children: [
          const TextSpan(text: 'Already have a Y LIFT Store Account?   '),
          TextSpan(
            recognizer: signInRecognizer,
            style: const TextStyle(color: Color(0xFF006AFF)),
            mouseCursor: SystemMouseCursors.click,
            text: 'Sign In',
            children: const [
              WidgetSpan(
                style: TextStyle(color: Color(0xFF006AFF)),
                child: Icon(Icons.arrow_right_alt, color: Color(0xFF006AFF)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
