import 'dart:async';

import 'package:YLift/core/constants/color.dart';
import 'package:YLift/core/constants/text_style.dart';
import 'package:YLift/core/controllers/global.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../models/api/product_brand.dart';

class ShopBrands extends StatelessWidget {
  const ShopBrands({super.key});

  @override
  Widget build(BuildContext context) {
    // controller
    GlobalController controller = Get.find<GlobalController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Shop Brands', style: YLiftTextStyle.subtitle2),
        const SizedBox(height: 8),
        Row(
          children: [
            SizedBox(
              width: 240,
              child: CollapsibleBrandList(controller: controller),
            ),
            // ),
          ],
        ),
      ],
    );
  }
}

class BrandNameButton extends StatelessWidget {
  final String name;
  final void Function() onPressed;
  const BrandNameButton({
    super.key,
    required this.name,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      hoverColor: YLiftColor.beige,
      borderRadius: const BorderRadius.all(Radius.circular(4)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(name, style: TextStyle(fontSize: 16)),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}

class CollapsibleBrandList extends StatefulWidget {
  final GlobalController controller;

  const CollapsibleBrandList({
    super.key,
    required this.controller,
  });

  @override
  _CollapsibleBrandListState createState() => _CollapsibleBrandListState();
}

class _CollapsibleBrandListState extends State<CollapsibleBrandList> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    // Determine the number of brands to display
    const int displayLimit = 6;
    final List<ProductBrand> displayedBrands =
        _isExpanded ? widget.controller.brands : widget.controller.brands.take(displayLimit).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Dynamically generate the brand buttons
        ...List.generate(
          displayedBrands.length,
          (index) {
            return BrandNameButton(
              name: displayedBrands[index].name,
              onPressed: () {
                // Logic for when the brand button is pressed
                widget.controller.selectedBrand.value = displayedBrands[index];
                widget.controller.vroute.navigateTo('/shop/brands');
              },
            );
          },
        ),
        // Show "Show All" or "Show Less" button depending on the state
        if (widget.controller.brands.length > displayLimit)
          TextButton(
            onPressed: () {
              widget.controller.vroute.navigateTo('/shop/all_brands');
            },
            child: Text(
              _isExpanded ? 'Show Less' : 'Show All >>',
              style: const TextStyle(
                decoration: TextDecoration.underline,
                color: Colors.black,
              ),
            ),
          ),
      ],
    );
  }
}
