import 'package:YLift/presentation/components/dialogs/logout_dialog.dart';
import 'package:YLift/presentation/pages/mobile/account/components/mobile_navigation_tile.dart';
import 'package:flutter/material.dart';

class MobileOthersNavigationView extends StatelessWidget {
  const MobileOthersNavigationView({super.key});

  void showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const MobileLogoutDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'OTHERS',
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
              // MobileNavigationTile(
              //   label: 'Reset Password',
              //   onTap: () {},
              // ),
              // const Divider(
              //   height: 1,
              //   thickness: 0.5,
              //   color: Colors.black12,
              // ),
              MobileNavigationTile(
                label: 'Log out',
                trailing: Icon(
                  Icons.logout_outlined,
                  size: 18,
                ),
                onTap: () => showLogoutDialog(context),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
