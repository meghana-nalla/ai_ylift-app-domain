import 'package:YLift/core/constants/constant.dart';
import 'package:YLift/core/constants/index.dart';
import 'package:YLift/core/constants/text_style.dart';
import 'package:YLift/presentation/components/z-index_export.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:YLift/core/controllers/global.dart';
import 'package:http/http.dart' as http;

import 'desktop_view/page_scaffold.dart';

class DesktopDynamicGridPage extends StatefulWidget {
  const DesktopDynamicGridPage({
    super.key,
    required this.pageType,
  });

  final String pageType;

  // TODO: inject global controller

  @override
  State<StatefulWidget> createState() => _DesktopDynamicGridPageState();

}

class _DesktopDynamicGridPageState extends State<DesktopDynamicGridPage> {

  final GlobalController controller = Get.find<GlobalController>();

  String _titleText = 'Browse';
  List<dynamic> _listToDisplay = [];
  bool _isLoading = true;

  // determine what products to show
  Future <void> setPageContent(String type) async {
    _listToDisplay = [];
    switch(type) {
      case 'categories':
        _listToDisplay = await controller.quick.fetchCategoryLinksById(controller.selectedCategory.value.id.toString());
        _titleText = controller.selectedCategory.value.name;
        break;
      case 'brands':
        print("Selected brand: ${controller.selectedBrand.value.name}");
        print("Selected brand id: ${controller.selectedBrand.value.brandId}");
        print("Current route: ${Get.currentRoute}");
        if(controller.selectedBrand.value.brandId == null && Get.currentRoute.contains("brands")){
          String brandName = Get.currentRoute.split("/").last;
          int brandId = 0;
          print("Brand name: $brandName");
          for(int i = 0; i < controller.brands.length; i++){
            if(controller.brands[i].safeBrandName!.toLowerCase() == brandName){
              brandId = controller.brands[i].brandId ?? 0;
              controller.selectedBrand.value = controller.brands[i];
              break;
            }
          }
        }
        if (controller.selectedBrand.value.brandId == null)controller.vroute.returnToHome();
        _listToDisplay = await controller.quick.fetchBrandLinksById(controller.selectedBrand.value.brandId ?? -1);
        _titleText = controller.selectedBrand.value.name;
        break;
      case 'search':
        _listToDisplay = controller.dynamicProducts;
        _titleText = 'Results for ${controller.recentSearchQuery}';
        break;
      default:
        _titleText = 'Unspecified grid page type';
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    init();
  }

  void init() async {
    await setPageContent(widget.pageType);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GalaxyPageScaffold(
      children: [
        Text(_titleText, style: YLiftTextStyle.title),
        Center(
          child: _buildContent(),
        )
      ],
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return Column(
        children: [
          Text(
            'Loading $_titleText...',
            style: const TextStyle(fontSize: 18.0),
          ),
        ],
      );
    }

    if (_listToDisplay.isEmpty) {
      return Text(
        'No items found',  // Better than empty text
        style: const TextStyle(fontSize: 18.0),
      );
    }

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: YLiftConstant.gap,
      runSpacing: YLiftConstant.gap,
      children: buildProductTiles(),
    );
  }

  List<Widget> buildProductTiles() {
    return List.generate(
    _listToDisplay.length,
    (index) {
      return SizedBox(
        width: 240,
          height: 240,
          child: CategoryProductCardGrid(
          name: _listToDisplay[index].name,
          imageUrl: _listToDisplay[index].imageUrl,
          onTap: () => controller.vroute.navigateToProduct(_listToDisplay[index].productId),
        ));
    });
  }
}

class CategoryProductCardGrid extends StatefulWidget {
  final String name;
  final String? discountPrice;
  final bool isHot;

  final bool isLiked;
  final void Function()? onLiked;
  final void Function()? onTap;
  final bool hasNetworkPricing;
  final String? imageUrl;

  const CategoryProductCardGrid({
    super.key,
    required this.name,
    this.isHot = false,
    this.isLiked = false,
    this.onLiked,
    this.onTap,
    this.hasNetworkPricing = false,
    this.discountPrice,
    this.imageUrl,
  });

  @override
  State<StatefulWidget> createState() =>
      _CategoryProductCardGridState();
}

class _CategoryProductCardGridState extends State<CategoryProductCardGrid>  {

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.onTap!();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            widget.imageUrl!,
            errorBuilder: (context, error, stackTrace) {
              return Image.network(PLACEHOLDER_IMAGE);
            },
          ),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.name, style: YLiftTextStyle.bodyLarge),
              const SizedBox(height: 4),
            ],
          ),
        ],
      ),
    );
  }
}
