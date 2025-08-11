import 'package:YLift/core/constants/constant.dart';
import 'package:YLift/core/controllers/global.dart';
import 'package:YLift/models/z-index_export.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:galaxy_ui/galaxy_ui.dart';


class CategoriesDropdown extends StatefulWidget {
  const CategoriesDropdown({super.key});

  @override
  State<CategoriesDropdown> createState() => _CategoriesDropdownState();
}

class _CategoriesDropdownState extends State<CategoriesDropdown> {
  final _key = GlobalKey(debugLabel: 'shop_categories_dropdown');
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

  void goToCategoryPage(ProductCategory category){
    final controller = Get.find<GlobalController>();
    // set controller variable
    controller.selectedCategory.value = category;
    // navigate to category display page
    controller.vroute.navigateTo('/shop/categories' + '/${category.name}');
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

    final categories = controller.categories.toList();
    categories.sort((a, b) => a.name.compareTo(b.name));

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
                  children: categories.map(
                    (category) {
                      return YLiftTextButton(
                        onPressed: () => goToCategoryPage(category),
                        child: Text(category.name),
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
          'CATEGORIES',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),
    );
  }
}
