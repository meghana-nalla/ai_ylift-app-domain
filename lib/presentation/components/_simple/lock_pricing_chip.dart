import 'package:YLift/core/controllers/global.dart';
import 'package:YLift/presentation/components/_complex/dialogs/network_benefits_dialog.dart';
import 'package:YLift/presentation/components/_complex/dialogs/unlock_galderma_products_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LockPricingChip extends StatelessWidget {
  final int? vendorId;

  const LockPricingChip({super.key, this.vendorId});

  static const _iconColor = Color(0xFFBBBBBB);
  static const _chipColor = Color(0xFFF3F4F3);

  static final _global = Get.find<GlobalController>();
  bool get isMobile => _global.isMobile.isTrue;

  void onTap(BuildContext context) {
    if (_global.isMobile.isTrue) return;
    if (vendorId == 19) {
      showDialog(
        context: context,
        builder: (context) {
          return NetworkBenefitsDialog();
          // return UnlockGaldermaProductsDialog();
          // Do you have a Galderma account? if yes s

          //fill out form
          // Name of Provider, Name of Practice, Practice Address, Medical License information, email. phone number
        },
      );
      return;
    }
    if (_global.isAuthenticated.isFalse) {
      _global.vroute.navigateTo('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => onTap(context),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
          decoration: BoxDecoration(
            color: _chipColor,
            borderRadius: const BorderRadius.all(Radius.circular(4)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock, size: 11.11, color: _iconColor),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  _global.products.getZeroPriceMessage(vendorId) ??
                      'Login for Pricing',
                  style: TextStyle(fontSize: isMobile ? 8 : 11.11),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
