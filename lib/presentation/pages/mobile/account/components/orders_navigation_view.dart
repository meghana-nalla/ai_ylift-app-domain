import 'package:YLift/core/controllers/global.dart';
import 'package:YLift/core/navigations/account_navigation.dart';
import 'package:YLift/presentation/components/dialogs/mobile_dialog.dart';
import 'package:YLift/presentation/pages/mobile/account/components/mobile_navigation_tile.dart';
import 'package:YLift/presentation/pages/mobile/account/order_history/order_history_page.dart';
import 'package:YLift/presentation/pages/mobile/courses/delete_bundle_dialog.dart';
import 'package:flutter/material.dart';
import 'package:galaxy_models/core/core.dart';
import 'package:get/get.dart';

class MobileOrdersNavigationView extends StatelessWidget {
  const MobileOrdersNavigationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ORDERS',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.4,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          clipBehavior: Clip.hardEdge,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...List.generate(
                OrderNavigation.values.length * 2 - 1,
                (index) {
                  if (index.isOdd) {
                    return const Divider(
                      height: 1,
                      thickness: 0.5,
                      color: Colors.black12,
                    );
                  }

                  final nav = OrderNavigation.values[index ~/ 2];
                  return MobileNavigationTile(
                    label: nav.label,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MobileOrderHistoryPage(),
                        ),
                      );
                    },
                    trailing: nav.icon != null ? Icon(nav.icon) : null,
                  );
                },
              ),
              const Divider(height: 1, thickness: 0.5, color: Colors.black12),
              const _StoreCreditBalanceTile(),
            ],
          ),
        ),
      ],
    );
  }
}

class _StoreCreditBalanceTile extends StatefulWidget {
  const _StoreCreditBalanceTile({super.key});

  @override
  State<_StoreCreditBalanceTile> createState() =>
      _StoreCreditBalanceTileState();
}

class _StoreCreditBalanceTileState extends State<_StoreCreditBalanceTile> {
  final global = Get.find<GlobalController>();
  late Future<int?> _storeCreditBalanceFuture;

  @override
  void initState() {
    _storeCreditBalanceFuture = global.userController.getStoreCreditBalance();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _storeCreditBalanceFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox.shrink();
        } else if (snapshot.hasError) {
          return Text('Failed to load store credit balance: ${snapshot.error}');
        } else {
          final balance = (snapshot.data ?? 0) * 100;
          if (balance == 0) return const SizedBox.shrink();
          return GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return MobileDialog(
                    title: Text('Store Credit'),
                    content: Column(
                      children: [
                        Text(
                          'Store credit can be used in the checkout before placing an order.',
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Text(
                              'Balance: ',
                            ),
                            Text(
                              balance.toCurrency(),
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Text('Store Credit: '),
                  Text(
                    balance.toCurrency(),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
