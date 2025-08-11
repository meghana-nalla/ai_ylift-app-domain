import 'dart:developer';
import 'package:galaxy_models/galaxy_models.dart';
import 'package:YLift/core/constants/constant.dart';
import 'package:YLift/core/constants/index.dart';
import 'package:YLift/core/controllers/z-index_export.dart';
import 'package:YLift/core/services/bearer.dart';
import 'package:YLift/core/services/cookie_service.dart';
import 'package:YLift/models/z-index_export.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web/web.dart' as web;

class Auth0Controller extends GetxController {
  final RxBool showMigrationMessage = false.obs;
  final GlobalController global = Get.find<GlobalController>();

  late SharedPreferencesAsync _prefs;
  String get _authLink => API_WEB_LINK;

  Auth0Controller() {
    _prefs = SharedPreferencesAsync();
    readCookies();
  }

  void checkStatusOfUser() {
    if (global.isAuthenticated.isFalse) {
      global.vroute.navigateTo('/login');
      return;
    }
  }

  Future<void> readCookies() async {
    final acceptedCookies = await _prefs.getBool('acceptCookies');
    if (acceptedCookies != null) {
      global.confirmCookiesDialog.value = false;
      print('Cookies accepted $acceptedCookies');
    }
    global.showCookies.value = acceptedCookies == false;
    global.refresh();
  }

  Future<void> setCookies(bool value) async {
    await _prefs.setBool('acceptCookies', value);
    global.showCookies.value = false;
    global.confirmCookiesDialog.value = false;
    global.refresh();
  }

  LoginResult _handleLoginError(
    PhantomResponse response,
    AuthCredentials credentials,
  ) {
    if (response.message is String) {
      final message = (response.message as String);

      if (response.statusMessage == 'Error') {
        return LoginResult(success: false, message: message);
      }

      if (message.toLowerCase().contains('onboarding process')) {
        return LoginResult(
          success: true,
          message: message,
          requiresRedirect: true,
        );
      }

      if (message.toLowerCase().contains('email')) {
        return LoginResult(success: false, message: message);
        //return LoginResult(success: false, message: 'Unverified email');
      }

      if (message.toLowerCase().contains('passcode')) {
        _prefs.setString('email', credentials.email);
        return LoginResult(
          success: true,
          message: message,
          requiresRedirect: true,
        );
        //return LoginResult(success: true, message: 'Migration required', requiresRedirect: true);
      }

      throw AuthException('unknown', message);
    }
    throw AuthException('unknown', response.data.toString());
  }

  Future<LoginResult?> _handlePostLoginRedirect(LoginResult loginResult) async {
    try {
      final redirectPath = await global.vroute.getInnerRedirect();
      final productId = await _prefs.getString('productId');

      // Check for pending video dialog action
      final pendingVideoDialog = web.window.localStorage['pendingVideoDialog'];

      // If there's a pending video dialog action, navigate to courses page
      if (pendingVideoDialog != null && pendingVideoDialog.isNotEmpty) {
        // Don't clear the localStorage here - that will be done in the courses page
        await global.vroute.navigateTo('/courses');
        return loginResult;
      }

      // Otherwise follow normal redirect flow
      if (productId != null && global.onboardingProcessStep.value == 99) {
        await global.vroute.navigateToProduct(int.parse(productId));
      } else if (redirectPath != null) {
        await global.vroute.navigateTo(redirectPath);
      } else {
        await global.vroute.navigateTo('/shop');
      }
      return loginResult;
    } catch (e) {
      return LoginResult(
        success: false,
        message:
            'Login successful but failed to load some data: ${e.toString()}',
      );
      // return 'Login successful but failed to load some data: ${e.toString()}';
    }
  }

  Future<void> setAuthToken(dynamic token) async {
    final authToken = AuthToken.fromJson(token);
    logDevice();
    AuthCookieHandler.saveAuthData(authToken.tokToken);
    global.authToken.value = authToken;
    global.isAuthenticated.value = true;
    // global.refresh();
  }

