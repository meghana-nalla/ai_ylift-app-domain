
import 'package:YLift/presentation/pages/desktop/cart/components/merz_promotion_dialog.dart';
import 'package:galaxy_models/galaxy_models.dart';
import 'package:get/get.dart';

class CartNote {
  final String title;
  final String text;
  const CartNote(this.title, this.text);

  static List<CartNote>? fromJsonList(dynamic value) {
    if(value is! List<dynamic>) return null;
    return value.map((e) => CartNote(e['noteTitle'] ?? '', e['noteText'] ?? '')).toList();
  }
}

class CartSimple {
  String? id;
  String? orderId;
  String? label;
  String? profileId;
  List<CartItemSimple> cartItems;
  List<FreeCartItem> freeItems;
  String type;
  String status;
  int orderTotal;
  int taxTotal; // note .. this is double not int
  int taxTotalAsInteger;
  int shippingTotal;
  int? orderTotalWithPromotion;
  int? discountTotal;
  DateTime? orderDate;
  DateTime createdAt;
  DateTime? updatedAt;
  AddressSimple? shippingAddress;
  Map<String, AddressSimple>? optionalAddress;
  List<String> product = [];
  List<PaymentHistory>? paymentHistory;
  String? customerName;
  String? customerEmail;
  int subTotal;

  List<OrderNote> orderNotes;
  List<OrderNote> brandOrderNotes;
  List<OrderNote> vendorOrderNotes;
  List<OrderNote> productOrderNotes;
  List<OrderNote> skuOrderNotes;

  List<StoreTradeGood> tradeGoods;
  List<VirtualItem> virtualItems;
  List<String> products;

  bool checkOutIsLocked;

  final List<CartNote>? notes;

  bool isMerzItem(CartItemSimple cartItem) => MerzSyringePromotion.productIds.contains(cartItem.productId);

  Iterable<CartItemSimple> get merzItems => cartItems.where((cartItem) => MerzSyringePromotion.productIds.contains(cartItem.productId));
  /// The total quantity of Radiess in cart
  int get merzTotalBoxes => merzItems.map((e) => e.quantity).fold(0, (previousValue, element) => previousValue + element);
  int get merzTotalSyringes => merzTotalBoxes * 2;
  int get merzTotalCost => merzItems.fold(0, (previousValue, element) => previousValue + element.total);

  Iterable<FreeCartItem> get merzFreeItems => freeItems.where((freeItem) => MerzSyringePromotion.productIds.contains(freeItem.productId));
  int get merzTotalFreeQuantity => merzFreeItems.map((e) => e.quantity).fold(0, (previousValue, element) => previousValue + element);
  int get merzTotalFreeSyringes => merzTotalFreeQuantity * 2;

  MerzSyringePromotion? get merzPromotion => MerzSyringePromotion.getPromotion(merzTotalBoxes);
  bool get hasMerzPromotion => merzPromotion != null;
  bool get isMerzPromotionSatisfied => merzTotalFreeSyringes == merzPromotion?.freeSyringes;

  /// The total of the purchased syringes and the free syringes
  int get merzAllSyringes => merzTotalSyringes + (merzPromotion?.freeSyringes ?? 0);
  int get merzSyringeUnitPriceWithPromotion => merzTotalCost ~/ merzAllSyringes;

  bool get bootYliftIncluded => merzTotalSyringes >= 60;

  String? get merzPromotionMessage{
    if(merzItems.isEmpty) return null;
    return MerzSyringePromotion.getMessage(merzTotalBoxes);
  }

  bool get hasRestrictions {
    // final galdermaController = Get.find<GaldermaController>();
    // final hasGaldermaPromotion = galdermaController.currentTierPromotion != null;
    final isNotEmpty = brandOrderNotes.isNotEmpty || vendorOrderNotes.isNotEmpty || productOrderNotes.isNotEmpty || skuOrderNotes.isNotEmpty;
    if(!hasMerzPromotion) return isNotEmpty;
    return isNotEmpty || hasMerzPromotion;
  }

  bool get isCheckoutable {
    if (checkOutIsLocked) return false;
    if (hasMerzPromotion && !isMerzPromotionSatisfied) return false;
    if(cartItems.any((item) => item.hasIssue)) return false;
    return true;
  }




  FreeCartItem? getFreeItemBySkuId(int skuId) {
    return freeItems.firstWhereOrNull((freeItem) => freeItem.skuId == skuId);
  }

  AddressSimple? getCustomShippingAddress(String? addressId){
    if(addressId == null || addressId == 'null') return shippingAddress; // Return default address
    return optionalAddress?[addressId];
  }

