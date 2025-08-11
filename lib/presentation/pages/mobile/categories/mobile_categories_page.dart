import 'package:YLift/core/controllers/global.dart';
import 'package:YLift/presentation/components/mobile_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MobileCategoriesPage extends StatefulWidget {
  const MobileCategoriesPage({super.key});

  @override
  State<MobileCategoriesPage> createState() => _MobileCategoriesPageState();
}

class _MobileCategoriesPageState extends State<MobileCategoriesPage> {
  final global = Get.find<GlobalController>();

  void goToShopAll(int categoryId) {
    final queryParameters = <String, String>{
      'categoryIds': '$categoryId',
    };
    final uri = Uri(path: '/shop/all', queryParameters: queryParameters);
    global.vroute.navigateTo('$uri');
  }

  @override
  Widget build(BuildContext context) {
    return MobileScaffold(
      onBackPressed: () => Navigator.pop(context),
      title: 'Categories',
      body: GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 3 / 4.4,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
        ),
        itemCount: global.categories.length,
        itemBuilder: (context, index) {
          final category = global.categories[index];
          return GestureDetector(
            onTap: () => goToShopAll(category.categoryId),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(8)),
              ),
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  Image.network(
                    category.imageUrl,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset('msc/images/Placeholder_Product.png');
                    },
                  ),
                  const SizedBox(height: 8),
                  Text(
                    category.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
