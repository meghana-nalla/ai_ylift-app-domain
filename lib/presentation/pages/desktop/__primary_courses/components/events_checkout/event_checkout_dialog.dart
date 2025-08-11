import 'package:YLift/core/controllers/carts/index.dart';
import 'package:YLift/core/controllers/global.dart';
import 'package:galaxy_models/galaxy_models.dart';
import 'package:YLift/models/_clean/training_event_data.dart';
import 'package:YLift/models/z-index_export.dart';
import 'package:YLift/presentation/pages/desktop/__primary_courses/components/events_checkout/event_tile.dart';
import 'package:YLift/presentation/pages/desktop/__primary_courses/components/simple_quantity_dropdown.dart';
import 'package:YLift/presentation/pages/desktop/__primary_courses/components/video_checkout/blue_rounded_button.dart';
import 'package:YLift/presentation/pages/desktop/cart/components/merz_promotion_dialog.dart';
import 'package:flutter/material.dart';
// import 'package:galaxy_ui/galaxy_ui.dart';
import 'package:get/get.dart';

part 'bottom_step_bar.dart';

enum EventsCheckoutStep {
  chooseProduct(
    label: 'Choose your Radiesse',
    buttonLabel: 'Save to Proceed Step 2',
    stepMessage:
    'Add minimum of 20 boxes to unlock video course and get free extra boxes.',
  ),
  chooseRewards(
    label: 'Select Rewards',
    buttonLabel: 'Save and Review Info',
    stepMessage: 'Step 2: Choose your 7 free boxes',
  ),
  checkout(
    label: 'Checkout',
    buttonLabel: 'Add to Cart',
    stepMessage: 'Step 3: Review Your Products and Free Gifts',
  );

  final String label;
  final String stepMessage;
  final String buttonLabel;

  const EventsCheckoutStep({
    required this.label,
    required this.stepMessage,
    required this.buttonLabel,
  });
}

class EventCheckoutDialog extends StatefulWidget {
  // final VirtualProduct product;
  final String? virtualProductId;

  const EventCheckoutDialog({
    super.key,
    this.virtualProductId,
  });

  @override
  State<EventCheckoutDialog> createState() => _EventCheckoutDialogState();
}

class _EventCheckoutDialogState extends State<EventCheckoutDialog> {
  final global = Get.find<GlobalController>();
  EventsCheckoutStep currentStep = EventsCheckoutStep.chooseProduct;

  TrainingEventData selectedEvent = TrainingEventData.examples.first;

  AddressSimple? get shippingAddress => global.simpleCart.value.shippingAddress;
  CartSimple get cart => global.simpleCart.value;

  // 450 2022
  ProductSimple get radiesseProduct => global.allProducts.value.getById(450)!;

  ProductSimple get radiessePlusProduct =>
      global.allProducts.value.getById(449)!;

  @override
  void initState() {
    selectedEvent = TrainingEventData.examples.firstWhere(
          (event) => event.id == widget.virtualProductId,
      orElse: () => TrainingEventData.examples.first,
    );
    super.initState();
  }

  // Step 1
  int radiesseQuantity = 0;
  int radiessePlusQuantity = 0;
  int get sharedMaxQuantity =>
      // widget.product.tradingMetadata!.requirementQuantity -
  selectedEvent.minimumQuantity - radiesseQuantity - radiessePlusQuantity;

  int get quantityLeft =>
      selectedEvent.minimumQuantity - radiesseQuantity - radiessePlusQuantity;

  // Step 2
  int radiesseFreeQuantity = 0;
  int radiesseFreePlusQuantity = 0;
  MerzSyringePromotion? get merzSyringePromotion =>
      MerzSyringePromotion.getPromotion(
        radiesseQuantity + radiessePlusQuantity,
      );
  int get sharedMaxFreeQuantity {
    final merzPromotion = MerzSyringePromotion.getPromotion(
      radiesseQuantity + radiessePlusQuantity,
    );
    if (merzPromotion == null) return 0;

    return merzPromotion.freeBoxes -
        radiesseFreeQuantity -
        radiesseFreePlusQuantity;
  }

