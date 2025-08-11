import 'package:YLift/core/navigations/account_navigation.dart';
import 'package:YLift/presentation/pages/mobile/account/address_book/address_book_page.dart';
import 'package:YLift/presentation/pages/mobile/account/components/mobile_navigation_tile.dart';
import 'package:YLift/presentation/pages/mobile/account/medical_license/medical_license_page.dart';
import 'package:YLift/presentation/pages/mobile/account/saved_wallets/saved_wallets_page.dart';
import 'package:YLift/presentation/pages/mobile/account/user_profile/user_profile_page.dart';
import 'package:flutter/material.dart';

class MobileAccountNavigationView extends StatelessWidget {
  const MobileAccountNavigationView({super.key});

  void navigateTo(BuildContext context, AccountNavigation nav) {
    switch (nav) {
      case AccountNavigation.profile:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const MobileUserProfilePage(),
          ),
        );
        break;
      case AccountNavigation.savedWallets:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const MobileSavedWalletsPage(),
          ),
        );
        break;
      case AccountNavigation.addressBook:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MobileAddressBookPage()),
        );
        break;
      case AccountNavigation.medicalLicense:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const MobileMedicalLicensePage(),
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ACCOUNT',
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
            children: List.generate(
              AccountNavigation.values.length * 2 - 1,
              (index) {
                if (index.isOdd) {
                  return const Divider(
                    height: 1,
                    thickness: 0.5,
                    color: Colors.black12,
                  );
                }

                final nav = AccountNavigation.values[index ~/ 2];
                return MobileNavigationTile(
                  label: nav.label,
                  onTap: () => navigateTo(context, nav),
                  trailing: nav.icon != null ? Icon(nav.icon) : null,
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