  CartSimple({
    this.id,
    this.orderId,
    this.label,
    this.profileId = '',
    this.cartItems = const <CartItemSimple>[],
    this.freeItems = const <FreeCartItem>[],
    this.type = 'CART',
    this.status = "PENDING",
    this.orderTotal = 0,
    this.taxTotal = 0,
    this.taxTotalAsInteger = 0,
    this.shippingTotal = 0,
    this.orderTotalWithPromotion = 0,
    this.discountTotal,
    this.orderDate,
    required this.createdAt,
    this.updatedAt,
    this.shippingAddress,
    this.optionalAddress,
    this.product = const [],
    this.paymentHistory,
    this.customerName,
    this.customerEmail,
    this.subTotal = 0,
    this.orderNotes = const <OrderNote>[],
    this.vendorOrderNotes = const <OrderNote>[],
    this.brandOrderNotes = const <OrderNote>[],
    this.productOrderNotes = const <OrderNote>[],
    this.skuOrderNotes = const <OrderNote>[],
    this.checkOutIsLocked = true,
    this.tradeGoods = const <StoreTradeGood>[],
    this.virtualItems = const <VirtualItem>[],
    this.products = const <String>[],
    this.notes,
  });

  factory CartSimple.empty() {
    return CartSimple(createdAt: DateTime.now());
  }

  factory CartSimple.fromJson(Map<String, dynamic> json) {
    return CartSimple(
      id: json['id']?.toString(),
      orderId: '${json['orderId']}' ?? 'No order ID',
      label: json['label'] ?? 'No label',
      profileId: '${json['profileId'] ?? json['customerId']}' ?? 'No profile id',
      cartItems: (json['cartItems'] as List).map((item) => CartItemSimple.fromJson(item)).toList(),
      freeItems: json['freeItems'] == null ? [] : (json['freeItems'] as List).map((item) => FreeCartItem.fromJson(item)).toList(),
      type: json['type'],
      status: json['status'],
      orderTotal: IntConverter.fromJson(json['orderTotal']),
      orderTotalWithPromotion: IntConverter.fromJson(json['orderTotalWithPromotion']),
      taxTotal: IntConverter.fromJson(json['taxTotal']),
      taxTotalAsInteger: IntConverter.fromJson(json['taxTotalAsInteger']),
      shippingTotal: IntConverter.fromJson(json['shippingTotal']),
      discountTotal: IntConverter.fromJson(json['discountTotal']),
      orderDate: json['orderDate'] != null ? DateTime.parse(json['orderDate']) : null,
      createdAt: DateTime.parse(json['createdAt']) ?? DateTime.now(),
      updatedAt: DateTime.parse(json['updatedAt']) ?? DateTime.now(),
      shippingAddress: json['shippingAddress'] != null ? AddressSimple.fromJson(json['shippingAddress']) : null,
      optionalAddress: AddressSimple.fromMap(json['optionalAddress']),
      product: List<String>.from(json['product'] ?? json['products']),
      paymentHistory: PaymentHistory.fromJsonList(json['paymentHistory']),
      customerName: json['customerName'] ?? 'No name',
      customerEmail: json['customerEmail'] ?? 'no email',
      subTotal: IntConverter.fromJson(json['subTotal']),
      orderNotes: OrderNote.aggregateJson(json),
      vendorOrderNotes: OrderNote.fromList(OrderNoteType.vendor, json['vendorOrderNotes']),
      brandOrderNotes: OrderNote.fromList(OrderNoteType.brand, json['brandOrderNotes']),
      productOrderNotes: OrderNote.fromList(OrderNoteType.product, json['productOrderNotes']),
      skuOrderNotes: OrderNote.fromList(OrderNoteType.sku, json['skuOrderNotes']),
      checkOutIsLocked: json['checkOutIsLocked'] ?? true,
      tradeGoods: StoreTradeGood.fromList(json['tradingMappings']),
      virtualItems: VirtualItem.fromList(json['virtualItems']),
      products: json['products'] == null ? const <String>[] : List<String>.from(json['products']),
      notes: CartNote.fromJsonList(json['notes']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderId': orderId,
      'label': label,
      'profileId': profileId,
      'cartItems': cartItems.map((item) => item.toJson()).toList(),
      'type': type,
      'status': status,
      'orderTotal': orderTotal,
      'taxTotal': taxTotal,
      'taxTotalAsInteger': taxTotalAsInteger,
      'shippingTotal': shippingTotal,
      'discountTotal': discountTotal,
      'orderDate': orderDate?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'shippingAddress': shippingAddress?.toJson(),
      // 'optionalAddress': optionalAddress?.toJson(),
      'product': product,
      'paymentHistory': paymentHistory,
      'customerName': customerName,
      'customerEmail': customerEmail,
      'subTotal': subTotal,
      // 'vendorOrderNotes': vendorOrderNotes,
      // 'brandOrderNotes': brandOrderNotes,
    };
  }

  // get the total order quantity
  int getTotalNumItems() {
    int total = 0;
    for (CartItemSimple item in cartItems) {
      total += item.quantity;
    }

    return total;
  }

  int cartBillablePrice(){
    if(orderTotalWithPromotion != null && orderTotalWithPromotion! > 0){
      return orderTotalWithPromotion!;
    }
    return orderTotal;
  }

  void resetCartBillableToZero(){
    orderTotalWithPromotion = 0;
    orderTotal = 0;
  }
}