  Future<void> performRefreshToken() async {
    PhantomResponse response = await global.api.postLoginData(
      'user/accounts/refresh/token',
      null,
    );
    if (response.statusCode == 200) {
      final token = response.data!['token'];
      await setAuthToken(token);

      // if the user is onboarding, then redirect to the onboarding page
      if (response.message!.contains('onboarding process')) {
        global.onboardingProcessStep.value =
            response.data!['onboardingProcess'] as int;
        global.isOnboarding.value = true;
        global.signUpPayload.value =
            response.data!['signup'] as Map<String, dynamic>;
        global.refresh();
        global.update();
        await global.vroute.navigateTo('/onboarding');
        return; // onboarding process is in progress, profile is not yet fully created
      }

      // keep in mind that onboarding process might be still in process
      if (response.data!['profile'] != null) {
        final profileData = response.data!['profile'] as Map<String, dynamic>;
        global.user.value = AuthProfileUser.fromJson(profileData);
      }
      if (response.data!['cart'] != null) {
        global.simpleCart.value = CartSimple.fromJson(
          response.data!['cart'] as Map<String, dynamic>,
        );
        global.simpleCart.refresh();
      }
      global.update();
      global.refresh();
      return;
    }
    // otherwise, logout
    await global.blowOutUserData();
  }

  Future<LoginResult?> processLogin(AuthCredentials credentials) async {
    final loginResult = await requestLogin(credentials);
    if (loginResult.success) {
      await global.refreshAppLoadData();
      print('Login data refreshed\n\n\n');
      global.refresh();
      if (loginResult.requiresRedirect) {
        return await _handlePostLoginRedirect(loginResult);
      }
    }
    return loginResult;
  }

  Future<void> processSuccessMigration(PhantomResponse response) async {
    global.onboardingProcessStep.value = 99; // definitely not doing onboarding
    await setAuthToken(response.data!['token']);
    if (response.data!['profile'] != null) {
      final profileData = response.data!['profile'] as Map<String, dynamic>;
      global.user.value = AuthProfileUser.fromJson(profileData);
    }
    if (response.data!['cart'] != null) {
      global.simpleCart.value = CartSimple.fromJson(
        response.data!['cart'] as Map<String, dynamic>,
      );
      global.simpleCart.refresh();
    }
    await global.refreshAppLoadData();
    global.update();
    global.refresh();
    global.vroute.navigateTo('/shop');
  }

  Future<LoginResult> requestLogin(AuthCredentials credentials) async {
    try {
      PhantomResponse response = await global.api.postLoginData(
        'user/accounts/user/login',
        credentials,
      );
      if (response.isSuccess) {
        // Check for migration message
        final requireMigration = response.data?['migration'] != null;

        if (requireMigration) {
          final migrationMessage = response.message!;
          global.auth.showMigrationMessage.value = true;
          return LoginResult(
            success: false,
            message: migrationMessage,
            phantomResponse: response,
          );
        }

        await setAuthToken(response.data!['token']);
        // Check for onboarding requirement
        if (response.message!.contains('onboarding process')) {
          global.onboardingProcessStep.value =
              response.data!['onboardingProcess'] as int;
          global.isOnboarding.value = true;
          global.signUpPayload.value =
              response.data!['signup'] as Map<String, dynamic>;
          await global.vroute.setInnerRedirect('/onboarding');
          return LoginResult(
            success: true,
            message: 'Onboarding required',
            requiresRedirect: true,
          );
        }

        global.onboardingProcessStep.value = 99;
        final profileData = response.data!['profile'] as Map<String, dynamic>;
        final user = AuthProfileUser.fromJson(profileData);
        global.user.value = user;

        if (!user.hasAddress) {
          await global.vroute.setInnerRedirect('/require_address');
          return LoginResult(
            success: true,
            message: 'Address required',
            requiresRedirect: true,
          );
        }
        if (!user.hasCardPayment) {
          await global.vroute.setInnerRedirect('/require_card_payment');
          return LoginResult(
            success: true,
            message: 'Card Payment required',
            requiresRedirect: true,
          );
        }

        if (response.data!['cart'] != null) {
          global.simpleCart.value = CartSimple.fromJson(
            response.data!['cart'] as Map<String, dynamic>,
          );
          global.simpleCart.refresh();
          global.update();
          global.refresh();
        }

        return LoginResult(
          success: true,
          message: 'Login successful',
          requiresRedirect: true,
        );
      } else {
        return _handleLoginError(response, credentials);
      }
    } catch (e, s) {
      print('$e\n$s');

      if (e is AuthException) {
        return LoginResult(
          success: false,
          message: 'Authentication failed: ${e.message ?? e.code}',
        );
      }
      return LoginResult(
        success: false,
        message: 'Login failed: ${e.toString()}',
      );
      //return LoginResult(success: false, message: 'There was a problem. Please try your action again. If it still doesn\'t work, our support team is ready to help at 1-800--.');
    }
  }

