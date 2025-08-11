
import 'package:YLift/core/constants/text_style.dart';
import 'package:galaxy_models/galaxy_models.dart';
import 'package:YLift/presentation/components/_complex/desktop_view/panel.dart';
import 'package:YLift/presentation/components/_simple/product_image_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class FreeItemsPanel extends StatelessWidget {
  final List<FreeCartItem> freeItems;
  const FreeItemsPanel({
    super.key,
    required this.freeItems,
  });

  // final global = Get.find<GlobalController>();
  static final _costStyle = GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500, height: 2);
  static final _savedStyle = GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500, color: YLiftColor.green);

  int get freeItemsTotal =>
      freeItems.fold(0, (previousValue, element) => previousValue + (element.tieredPrice * element.quantity));

  @override
  Widget build(BuildContext context) {
    return GalaxyPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Free Items',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 32),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: freeItems.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final freeItem = freeItems[index];
                    return SizedBox(
                      height: 160,
                      child: Row(
                        children: [
                          AspectRatio(
                            aspectRatio: 1,
                            child: ProductImageView(imageUrl: freeItem.imageUrl),
                          ),
                          const SizedBox(width: 24),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  freeItem.productName,
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                if (freeItem.caption != null)
                                  Text(freeItem.caption!, style: YLiftTextStyle.descriptionGrey),
                                const SizedBox(height: 16),
                                Text('YLS-SKU: ${freeItem.skuId}', style: YLiftTextStyle.descriptionGrey),

                                const SizedBox(height: 4),
                                Text('Quantity: ${freeItem.quantity}', style: YLiftTextStyle.descriptionGrey),
                                const SizedBox(height: 4),
                                Text('Unit Price: ${freeItem.tieredPrice.toCurrency()}',
                                    style: YLiftTextStyle.descriptionGrey),

                                // if (sku != null && sku!.isNotEmpty) Text('Sku: $sku', style: YLiftTextStyle.descriptionGrey),
                                // if (description != null) Text(description!, style: YLiftTextStyle.descriptionGrey),

                                // if (shippingQuantities != null)
                                //   Column(
                                //     crossAxisAlignment: CrossAxisAlignment.start,
                                //     children: shippingQuantities!.map(
                                //           (e) {
                                //         final address = optionalAddresses?['${e.shippingAddressId}'];
                                //         if (address == null) return const Text('(No address)');
                                //         return Text(address.display);
                                //       },
                                //     ).toList(),
                                //   )
                                // else if (address != null)
                                //   Text(address!.display),
                                // const Spacer(),
                                // bottomDescription,
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 32),
              SizedBox(
                width: 320,
                child: Column(
                  children: [
                    ...freeItems.map(
                      (freeItem) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(freeItem.productName, style: _costStyle),
                          Text((freeItem.tieredPrice * freeItem.quantity).toCurrency(), style: _costStyle),
                        ],
                      ),
                    ),
                    const Divider(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('You saved:', style: _savedStyle),
                        Text(freeItemsTotal.toCurrency(), style: _savedStyle),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
