import 'package:YLift/core/constants/constant.dart';
import 'package:YLift/core/controllers/global.dart';
import 'package:YLift/models/z-index_export.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:galaxy_ui/galaxy_ui.dart';
/// developer note: this is basically a copy-paste of Brands_dropdown.dart.
/// In the future, the two classes should be merged.

class BrandsDropdown extends StatefulWidget {
  const BrandsDropdown({super.key});

  @override
  State<BrandsDropdown> createState() => _BrandsDropdownState();
}

class _BrandsDropdownState extends State<BrandsDropdown> {
  final _key = GlobalKey(debugLabel: 'shop_brands_dropdown');
  final overlayController = OverlayPortalController();

  final controller = Get.find<GlobalController>();

  bool isHovering = false;

  // Need to refactor later, logic not so great
  void toggleHover(bool value) {
    if (value && !overlayController.isShowing) {
      overlayController.show();
    }
    if (!value && overlayController.isShowing) {
      overlayController.hide();
    }
    setState(() {
      isHovering = value;
    });
  }

  void goToBrandPage(ProductBrand brand) {
    controller.selectedBrand.value = brand;
    controller.vroute.navigateTo('/shop/brands' + '/${brand.safeBrandName!.toLowerCase()}');
    overlayController.hide();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final box = _key.currentContext?.findRenderObject() as RenderBox?;
    final position = box?.localToGlobal(const Offset(-40, 40));

    final brands = controller.brands.toList();
    brands.sort((a, b) => a.name.compareTo(b.name));

    return OverlayPortal(
      controller: overlayController,
      overlayChildBuilder: (context) {
        return Stack(
          children: [
            Listener(
              onPointerDown: (_) {
                overlayController.hide();
              },
              onPointerSignal: (event) {
                overlayController.hide();
              },
              child: ColoredBox(
                color: Colors.transparent,
                child: SizedBox.fromSize(
                  size: MediaQuery.of(context).size,
                ),
              ),
            ),
            Positioned(
              left: position?.dx ?? 200,
              top: position?.dy ?? YLiftConstant.totalTopNavigation,
              child: Container(
                height: 240,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                ),
                child: Wrap(
                  direction: Axis.vertical,
                  children: brands.map(
                    (brand) {
                      return YLiftTextButton(
                        onPressed: () => goToBrandPage(brand),
                        child: Text(brand.name),
                      );
                    },
                  ).toList(),
                ),
              ),
            ),
          ],
        );
      },
      child: TextButton(
        key: _key,
        onPressed: () {
          overlayController.toggle();
        },
        child: const Text(
          'BRANDS',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),
    );
  }
}
