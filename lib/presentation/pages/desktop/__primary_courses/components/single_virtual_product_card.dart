import 'package:YLift/core/controllers/global.dart';
import 'package:YLift/models/_clean/product.dart';
import 'package:YLift/presentation/components/_complex/dialogs/add_to_cart_dialog.dart';
import 'package:flutter/material.dart';
import 'package:galaxy_ui/galaxy_ui.dart';
import 'package:get/get.dart';

class SingleVirtualProductCard extends StatefulWidget {
  const SingleVirtualProductCard({super.key});

  @override
  State<SingleVirtualProductCard> createState() => _SingleVirtualProductCardState();
}

class _SingleVirtualProductCardState extends State<SingleVirtualProductCard> {
  final global = Get.find<GlobalController>();
  bool isLoading = true;

  ProductSimple? product;

  @override
  void initState(){
    fetchRadiesseProduct();
    super.initState();
  }
  
  void fetchRadiesseProduct() async {
    try{
      setState(() {
        isLoading = true;
      });
      // final product = await global.products.getVirtualProduct('68274c7e3c16db3723d18642');
      final product = await global.products.getProductSimple(449);
      setState(() {
        this.product = product;
      });
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isLoading = false;
      });
    }

  }



  @override
  Widget build(BuildContext context) {

    if(isLoading){
      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(8),
        ),
        width: 240,
        height: 400,
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      );
    }
    return
      GalaxyProductCardXL(
        title: 'Purchase ${product!.name}, Unlock Free Trainings',
        productName: product!.name,
        productDescription: product!.caption!,
        price: '\$${(product!.skus!.first.tieredPrice / 100).toStringAsFixed(2)}', // Assuming price is in cents
        imageUrl: product!.imageUrl,
        buttonText: 'Purchase Now',
        buttonColor: Color(0xFF006AFF),
        onButtonPressed: () {
          // Handle button press
          // print('Purchase button pressed for ${product!.productId}');
          showDialog(
            context: context,
            builder: (context) => AddToCartDialog(
              product: product!,
              onSeeProduct: () async {
                await global.vroute.navigateToProduct(product!.productId!);
              },
              onAddToCart: (sku, quantity) async {
                if (global.isAuthenticated.isFalse) {
                  await global.vroute.navigateTo('/login');
                  return;
                }
                await global.basket.addToCart(
                    customerId: global.user.value.profileId.toString(),
                    quantity: quantity,
                    product: "${product!.productId}-${sku.skuId}"
                );
                global.drawerController.openEndDrawer();
              },
            ),
          );
        },
        onFavoritePressed: () {
          // Handle favorite toggle
          print('Favorite button pressed for ${product!.productId}');
        },
        isFavorite: false,
      );
  }
}
