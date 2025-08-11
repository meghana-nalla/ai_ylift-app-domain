import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:YLift/core/controllers/z-index_export.dart';
import 'package:YLift/presentation/components/_complex/z-index_export.dart';


/// # Dynamic Products Screen
/// - Screen that displays products based on the current category
class DynamicProductViewScreen extends StatefulWidget {
  @override
  _DynamicProductViewScreenState createState() => _DynamicProductViewScreenState();
}

class _DynamicProductViewScreenState extends State<DynamicProductViewScreen> {

  final controller = Get.find<GlobalController>();

  @override
  void initState() {
    super.initState();
    _checkSubcategory();
  }

  Future<void> _checkSubcategory() async {
    if (controller.enteredSubcategory.value) {
      // if true, reset categories back to top-level view & reset to false
      controller.categories.value = await controller.quick.fetchCategoryLinks();
      controller.brands.value = await controller.quick.fetchBrandLinks();
      controller.display.setDynamicData();
      controller.display.update();
      controller.enteredSubcategory.value = false;
    }
  }



  Widget _buildScreen(int index) {
    // TODO : Hook up products to this screen
    switch (index) {
    // case 0:
      // return CategoriesPage();
      default:
        if (controller.quickLinks[index].name == 'Promotions') {
          return PromotionsPage();
        }
        print(controller.quickLinks[index].name);

        return DynamicProductGridView(PageContents: controller.quickLinks[index].name);
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // AppBar(
            //   title: Text('Dynamic Products'),
            // ),
            // Dynamic screen content
            Expanded(
              child: Obx(() => _buildScreen(controller.navigateQuickLinkIndex.value)),
            ),
          ],
        ),
      ),
    );
  }
}