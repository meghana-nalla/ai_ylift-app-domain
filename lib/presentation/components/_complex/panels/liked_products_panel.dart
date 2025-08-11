import 'package:YLift/presentation/components/z-index_export.dart';
import 'package:flutter/material.dart';
import 'package:YLift/core/constants/color.dart';
import 'package:get/get.dart';
import 'package:YLift/core/constants/index.dart';
import 'package:YLift/core/controllers/global.dart';
import 'package:YLift/models/z-index_export.dart';
import 'package:galaxy_ui/galaxy_ui.dart';

class LikedProductsPanel extends StatefulWidget {
  const LikedProductsPanel({super.key});

  @override
  State<LikedProductsPanel> createState() => _LikedProductsPanelState();
}

class _LikedProductsPanelState extends State<LikedProductsPanel> {
  final GlobalController global = Get.find<GlobalController>();
  List<ProductSimple>? likedProducts;
  bool _isLoading = true;

  Future<void> fetchLikedProducts() async {
    likedProducts = await global.userProfile.updateLikedProducts();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    refreshLikedProducts();
  }

  Future<void> refreshLikedProducts() async {
    setState(() {
      _isLoading = true;
    });

    await fetchLikedProducts();

    setState(() {
      _isLoading = false;
    });

  }

  Future<void> deleteLikedProduct(int? productId) async {
    if (productId == null || likedProducts == null) {
      // throw('Error in LikedProductsPanel.deleteLikedProduct(): productId was null');
      return;
    }
    setState(() {
      likedProducts!.removeWhere((e) => e.productId! == productId);
    });
    await global.products.likeProduct(productId);
    setState(() {
      _isLoading = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return (likedProducts != null && likedProducts!.isNotEmpty)
      ? Padding(
        padding: EdgeInsets.only(bottom: 64.0),
        child: ListView.separated(
        shrinkWrap: true,
        itemCount: likedProducts!.length,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          ProductSimple current = likedProducts![index];
          return Row(
            children: [
              SizedBox.square(
                dimension: 120,
                child: Image.network(
                  current.imageUrl ?? PLACEHOLDER_IMAGE,
                  loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    } else {
                      return Center(
                        child: CircularProgressIndicator(
                          color: const Color.fromRGBO(114, 95, 95, 0.5019607843137255),
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                              (loadingProgress.expectedTotalBytes ?? 1)
                              : null,
                        ),
                      );
                    }
                  },
                  errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                    return Icon(Icons.error);
                  },
                ),
              ),
              const SizedBox(width: 24),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    current.name,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    current.caption ?? '',
                    style: TextStyle(color: YLiftColor.grey3),
                  ),
                ],
              ),
              const Spacer(),
              OutlinedButton(
                onPressed: () async {
                  try {
                    await deleteLikedProduct(current.productId);
                  } catch(e) {
                    print('An internal error occurred: $e');
                    return;
                  }
                },
                child: const Text('Delete'),
              ),
              const SizedBox(width: 16),
              SizedBox(
                width: 160,
                child: RoundedFilledButton(
                  onPressed: () async {
                    await global.basket.addToCart(
                      customerId: global.user.value.profileId.toString(),
                      quantity: 1,
                      product: "${current.productId}-${current.skus!.first.skuId}",
                    );
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('${current.name} added to cart!'))
                    );
                  },
                  child: const Text('Add to Cart'),
                ),
              ),
            ],
          );
        },
            ),
      )
    : Center(
        child: Container(
          height: 500,
          width: 500,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.heart_broken,
                size: 100,
              ),
              const SizedBox(height: 8),
              const Text('No liked products',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24
              )),
              const SizedBox(height: 24,),
              SizedBox(
                height: 50,
                width: 200,
                child: YLiftFilledButton(
                  onPressed: () async => await global.vroute.navigateTo('/shop'),
                  child: const Text('Continue to shop')
                ),
              )
            ],
          )
        ),
    ) ;
  }
}