  Future<void> signUp({
    required String email,
    required String password,
    required bool wasReferred,
    String? affiliateType,
    String? affiliateId,
  }) async {
    await _prefs.remove('productId');
    final dio = Dio();
    dio.interceptors.add(BearerTokenInterceptor());
    final signupUrl =
        wasReferred
            ? '$_authLink/user/accounts/create/user/for/affiliate'
            : '$_authLink/user/accounts/create/user';
    final payload = <String, dynamic>{
      'userName': email,
      'email': email,
      'password': password,
      if (affiliateType == 'name' && affiliateId != null)
        'affiliateName': affiliateId,
      if (affiliateType == 'code' && affiliateId != null)
        'affiliateId': affiliateId,
    };

    final response = await dio.post(
      signupUrl,
      data: payload,
      options: Options(contentType: Headers.jsonContentType),
    );
    final rData = response.data as Map<String, dynamic>;
    final statusCode = rData['statusCode'] ?? 0;
    final status = rData['status'] as String;
    final message = rData['message'] as String;
    print(message);

    if ((statusCode >= 200 && statusCode < 300) ||
        status.toLowerCase() == 'success') {
      if (message.contains('failed')) throw Exception('user failed ');

      // Extract and parse the token
      final tokenJson = rData['data']['token'] as Map<String, dynamic>;
      final authToken = AuthToken.fromJson(tokenJson);
      AuthCookieHandler.saveAuthData(authToken.tokToken);
      global.authToken.value = authToken;
      global.isAuthenticated.value = true;
      global.isOnboarding.value = true;

      final signupData = rData['data']["signup"] as Map<String, dynamic>;
      global.signUpPayload.value = signupData;
      await global.vroute.navigateTo('/onboarding');
    } else {
      // final data = response.data as Map<String, dynamic>;
      // final message = data['message'];
      throw Exception(message);
    }
  }

  Future<void> updateSignUpData(Map<String, dynamic> payload) async {
    PhantomResponse response = await global.api.putData(
      ApiUrl.onboarding.path,
      payload,
    );
    if (response.isSuccess) {
      final signupData = response.data!["signup"] as Map<String, dynamic>;
      global.signUpPayload.value = signupData;
    } else {
      final message =
          response.message ?? 'Unknown error, please try again later';
      throw Exception(message);
    }
  }

  // This is after the user confirm registration and he wants to navigate the different options that the website has
  ///Function modified on 02/13
  ///Remove performRefreshToken instead do the rest of the process in this function
  Future<PhantomResponse> confirmSignUp() async {
    PhantomResponse response = await global.api.putData(
      ApiUrl.onboardingComplete.path,
      null,
    );
    if (response.isSuccess) {
      global.isOnboarding.value = false;
      global.onboardingProcessStep.value = 99;
      //Refreshing token from backend
      PhantomResponse response = await global.api.postLoginData(
        'user/accounts/refresh/token',
        null,
      );
      if (response.statusCode == 200) {
        final token = response.data!['token'];
        await setAuthToken(token);

        if (response.data!['profile'] != null) {
          final profileData = response.data!['profile'] as Map<String, dynamic>;
          final user = AuthProfileUser.fromJson(profileData);
          global.user.value = user;
          //global.user.value = AuthProfileUser.fromJson(profileData);
        }
        await global.refreshAppLoadDataOnboarding();
      }
      return response;
    } else {
      return response;
    }
  }

  Future<void> getSignUpData() async {
    final dio = Dio();
    dio.interceptors.add(BearerTokenInterceptor());
    final url = '$_authLink/${ApiUrl.onboarding.path}';

    final response = await dio.get(url);
    final statusCode = response.data['statusCode'] ?? response.statusCode ?? 0;
    if (statusCode >= 200 && statusCode < 300) {
      final signupData =
          response.data["data"]["signup"] as Map<String, dynamic>;
      global.signUpPayload.value = signupData;
    } else {
      final message =
          response.data['message'] ?? 'Unknown error, please try again later';
      throw Exception('$message');
    }
  }

  Future<void> sendPasswordReset({required String email}) async {
    final response = await global.api.postData(
      ApiUrl.forgotPassword.path,
      email,
    );
    if (response.isSuccess) {
      print('Password reset email sent');
    } else {
      print('Password reset email failed');
    }
  }

