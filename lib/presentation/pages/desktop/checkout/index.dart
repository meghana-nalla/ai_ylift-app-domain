import 'package:YLift/core/constants/constant.dart';
import 'package:YLift/core/constants/text_style.dart';
import 'package:YLift/models/simple/home_promotion_banner_data.dart';
import 'package:YLift/models/z-index_export.dart';
import 'package:YLift/presentation/components/z-index_export.dart';
import 'package:YLift/presentation/pages/desktop/checkout/components/place_order_btn.dart';
import 'package:YLift/presentation/pages/desktop/checkout/components/store_credit_toggle_tile.dart';
import 'package:flutter/material.dart';
import 'package:galaxy_ui/galaxy_ui.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:YLift/core/controllers/global.dart';
import 'package:galaxy_models/galaxy_models.dart';

/// the actual widget
class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final controller = Get.find<GlobalController>();

  AddressSimple? defaultAddress;
  late List<CartItemSimple> cartItems;

  PaymentMethod selectedPaymentMethod = PaymentMethod.credit;
  final NumberFormat currencyFormat = NumberFormat.currency(symbol: '\$');

  CardPayment? cardPayment;
  void setCardPayment(CardPayment card) {
    setState(() {
      cardPayment = card;
    });
  }

  List<dynamic>? paymentMethods;

  int? storeCreditBalance;

  int get orderTotal {
    var orderTotal = controller.simpleCart.value.orderTotal - (controller.simpleCart.value.discountTotal ?? 0);
    if (storeCreditBalance != null) orderTotal -= storeCreditBalance!;

    return orderTotal;
  }

  void setInitialCard() {
    // Get card from payment history if there is a pending payment
    final userWallet = controller.user.value.wallet ?? <CardPayment>[];
    final cardId =
        controller.simpleCart.value.paymentHistory
            ?.firstWhereOrNull((history) => history.paymentStatus == 'PENDING')
            ?.cardId;
    cardPayment = userWallet.firstWhereOrNull((card) => card.id == cardId);

    // If no pending payment, get the default card or any non-expired card
    final defaultCard = userWallet.firstWhereOrNull(
      (card) => card.isDefault && !card.isExpired,
    );
    cardPayment ??= defaultCard;
    cardPayment ??= userWallet.firstWhereOrNull((card) => !card.isExpired);
    print(cardPayment?.id);
    setState(() {});
  }

  Future<void> _applyStoreCreditAutomatically() async {
    final global = Get.find<GlobalController>();
    final balance = await global.userController.getStoreCreditBalance();

    if (balance != null && balance > 0) {
      setState(() {
        // Convert to cents if needed
        storeCreditBalance = balance * 100;
      });
    }
  }

  @override
  void initState() {
    setInitialCard();
    _applyStoreCreditAutomatically();
    super.initState();
  }

  void init() async {
    await global.basket.showAdditionalAddresses();
  }

  static final costStyle = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  @override
  Widget build(BuildContext context) {
    return GalaxyPageScaffold(
      showGalaxyFooter: false,
      children: [
        Row(
          children: [
            BackButton(
              onPressed: () {
                controller.vroute.navigateTo('/order/cart');
              },
            ),
            const Text('Checkout', style: YLiftTextStyle.title),
          ],
        ),
        const Divider(height: 50),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// this widget receives the shipping information
                  const Gap(),
                  if (false) ...[
                    if (controller.simpleCart.value.cartItems.isNotEmpty) ...[
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: controller.simpleCart.value.cartItems.length,
                        itemBuilder: (context, index) {
                          final cartItem =
                              controller.simpleCart.value.cartItems[index];
                          return Column(
                            children: [
                              Row(
                                children: [
                                  SizedBox.square(
                                    dimension: 80,
                                    child: YLiftImage(
                                      imageUrl: cartItem.imageUrl,
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        cartItem.productName,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ],
                  Text('Shipping to address:', style: YLiftTextStyle.bodyLarge),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Text(
                        controller.simpleCart.value.shippingAddress?.name ??
                            'no name',
                      ),
                      const SizedBox(height: 10),
                      Text(
                        controller.simpleCart.value.shippingAddress?.line1 ??
                            'no address',
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '${controller.simpleCart.value.shippingAddress?.city}, ${controller.simpleCart.value.shippingAddress?.state} ${controller.simpleCart.value.shippingAddress?.zip}',
                      ),
                    ],
                  ),
                  if (controller.basket.hasAdditionalAddresses.value) ...[
                    const SizedBox(height: 10),
                    Text('+ additional addresses'),
                  ],
                  const GapY(factor: 2),
                  Row(
                    children: [
                      Text('Payment :', style: YLiftTextStyle.bodyLarge),
                      const Spacer(),
                      YLiftFilledButton(
                        child: const Text('Add New Payment Method'),
                        onPressed: () {
                          showDialog<CardPayment>(
                            context: context,
                            builder: (context) {
                              return CardPaymentDialog(
                                updateWalletPanel: () {
                                  // setState(() {
                                  //   cardPayments = global.userCardPayments;
                                  // });
                                },
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: YLiftConstant.gap),
                  CardPaymentListView(
                    selectedCard: cardPayment,
                    onSelected: setCardPayment,
                  ),
                  const SizedBox(height: 32),
                  StoreCreditToggleTile(
                    value: storeCreditBalance != null,
                    onChanged: (value) {
                      setState(() {
                        storeCreditBalance = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            const SizedBox(width: YLiftConstant.gap),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  CostRow(
                    'Subtotal',
                    controller.simpleCart.value.subTotal,
                    style: costStyle,
                  ),
                  const SizedBox(height: 16),
                  CostRow(
                    'Sales tax',
                    controller.simpleCart.value.taxTotalAsInteger,
                    style: costStyle,
                  ),
                  const SizedBox(height: 16),
                  CostRow(
                    'Shipping cost',
                    controller.simpleCart.value.shippingTotal,
                    style: costStyle,
                  ),
                  if(controller.simpleCart.value.discountTotal != null &&
                    (controller.simpleCart.value.discountTotal ?? 0) > 0) ...[
                    const SizedBox(height: 16),
                    CostRow(
                      'Discount Savings 💸',
                      - controller.simpleCart.value.discountTotal!,
                      style: costStyle.copyWith(color: Colors.green),
                    ),
                  ],
                  if (storeCreditBalance != null) ...[
                    const SizedBox(height: 16),
                    CostRow(
                      'Store Credit',
                      -storeCreditBalance!,
                      style: costStyle.copyWith(color: Colors.green),
                    ),
                  ],

                  const Divider(height: 32),
                  CostRow(
                    'Order Total',
                    orderTotal,
                    style: costStyle.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  PlaceOrderButton(
                    cardPayment: cardPayment,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 400),
      ],
    );
  }
}

class CardPaymentListView extends StatefulWidget {
  final CardPayment? selectedCard;
  final void Function(CardPayment card) onSelected;
  final EdgeInsets padding;

  const CardPaymentListView({
    super.key,
    this.selectedCard,
    required this.onSelected,
    this.padding = const EdgeInsets.all(YLiftConstant.gap),
  });

  @override
  State<CardPaymentListView> createState() => _CardPaymentListViewState();
}

class _CardPaymentListViewState extends State<CardPaymentListView> {
  final global = Get.find<GlobalController>();

  String? errorMessage;

  @override
  void initState() {
    super.initState();
    if (!global.isAuthenticated.value) {
      global.vroute.navigateTo('/login', redirectPath: '/order/cart');
    }
    errorMessage = null;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return GalaxyPanel(
        padding: widget.padding,
        child:
            global.user.value.wallet!.isEmpty
                ? const Text(
                  'Hmm.. we could not find your saved cards, please try again later',
                )
                : Material(
                  color: Colors.transparent,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: global.user.value.wallet!.length,
                    itemBuilder: (context, index) {
                      final cardPayment = global.user.value.wallet![index];
                      final isSelected =
                          widget.selectedCard?.id == cardPayment.id;

                      final expirationDate =
                          '${cardPayment.expirationDate?.month}/${cardPayment.expirationDate?.year}';

                      return ListTile(
                        onTap:
                            cardPayment.isExpired
                                ? null
                                : () => widget.onSelected(cardPayment),
                        leading: PaymentMarkIcon(cardPayment.cardType),
                        title: Text(
                          '${cardPayment.cardType} Card ending with ****${cardPayment.last4}',
                        ),
                        subtitle: Row(
                          children: [
                            Text(
                              cardPayment.isExpired
                                  ? 'Expired on $expirationDate'
                                  : 'Expires on $expirationDate',
                              style: TextStyle(
                                fontSize: 11.11,
                                color:
                                    cardPayment.isExpired
                                        ? YLiftColor.orange
                                        : Colors.black54,
                                fontWeight:
                                    cardPayment.isExpired
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                              ),
                            ),
                            if (cardPayment.isDefault) ...const [
                              SizedBox(width: 8),
                              Icon(
                                Icons.circle,
                                size: 6,
                                color: Colors.black26,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Default',
                                style: TextStyle(
                                  fontSize: 11.11,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ],
                        ),
                        trailing:
                            isSelected
                                ? const Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                )
                                : null,
                      );
                    },
                  ),
                ),
      );
    });
  }
}
