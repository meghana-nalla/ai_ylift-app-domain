import 'package:YLift/core/controllers/global.dart';
import 'package:YLift/presentation/components/mobile_scaffold.dart';
import 'package:YLift/presentation/pages/mobile/account/components/account_navigation_view.dart';
import 'package:YLift/presentation/pages/mobile/account/components/orders_navigation_view.dart';
import 'package:YLift/presentation/pages/mobile/account/components/others_navigation_view.dart';
import 'package:YLift/presentation/pages/mobile/account/order_history/order_history_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MobileAccountPage extends StatefulWidget {
  const MobileAccountPage({super.key});

  @override
  State<MobileAccountPage> createState() => _MobileAccountPageState();
}

class _MobileAccountPageState extends State<MobileAccountPage> {
  final global = Get.find<GlobalController>();

  @override
  void initState() {

    // WidgetsBinding.instance.addPostFrameCallback(
    //   (_) {
    //     autoNavigate();
    //   },
    // );
    super.initState();
  }

  void autoNavigate() {
    final fragment = Uri.base.toString().split('#').last;
    if (fragment == 'order_history') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const MobileOrderHistoryPage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 40,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hi, ${global.user.value.firstName}!',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    global.user.value.email,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                ],
              ),

              const MobileAccountNavigationView(),
              const MobileOrdersNavigationView(),
              const MobileOthersNavigationView(),
            ],
          ),
        ),
      ),
    );
  }
}
