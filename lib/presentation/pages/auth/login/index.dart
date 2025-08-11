
import 'package:YLift/core/controllers/global.dart';
import 'package:YLift/core/controllers/z-index_export.dart';
import 'package:galaxy_models/galaxy_models.dart';
import 'package:YLift/presentation/components/z-index_export.dart' hide RoundedFilledButton;
import 'package:YLift/presentation/pages/auth/login/components/create_account_button.dart';
import 'package:YLift/presentation/pages/auth/login/components/create_account_divider.dart';
import 'package:YLift/presentation/pages/auth/login/components/forgot_password_button.dart';
import 'package:YLift/presentation/pages/auth/login/components/having_trouble_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:galaxy_ui/galaxy_ui.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final global = Get.find<GlobalController>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isAuthenticated = false;
  String? errorMessage;
  final prefs = SharedPreferencesAsync();
  bool _fromOnboarding = false;
  bool _isLoading = true;

  Future<void> getFromOnboarding() async {
    String? extra = await prefs.getString('extra');
    // if (extra != null && extra == 'newUser') _fromOnboarding = true;
  }

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _fromOnboarding = false;
    if (kDebugMode) {
      emailController.text = 'default@default.com';
      // emailController.text = 'richie@staff.ylift.com';
      passwordController.text = '123Abc@@';
      // passwordController.text = 'ylsDev1!';
    }
    init();
  }

  void init() async {
    await getFromOnboarding();
    setState(() {
      _isLoading = false;
    });
  }

  cleanString(String str, bool isEmail) {
    return isEmail ? str.trim().toLowerCase() : str.trim();
  }

  bool isLoggingIn = false;

  void performUserLogin() async {
    setState(() {
      errorMessage = null;
      isLoggingIn = true;
    });
    AuthCredentials body = AuthCredentials(
        username: cleanString(emailController.text, true),
        email: cleanString(emailController.text, true),
        password: cleanString(passwordController.text, false));

    try {
      final loginResult = await global.auth.processLogin(body);
      final result = loginResult?.message;
      if (!mounted) return;
      if (result != null) {
        setState(() {
          if (result.contains('Migration required')) {
            errorMessage = 'Welcome back! Please check your email for a migration code.';
          } else if (!result.contains('Login successful')) {
            // we need a better message for non-success message that isn't migration
            errorMessage = result;
          }
        });
      }

      if (global.auth.showMigrationMessage.value) {
        errorMessage = result;
      }
    } catch (e, s) {
      print('$e\n$s');
      if (!mounted) return;

      setState(() {
        if (e.toString().contains('invalid username or password')) {
          errorMessage = 'Invalid username or password';
        } else if (e.toString().contains('login failed')) {
          errorMessage = 'Invalid username or password';
        } else if (e.toString().contains('unverified-email')) {
          errorMessage = 'Please verify your email before signing in';
        } else {
          errorMessage = 'An error occurred while signing in';
        }
      });
    } finally {
      if (mounted) {
        setState(() {
          isLoggingIn = false;
        });
      }
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return (_isLoading)
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            body: Container(
              width: double.infinity,
              alignment: Alignment.center,
              margin: global.isMobile.isTrue ? const EdgeInsets.symmetric(horizontal: 16) : null,
              child: Column(
                children: [
                  Expanded(
                    child: SizedBox(
                      width: 480,
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              (_fromOnboarding) ? 'Welcome New User!' : 'Sign In to Y LIFT Store',
                              style: textTheme.headlineSmall,
                            ),
                            const SizedBox(height: 24),
                            if (errorMessage != null)
                              // (errorMessage &&
                              //         'Welcome back! Please check your email for a migration code. You will be redirected shortly.')
                              global.auth.showMigrationMessage.value
                                  ? Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(5)),
                                        color: Colors.greenAccent,
                                      ),
                                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                                      child: Text(
                                        errorMessage!,
                                        style: TextStyle(color: Colors.black87),
                                      ),
                                    )
                                  : GalaxyErrorMessage(message: errorMessage!, color: YLiftColor.errorContainer),
                            const SizedBox(height: 24),
                            EmailField(
                              controller: emailController,
                            ),
                            const SizedBox(height: 16),
                            YLiftPasswordField(
                              controller: passwordController,
                              withValidator: false,
                            ),
                            ForgotPasswordButton(),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              child: RoundedFilledButton(
                                onPressed: isLoggingIn
                                    ? null
                                    : () {
                                        if (_formKey.currentState!.validate()) {
                                          performUserLogin();
                                        }
                                      },
                                child: Text(isLoggingIn ? 'Logging in...' : 'LOGIN'),
                              ),
                            ),
                            const SizedBox(height: 16),
                            CreateAccountDivider(),
                            const SizedBox(height: 16),
                            // if (global.isMobile.isTrue)
                            //   Text(
                            //     'Please use a desktop to create an account.',
                            //     style: TextStyle(fontSize: 11.11),
                            //   )
                            // else
                              CreateAccountButton(),
                            const SizedBox(height: 16),
                            HavingTroubleButton(),
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

class LoginFailedDialog extends StatelessWidget {
  final AuthException? exception;
  const LoginFailedDialog({
    super.key,
    this.exception,
  });

  static Future<void> show(BuildContext context, [AuthException? exception]) {
    return showDialog(context: context, builder: (context) => LoginFailedDialog(exception: exception));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Login failed'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Code: ${exception?.code ?? 'Unknown'}'),
          Text(exception?.message ?? 'Something went wrong!'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Close'),
        ),
      ],
    );
  }
}
