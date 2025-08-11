import 'dart:math';
import 'package:YLift/presentation/components/_simple/product_image_view.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:YLift/core/constants/index.dart';
import 'package:YLift/core/constants/color.dart';
import 'package:YLift/core/controllers/global.dart';
import 'package:YLift/core/extensions/price_extension.dart';
import 'package:YLift/presentation/components/z-index_export.dart';
import 'package:galaxy_ui/galaxy_ui.dart';
// TODO : move this dialog to components
import 'package:YLift/presentation/pages/desktop/__primary_shopping/components/quick_reorder_dialog.dart';
//

class QuickReorderSection extends StatefulWidget {
  const QuickReorderSection({super.key});

  @override
  State<QuickReorderSection> createState() => _QuickReorderSectionState();
}

class _QuickReorderSectionState extends State<QuickReorderSection> {
  final global = Get.find<GlobalController>();

  final scrollController = ScrollController();
  bool canScrollToFirst = false;
  void scrollListener() {
    final currentPos = scrollController.position.pixels;
    final maxExtent = scrollController.position.maxScrollExtent;
    setState(() {
      canScrollToFirst = currentPos >= maxExtent - 160;
    });
  }

  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    scrollController.addListener(scrollListener);
  }

  void scrollRight() async {
    var nextPosition = scrollController.position.pixels + 1340;
    final max = scrollController.position.maxScrollExtent;
    if (nextPosition > max) nextPosition = max;
    await scrollController.animateTo(
      nextPosition,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: LinearProgressIndicator(),
      );
    }

    if (global.quickOrders.isEmpty) return Container();
    if (global.quickOrders.length == 1) {
      final order = global.quickOrders[0];
      int _numItems = order.cartItems.length;
      int _price = order.orderTotal;
      String _orderDate = order.createdAt.toIso8601String();
      List<String> orderDateTokens = _orderDate.split('-').take(3).toList();
      String formattedDate = orderDateTokens.join('/');
      var processOrderDate = formattedDate.substring(0, min(10, formattedDate.length));

      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          border: Border.all(color: YLiftColor.grey3),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 48),
        height: 120,
        width: double.infinity,
        child: Row(
          children: [
            // const SizedBox(width: 48),
            CircleAvatar(
              backgroundColor: Color(0xFFF3F4F3),
              child: Icon(Icons.shopping_cart_checkout_outlined),
            ),
            const SizedBox(width: 16),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Quick Reorder', style: TextStyle(fontSize: 23, fontWeight: FontWeight.w600)),
                Text('Ordered on $processOrderDate', style: TextStyle(fontSize: 13.33)),
              ],
            ),
            const SizedBox(width: 64),
            Wrap(
              spacing: 32,
              children: List.generate(
                min(_numItems, 5),
                (index) {
                  return SizedBox.square(
                    dimension: 60,
                    child: ProductImageView(imageUrl: order.cartItems[index].imageUrl),
                  );
                },
              ),
            ),
            const Spacer(),
            Text(
              '$_numItems items • ${_price.toCurrency()}',
              style: TextStyle(color: Color(0xFF787878), fontSize: 13.33),
            ),
            const SizedBox(width: 48),
            SizedBox(
              width: 240,
              child: RoundedFilledButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => QuickReorderDialog(
                      previousOrder: order,
                    ),
                  );
                },
                child: const Text('ORDER AGAIN'),
              ),
            ),
          ],
        ),
      );
    }

    return SizedBox(
      height: 120,
      child: ListView.separated(
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        itemCount: global.quickOrders.length,
        separatorBuilder: (context, index) {
          if (canScrollToFirst) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ArrowButton(
                  direction: ArrowDirection.left,
                  onPressed: () {
                    scrollController.animateTo(
                      0,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    );
                  },
                ),
              ),
            );
          }

          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ArrowButton(
                direction: ArrowDirection.right,
                onPressed: scrollRight,
              ),
            ),
          );
        },
        itemBuilder: (context, index) {
          final order = global.quickOrders[index];

          int _numItems = order.cartItems.length;
          int _price = order.orderTotal;
          String _orderDate = order.createdAt.toIso8601String();
          List<String> orderDateTokens = _orderDate.split('-').take(3).toList();
          String formattedDate = orderDateTokens.join('/');
          var processOrderDate = formattedDate.substring(0, min(10, formattedDate.length));

          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              border: Border.all(color: YLiftColor.grey3),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 48),
            height: 120,
            width: 1280,
            child: Row(
              children: [
                // const SizedBox(width: 48),
                CircleAvatar(
                  backgroundColor: Color(0xFFF3F4F3),
                  child: Icon(Icons.shopping_cart_checkout_outlined),
                ),
                const SizedBox(width: 16),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Quick Reorder', style: TextStyle(fontSize: 23, fontWeight: FontWeight.w600)),
                    Text('Ordered on $processOrderDate', style: TextStyle(fontSize: 13.33)),
                  ],
                ),
                const SizedBox(width: 64),
                Wrap(
                  spacing: 32,
                  children: List.generate(
                    min(_numItems, 5),
                    (index) {
                      return SizedBox.square(
                        dimension: 60,
                        child: ProductImageView(imageUrl: order.cartItems[index].imageUrl),
                      );
                    },
                  ),
                ),
                const Spacer(),
                Text(
                  '$_numItems items • ${_price.toCurrency()}',
                  style: TextStyle(color: Color(0xFF787878), fontSize: 13.33),
                ),
                const SizedBox(width: 48),
                SizedBox(
                  width: 240,
                  child: RoundedFilledButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => QuickReorderDialog(
                          previousOrder: order,
                        ),
                      );
                    },
                    child: const Text('ORDER AGAIN'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
