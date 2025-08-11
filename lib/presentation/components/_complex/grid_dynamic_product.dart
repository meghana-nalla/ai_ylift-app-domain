import 'package:YLift/models/z-index_export.dart';
import 'package:YLift/core/controllers/z-index_export.dart';
import 'package:YLift/presentation/components/products/mobile_product_tile.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DynamicProductGridView extends StatefulWidget {
  final String PageContents;
  DynamicProductGridView({required this.PageContents});

  @override
  State<DynamicProductGridView> createState() => _DynamicProductGridViewState();
}

class _DynamicProductGridViewState extends State<DynamicProductGridView> {
  // TODO : remove from component
  final controller = Get.find<GlobalController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            controller.vroute.returnToHome();
          },
        ),
        title: Text(widget.PageContents),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Obx(
                        () => GridView.builder(
                      padding: EdgeInsets.only(bottom: 120.0),
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 300.0,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 3/5,
                      ),
                      itemCount: controller.dynamicProducts.length,
                      itemBuilder: (context, index) {
                        return MobileProductTile(
                          // isAuthen: controller.isAuthenticated.value,
                          product: controller.dynamicProducts[index],
                          hidePrice: controller.isAuthenticated.isFalse,
                          onProductTap: () {
                            _handleNavigation(controller.dynamicProducts[index]);
                          },
                        );
                      },
                    ),
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _handleNavigation(ProductSimple item) async {
    if(controller.navigateQuickLinkIndex.value > 1) {
      controller.products.select(item);
      controller.navigateMobileIndex.value = 6;
      controller.display.update();
    }
    else {
      // categories = 0
      // if inside categories, should see list of products
      // click on product -> display product info
      if (controller.navigateQuickLinkIndex.value == 0 && !controller.enteredSubcategory.value) {
        print('Id: ${item.productId}');
        controller.enteredSubcategory.value = true;
        controller.dynamicProducts.value =
        await controller.quick.fetchCategoryLinksById(item.productId.toString());
        // controller.display.setDynamicData();
        controller.display.update();
        // else {
        //   print('Dynamic Products List: ${controller.dynamicProducts}');
        //   controller.products.select(item);
      }
      else if (controller.navigateQuickLinkIndex.value == 0 && controller.enteredSubcategory.value) {
        print('Id: ${item.productId}');
        controller.enteredSubcategory.value = false;
        controller.dynamicProducts.value = await controller.quick.fetchCategoryLinksById(item.productId.toString());
        //controller.products.select(item);
        controller.display.update();
        //controller.navigateMobileIndex.value = 6;
        controller.navigateMobileIndex.value = 7;
        //global.display.setDynamicData();
        // controller.display.update();

      }

      else if (controller.navigateQuickLinkIndex.value == 1 && !controller.enteredSubcategory.value) {
        controller.enteredSubcategory.value = true;
        print('Id: ${item.id}');
        controller.dynamicProducts.value =
        await controller.quick.fetchBrandLinksById(item.productId!);
        controller.display.update();
        print('Dynamic Products List: ${controller.dynamicProducts}');
      }

      else if (controller.navigateQuickLinkIndex.value == 1 && controller.enteredSubcategory.value) {
        controller.products.select(item);
        controller.navigateQuickLinkIndex.value = 7;
        controller.display.update();
      }
    }

      // brands = 1
        // should see list of products filtered by brand
        // click on product -> display product info



    }
    // first we read where we are ... is this category or brand? or product displays?
    // then we navigate to the appropriate page
    // if its category, we navigate to the category page
    // if its brand, we navigate to the brand page
    // if its product, we navigate to the product page

}
