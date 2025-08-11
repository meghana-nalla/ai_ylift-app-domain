import 'dart:async';

import 'package:YLift/core/controllers/global.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LogoutPage extends StatefulWidget {
  const LogoutPage({super.key});

  @override
  State<LogoutPage> createState() => _LogoutPageState();
}

class _LogoutPageState extends State<LogoutPage> {
  final global = Get.find<GlobalController>();
  Timer? _redirectTimer;

  void logOut() async {
    try{
      await global.auth.logout();
      await global.blowOutCarts();
      await global.blowOutUserData();
      await global.refreshAppLoadData();
      await global.products.loadAllAuthProducts();
      debugPrint('Logout successful');

      _redirectTimer = Timer(const Duration(seconds: 4), () {
        global.vroute.navigateTo('/login');
      });
    } catch (e) {

    }

  }

  @override
  void initState() {
    logOut();
    super.initState();
  }

  @override
  void dispose() {
    _redirectTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'You have been logged out.',
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
            ),
            Text('You will be redirected shortly...'),
          ],
        ),
      ),
    );
  }
}