  bool get allowNextStep {
    switch (currentStep) {
      case EventsCheckoutStep.chooseProduct:
        return radiesseQuantity + radiessePlusQuantity >=
            selectedEvent.minimumQuantity;
      case EventsCheckoutStep.chooseRewards:
        return radiesseFreeQuantity + radiesseFreePlusQuantity ==
            merzSyringePromotion!.freeBoxes;
      case EventsCheckoutStep.checkout:
        return true;
    }
  }

  void nextStep() {
    if (currentStep == EventsCheckoutStep.checkout) {
      addToCart();
      return;
    }
    setState(() {
      final nextIndex = EventsCheckoutStep.values.indexOf(currentStep) + 1;
      currentStep = EventsCheckoutStep.values[nextIndex % 3];
    });
  }

  bool isAddingToCart = false;
  bool isSuccessful = false;
  String? errorMessage;

  void addToCart() async {
    try {
      setState(() {
        isAddingToCart = true;
      });

      // Step 1
      final profileId = global.user.value.profileId;
      final lastMinuteItems = [
        LastMinuteItem(
          radiesseProduct.skus!.first.combinedId,
          radiesseQuantity,
        ),
        LastMinuteItem(
          radiessePlusProduct.skus!.first.combinedId,
          radiessePlusQuantity,
        ),
      ];

      await global.basket.addVirtualItemToCart(
        virtualProductId: selectedEvent.id,
        lastMinuteItems: lastMinuteItems,
      );

      // Step 2
      await global.basket.addFreeItem(
        product: radiesseProduct.skus!.first.combinedId,
        quantity: radiesseFreeQuantity,
      );
      await global.basket.addFreeItem(
        product: radiessePlusProduct.skus!.first.combinedId,
        quantity: radiesseFreePlusQuantity,
      );

      // Update the success state first to show feedback to the user
      setState(() {
        isSuccessful = true;
      });

      // Show success message with a short delay before navigating
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Course and products added to cart successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      // Refresh cart state to trigger UI updates in other parts of the app
      global.simpleCart.refresh();

      // Navigate to cart page after a short delay for better UX
      Future.delayed(Duration(milliseconds: 1000), () {
        global.vroute.navigateTo('/order/cart');
      });
    } catch (e) {
      errorMessage = '$e';
    } finally {
      setState(() {
        isAddingToCart = false;
      });
    }
  }

  void getPricesForItems() async {
    final item1 = Item(
      product:
      '${radiesseProduct.productId}-${radiesseProduct.skus!.first.skuId}',
      quantity: radiesseQuantity,
    );
    final item2 = Item(
      product:
      '${radiessePlusProduct.productId}-${radiessePlusProduct.skus!.first.skuId}',
      quantity: radiessePlusQuantity,
    );
    final request = BundleProductsPricesRequest(
      items: [item1, item2],
      addressId: shippingAddress?.addressId ?? '',
    );
    await global.products.getTradingProductsPrices(request);

    setState(() {});
  }

