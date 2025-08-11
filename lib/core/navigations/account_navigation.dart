import 'package:flutter/material.dart';

enum AccountNavigation {
  profile('Profile', '/account/profile', Icons.person_outline_rounded),
  savedWallets('Saved Wallets', '/account/saved-wallets', Icons.wallet_outlined),
  addressBook('Address Book', '/account/address-book', Icons.local_shipping_outlined),
  medicalLicense('Medical License', '/account/medical-license', Icons.badge_outlined);

  final String label;
  final IconData? icon;
  final String path;

  const AccountNavigation(this.label, this.path, [this.icon]);
}

enum OrderNavigation {
  orders('Order History', '/account/orders', Icons.history_outlined);

  final String label;
  final String path;
  final IconData? icon;

  const OrderNavigation(this.label, this.path, [this.icon]);
}