  Future<void> sendEmailConfirmation({required String email}) async {
    final response = await global.api.postData(
      ApiUrl.sendEmailVerification.path,
      email,
    );
    if (response.message?.contains('link already sent') ?? false) {
      log('Email verification has been sent');
    } else {
      log('failed to send email verification');
    }
  }

  Future<void> resetPassword({
    required String token,
    required String email,
    required String newPassword,
  }) async {
    try {
      final data = <String, dynamic>{
        'token': token,
        'email': email,
        'newPassword': newPassword,
      };
      final response = await global.api.postData(
        ApiUrl.resetPassword.path,
        data,
      );
      if (response.isSuccess) {
        final token = response.data!['token'];
        await setAuthToken(token);

        global.onboardingProcessStep.value = 99;
        final profileData = response.data!['profile'] as Map<String, dynamic>;
        final user = AuthProfileUser.fromJson(profileData);
        global.user.value = user;

        if (response.data!['cart'] != null) {
          global.simpleCart.value = CartSimple.fromJson(
            response.data!['cart'] as Map<String, dynamic>,
          );
          global.simpleCart.refresh();
          global.update();
          global.refresh();
        }

        global.vroute.navigateTo('/shop');
        print('password has been reset');
      } else {
        throw Exception(response.message);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> verifyEmail({required String code}) async {
    final response = await global.api.postData(ApiUrl.verifyEmail.path, code);
    if (response.isSuccess) {
      return response.data;
    } else {
      throw Exception(response.message);
    }
  }

  Future<bool> testAuth() async {
    final response = await global.api.get_auth('user/accounts/test-auth');
    if (response.statusCode != 200) {
      print('Invalid Response');
      return false;
    }

    var data = response.data;
    print(data);
    return true;
  }

  Future<bool> testSystemAuth() async {
    final response = await global.api.get_auth(
      'user/accounts/system/test/auth',
    );
    if (response.statusCode != 200) {
      print('Invalid Response');
      return false;
    }

    var data = response.data;
    print(data);
    return true;
  }

  Future<void> processLogout() async {
    try {
      global.showingSplash.value = true;
      await logout();
      global.showingSplash.value = false;
    } catch (e) {
      global.showingSplash.value = false;
      print('Logout error: $e');
    }
    global.blowOutCarts();
    await global.blowOutUserData();
    global.refresh();
    await global.refreshAppLoadData();
    global.refresh();
    await global.vroute.navigateTo('/');
  }

  Future<void> mobileProcessLogout() async {
    try {
      global.showingSplash.value = true;
      await logout();
      global.showingSplash.value = false;
    } catch (e) {
      global.showingSplash.value = false;
      print('Logout error: $e');
    }
    global.blowOutCarts();
    await global.blowOutUserData();
    global.refresh();
    await global.refreshAppLoadData();
    global.refresh();
    await global.vroute.navigateTo('/shop');
  }

  Future<void> logout() async {
    try {
      // Clear the auto-login attempt flag
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('hasAttemptedAutoLogin');
      await prefs.remove('productId');
      global.onboardingProcessStep.value = 0;
      global.isAuthenticated.value = false;
      global.authToken.value = AuthToken.empty();
    } catch (e) {
      print('Logout error: $e');
    }
  }

  Future<void> logDevice() async {
    try {
      final deviceInfo = DeviceInfoPlugin();
      final webBrowserInfo = await deviceInfo.webBrowserInfo;

      final data = {
        "width": '${web.window.innerWidth}',
        "height": '${web.window.innerHeight}',
        "device": webBrowserInfo.userAgent ?? '',
        "browser": webBrowserInfo.browserName.name,
        "os": defaultTargetPlatform.name,
        "frontendVersion": '${YLiftConstant.frontendVersion}',
      };
      await global.api.postData(ApiUrl.recordDevice.path, data);
    } catch (e) {
      print('Error logging device: $e');
    }
  }
}

class AuthException implements Exception {
  final String code;
  final String? message;
  const AuthException(this.code, [this.message]);

  static const unverifiedEmail = AuthException(
    'unverified-email',
    'Please verify user email',
  );
  static const needOnboarding = AuthException(
    'need-onboarding',
    'Please complete onboarding',
  );

  @override
  String toString() => 'AuthException($code): $message';
}