  String get stepMessage {
    switch (currentStep) {
      case EventsCheckoutStep.chooseProduct:
        if (quantityLeft <= 0) {
          return 'You selected the ${selectedEvent.title}. You\'re all set with product selections.';
        }
        return 'You selected the ${selectedEvent.title}. Add $quantityLeft more to unlock training & rewards.';
      case EventsCheckoutStep.chooseRewards:
        if (radiesseFreeQuantity + radiesseFreePlusQuantity ==
            (merzSyringePromotion?.freeBoxes ?? 0)) {
          return 'You\'re all set with rewards selection.';
        }
        return 'Select your ${merzSyringePromotion?.freeBoxes ?? 0} free products.';
      case EventsCheckoutStep.checkout:
        return 'Step 3: Review Your Products and Free Gifts.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: SizedBox(
        width: 1080,
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(
                    'Day Selection',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.clear),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:
                TrainingEventData.examples
                    .map(
                      (trainingEvent) => EventTile(
                    imageUrl: trainingEvent.speakerImageUrl,
                    title: trainingEvent.title,
                    unlockMessage: trainingEvent.unlockMessage,
                    isSelected: selectedEvent == trainingEvent,
                    additionalMessage: trainingEvent.additionalMessage,
                    onTap: () {
                      if (currentStep !=
                          EventsCheckoutStep.chooseProduct) {
                        return;
                      }
                      setState(() {
                        selectedEvent = trainingEvent;
                      });
                    },
                  ),
                )
                    .toList(),
              ),

              const SizedBox(height: 32),
              IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (currentStep == EventsCheckoutStep.chooseProduct) ...[
                      RadiesseProductView(
                        name: radiesseProduct.name,
                        imageUrl: radiesseProduct.imageUrl,
                        price:
                        radiesseProduct.skus!.first.tieredPrice
                            .toCurrency(),
                        skuAttributes:
                        radiesseProduct.skus!.first.attributeName,
                        quantity: radiesseQuantity,
                        // maxQuantity: sharedMaxQuantity + radiesseQuantity,
                        onQuantityChanged: (quantity) {
                          setState(() {
                            radiesseQuantity = quantity;
                          });
                          getPricesForItems();
                        },
                      ),

                      RadiesseProductView(
                        name: radiessePlusProduct.name,
                        imageUrl: radiessePlusProduct.imageUrl,
                        price:
                        radiessePlusProduct.skus!.first.tieredPrice
                            .toCurrency(),
                        skuAttributes:
                        radiessePlusProduct.skus!.first.attributeName,
                        quantity: radiessePlusQuantity,
                        // maxQuantity: sharedMaxQuantity + radiessePlusQuantity,
                        onQuantityChanged: (quantity) {
                          setState(() {
                            radiessePlusQuantity = quantity;
                          });
                          getPricesForItems();
                        },
                      ),
                    ] else if (currentStep ==
                        EventsCheckoutStep.chooseRewards) ...[
                      RadiesseProductView(
                        name: radiesseProduct.name,
                        imageUrl: radiesseProduct.imageUrl,
                        price:
                        radiesseProduct.skus!.first.tieredPrice
                            .toCurrency(),
                        skuAttributes:
                        radiesseProduct.skus!.first.attributeName,
                        quantity: radiesseFreeQuantity,
                        maxQuantity:
                        sharedMaxFreeQuantity + radiesseFreeQuantity,
                        isReward: true,
                        onQuantityChanged: (quantity) {
                          setState(() {
                            radiesseFreeQuantity = quantity;
                          });
                        },
                      ),

                      RadiesseProductView(
                        name: radiessePlusProduct.name,
                        imageUrl: radiessePlusProduct.imageUrl,
                        price:
                        radiessePlusProduct.skus!.first.tieredPrice
                            .toCurrency(),
                        skuAttributes:
                        radiessePlusProduct.skus!.first.attributeName,
                        quantity: radiesseFreePlusQuantity,
                        maxQuantity:
                        sharedMaxFreeQuantity + radiesseFreePlusQuantity,
                        isReward: true,
                        onQuantityChanged: (quantity) {
                          setState(() {
                            radiesseFreePlusQuantity = quantity;
                          });
                        },
                      ),
                    ] else if (currentStep == EventsCheckoutStep.checkout) ...[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Purchased (${radiesseQuantity + radiessePlusQuantity})',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              height: 80,
                              child: Row(
                                children: [
                                  AspectRatio(
                                    aspectRatio: 1,
                                    child: Image.network(
                                      radiesseProduct.imageUrl,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        radiesseProduct.name,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        radiesseProduct
                                            .skus!
                                            .first
                                            .attributeName!,
                                        style: TextStyle(fontSize: 11.11),
                                      ),
                                      const Spacer(),
                                      Text(
                                        'Quantity: $radiesseQuantity',
                                        style: TextStyle(
                                          fontSize: 13.33,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              height: 80,
                              child: Row(
                                children: [
                                  AspectRatio(
                                    aspectRatio: 1,
                                    child: Image.network(
                                      radiessePlusProduct.imageUrl,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        radiessePlusProduct.name,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        radiessePlusProduct
                                            .skus!
                                            .first
                                            .attributeName!,
                                        style: TextStyle(fontSize: 11.11),
                                      ),
                                      const Spacer(),
                                      Text(
                                        'Quantity: $radiessePlusQuantity',
                                        style: TextStyle(
                                          fontSize: 13.33,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Free Gifts (${radiesseFreeQuantity + radiesseFreePlusQuantity})',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              spacing: 16,
                              children: [
                                Badge(
                                  alignment: Alignment.topLeft,
                                  backgroundColor: Colors.blue,
                                  padding: const EdgeInsets.all(4),
                                  label: Text('$radiesseFreeQuantity'),
                                  offset: Offset(-4, 0),
                                  child: SizedBox.square(
                                    dimension: 80,
                                    child: Image.network(
                                      radiesseProduct.imageUrl,
                                    ),
                                  ),
                                ),
                                Badge(
                                  alignment: Alignment.topLeft,
                                  backgroundColor: Colors.blue,
                                  label: Text('$radiesseFreePlusQuantity'),
                                  padding: const EdgeInsets.all(4),
                                  offset: Offset(-4, 0),
                                  child: SizedBox.square(
                                    dimension: 80,
                                    child: Image.network(
                                      radiessePlusProduct.imageUrl,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],

                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade200),
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      width: 360,
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (shippingAddress != null) ...[
                            Text(
                              'Free Shipping',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              shippingAddress!.display,
                              style: TextStyle(fontSize: 13.33),
                            ),
                          ],

                          const SizedBox(height: 16),
                          Expanded(
                            child: Obx(
                                  () => Column(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Order Summary',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  // const SizedBox(height: 4),
                                  _infoText(
                                    'Subtotal',
                                    global.bundleProductPrices.value.subTotal
                                        ?.toCurrency() ??
                                        'N/A',
                                  ),
                                  // const SizedBox(height: 4),
                                  _infoText(
                                    'Estimated Tax',
                                    global.bundleProductPrices.value.totalTax
                                        ?.toCurrency() ??
                                        'N/A',
                                  ),
                                  // const SizedBox(height: 4),
                                  _infoText(
                                    'Estimated Shipping',
                                    global
                                        .bundleProductPrices
                                        .value
                                        .totalShipping
                                        ?.toCurrency() ??
                                        'N/A',
                                  ),
                                  // const SizedBox(height: 4),
                                  // _infoText('Discount', '0.00'),
                                  Divider(height: 32),
                                  _infoText(
                                    'Estimated Item(s) Total',
                                    global.bundleProductPrices.value.total
                                        ?.toCurrency() ??
                                        'N/A',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              if (errorMessage != null)
                Text(
                  errorMessage!,
                  style: TextStyle(color: Colors.red, fontSize: 13.33),
                ),

              BottomStepBar(
                step: currentStep,
                extraMessage: stepMessage,
                actions: [
                  FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: YLiftColor.maroon,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.white70,
                      shape: const StadiumBorder(),
                    ),
                    onPressed:
                    allowNextStep && !isAddingToCart ? nextStep : null,
                    child:
                    currentStep == EventsCheckoutStep.checkout
                        ? const Text('Add to Cart')
                        : const Text('Proceed Next'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoText(
      String label,
      String value, {
        TextStyle style = const TextStyle(fontSize: 13.33),
      }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [Text('$label:', style: style), Text(value, style: style)],
    );
  }
}

class RadiesseProductView extends StatelessWidget {
  final String name;
  final String? skuAttributes;
  final String imageUrl;
  final String price;

  final int quantity;
  final int maxQuantity;
  final void Function(int quantity) onQuantityChanged;

  final bool isReward;

  const RadiesseProductView({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.price,
    this.skuAttributes,
    required this.quantity,
    this.maxQuantity = 200,
    required this.onQuantityChanged,
    this.isReward = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 240,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox.square(
            dimension: 240,
            child: Stack(
              children: [
                Image.network(imageUrl),
                if (isReward)
                  Positioned(
                    top: 16,
                    left: 16,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Icon(
                        Icons.redeem_outlined,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
          if (skuAttributes != null)
            Text(
              skuAttributes!,
              style: TextStyle(fontSize: 13.33),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade200),
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            child: Row(
              children: [
                const SizedBox(width: 12),
                Text(price, style: TextStyle(fontWeight: FontWeight.bold)),
                const Spacer(),
                Text(
                  'Quantity:',
                  style: TextStyle(
                    fontSize: 11.11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                SimpleQuantityDropdown(
                  value: quantity,
                  maxQuantity: maxQuantity,
                  onChanged: onQuantityChanged,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
