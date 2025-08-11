import 'package:flutter/material.dart';
import 'package:YLift/presentation/components/_complex/single_product.dart';
import 'package:YLift/core/controllers/z-index_export.dart';
import 'package:get/get.dart';
import 'dart:developer' as developer;

class ProductScreen extends StatefulWidget {
  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final GlobalController controller = Get.find<GlobalController>();
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeProductData();
  }

  Future<void> _initializeProductData() async {
    final urlProductId = Get.parameters['id'];

    if (urlProductId != null) {
      // URL navigation case
      await _loadProductDataFromUrl(int.parse(urlProductId));
      // TODO the three lines below this were not commented out. Might cause some things to break
      // } else if (!controller.displayProduct.value.dataComplete) {
      //   // Normal flow, but data not complete
      //   await _loadProductData();
    } else {
      // Data already loaded, just update state
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _loadProductDataFromUrl(int productId) async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final product = await controller.products.getProductSimple(productId);
      controller.displayProduct.value = product;
    } catch (e) {
      print("Error loading product data: $e");
      setState(() {
        errorMessage = "Failed to load product data. Please try again.";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _loadProductData() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      // reassign the display product with the new data
      controller.displayProduct.value = controller.displayProduct.value;
    } catch (e) {
      print("Error loading product data: $e");
      setState(() {
        errorMessage = "Failed to load product data. Please try again.";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : errorMessage != null
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(errorMessage!),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _initializeProductData,
                child: Text('Retry'),
              ),
            ],
          ),
        )
            : Obx(() => SingleProductPage(
            returnToHome: () {
              controller.vroute.returnToHome();
            },
            simpleProduct: controller.displayProduct.value,
            onSimilarProductSelected: (product) async {
              controller.products.select(product);
              // lets call the sku id
              await _loadProductData();
            },
            onAddToCart: (skuId, quantity, productId) async {
              developer.log('Adding item to cart: $skuId, $quantity');
              await controller.basket.addToCart(
                customerId: controller.user.value.profileId.toString(),
                quantity: quantity,
                product: "$productId-$skuId"
              );
            }
        )),
      ),
    );
  }
}
