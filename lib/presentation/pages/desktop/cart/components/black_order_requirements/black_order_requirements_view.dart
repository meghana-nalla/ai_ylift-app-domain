import 'package:YLift/core/controllers/global.dart';
import 'package:galaxy_models/galaxy_models.dart';
import 'package:YLift/models/simple/z-index_export.dart';
import 'package:YLift/presentation/components/_complex/dialogs/mix_match_dialog.dart';
import 'package:YLift/presentation/pages/desktop/cart/components/black_order_requirements/order_note_view.dart';
import 'package:YLift/hardcodes/promotions/practice_luxury/new_practice_luxury_order_rule.dart';
import 'package:YLift/presentation/pages/desktop/cart/components/merz_order_rule.dart';
import 'package:YLift/presentation/pages/desktop/cart/components/merz_promotion/new_merz_order_rule.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BlackOrderRequirementsView extends StatefulWidget {
  final List<OrderNote> orderNotes;
  const BlackOrderRequirementsView({super.key, required this.orderNotes});

  @override
  State<BlackOrderRequirementsView> createState() =>
      _BlackOrderRequirementsViewState();
}

class _BlackOrderRequirementsViewState
    extends State<BlackOrderRequirementsView> {
  final global = Get.find<GlobalController>();
  bool isExpanded = false;

  Iterable<OrderNote> get _dissatisfiedOrderNotes =>
      widget.orderNotes.where((orderNote) => !orderNote.isSatisfied);
  Iterable<OrderNote> get _satisfiedOrderNotes =>
      widget.orderNotes.where((orderNote) => orderNote.isSatisfied);

  bool get isSatisfied => _notes.isEmpty;

  Iterable<OrderNote> get _notes {
    final dissatisfied =
        widget.orderNotes.where((orderNote) => !orderNote.isSatisfied).toList();

    OrderNote? practiceLuxuryOrderNote;
    if (global.galdermaController.hasPracticeLuxuryPromotion) {
      practiceLuxuryOrderNote = OrderNote(
        name: 'Galderma Practice Luxury Promotion',
        type: OrderNoteType.vendor,
        knownId: 19,
        orderRules: [
          CartOrderRule(
            ruleMessage: '',
            isRuleSatisfied: global.galdermaController.isRewardSelected,
          ),
        ],
      );
    }

    OrderNote? merzOrderNote;
    if (global.simpleCart.value.hasMerzPromotion) {
      merzOrderNote = OrderNote(
        name: 'Merz Syringe Promotion',
        type: OrderNoteType.vendor,
        knownId: 20,
        orderRules: [
          CartOrderRule(
            ruleMessage: '',
            isRuleSatisfied: global.simpleCart.value.isMerzPromotionSatisfied,
          ),
        ],
      );
    }

    if (practiceLuxuryOrderNote != null &&
        !practiceLuxuryOrderNote.isSatisfied) {
      dissatisfied.add(practiceLuxuryOrderNote);
    }

    if (merzOrderNote != null && !merzOrderNote.isSatisfied) {
      dissatisfied.add(merzOrderNote);
    }

    if (!isExpanded) return dissatisfied;
    final satisfied =
        widget.orderNotes.where((orderNote) => orderNote.isSatisfied).toList();

    if (merzOrderNote != null && merzOrderNote.isSatisfied) {
      satisfied.insert(0, merzOrderNote);
    }

    if (practiceLuxuryOrderNote != null &&
        practiceLuxuryOrderNote.isSatisfied) {
      satisfied.insert(0, practiceLuxuryOrderNote);
    }
    return [...dissatisfied, ...satisfied];
  }

  int get missingCount {
    var count = _dissatisfiedOrderNotes.length;
    if (global.galdermaController.hasPracticeLuxuryPromotion &&
        !global.galdermaController.isRewardSelected) {
      count++;
    }
    if (global.simpleCart.value.hasMerzPromotion &&
        !global.simpleCart.value.isMerzPromotionSatisfied) {
      count++;
    }
    return count;
  }

  void showMixMatchDialog(OrderNote orderNote, CartOrderRule orderRule) {
    showDialog(
      context: context,
      builder:
          (context) => Obx(() {
            final orderRuleX = global.simpleCart.value.orderNotes
                .firstWhere((note) => note.knownId == orderNote.knownId)
                .orderRules
                .firstWhere((rule) => rule.id == orderRule.id);
            String groupName = '';

            Iterable<ProductSimple> products = [];
            switch (orderNote.type) {
              case OrderNoteType.vendor:
                final vendor = global.vendors.firstWhere(
                  (v) => v.vendorId == orderNote.knownId,
                );
                groupName = vendor.name;
                products = global.allProducts.value.getProductsByVendorIds(
                  vendorIds: [orderNote.knownId],
                );
                break;
              case OrderNoteType.brand:
                final brand = global.brands.firstWhere(
                  (b) => b.brandId == orderNote.knownId,
                );
                groupName = brand.name;
                products = global.allProducts.value.getProductsByBrandIds(
                  brandIds: [orderNote.knownId],
                );
                break;
              case OrderNoteType.product:
                final product = global.allProducts.value.products.firstWhere(
                  (p) => p.productId == orderNote.knownId,
                );
                groupName = product.name;
                products = global.allProducts.value.products.where(
                  (p) => p.productId == product.productId,
                );
                break;
              case OrderNoteType.sku:
                final product = global.allProducts.value.products.firstWhere(
                  (p) => p.skuIds.contains(orderNote.knownId),
                );
                final sku = product.skus!.firstWhere(
                  (s) => int.parse(s.skuId) == orderNote.knownId,
                );
                products =
                    global.allProducts.value.products
                        .where(
                          (p) =>
                              p.productId == product.productId &&
                              p.skuIds.contains(int.parse(sku.skuId)),
                        )
                        .toList();
                break;
            }
            return MixMatchDialog(
              title: orderRule.ruleMessage,
              groupName: groupName,
              cart: global.simpleCart.value,
              products: products,
              quantityLeft: orderRuleX.requiredQuantity,
              spendingLeft: orderRuleX.spendingLeft,
              // expandSkus: expandSkus,
              onProductQuantityChanged: (sku, newQuantity) async {
                await global.basket.addToCart(
                  customerId: global.user.value.profileId.toString(),
                  quantity: newQuantity,
                  product: "${sku.productId}-${sku.skuId}",
                );
              },
            );
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    print(
      '[BlackOrderRequirementsView] _notes detail: ${_notes.map((n) => 'OrderNote(knownId: ${n.knownId}, isSatisfied: ${n.isSatisfied}, rules: ${n.orderRules.map((r) => '{message: ${r.ruleMessage}, satisfied: ${r.isRuleSatisfied}}').toList()})').toList()}',
    );
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF343434),
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Material(
        color: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
              child: _OrderRequirementsHeader(missingCount: missingCount),
            ),
            if (!isSatisfied)
              Divider(
                color: YLiftColor.divider,
                indent: 20,
                endIndent: 20,
                height: 32,
              ),
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child:
                  isSatisfied
                      ? const SizedBox(width: double.infinity)
                      : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(_notes.length * 2 - 1, (index) {
                          if (index.isOdd) {
                            return Divider(
                              color: YLiftColor.divider,
                              indent: 20,
                              endIndent: 20,
                              height: 32,
                            );
                          }
                          final orderNote = _notes.elementAt(index ~/ 2);
                          if (orderNote.name ==
                              'Galderma Practice Luxury Promotion') {
                            return NewPracticeLuxuryOrderRule(
                              promotion:
                                  global
                                      .galdermaController
                                      .currentTierPromotion!,
                            );
                          }

                          if (orderNote.name == 'Merz Syringe Promotion' &&
                              global.simpleCart.value.merzPromotion != null) {
                            return const NewMerzOrderRule();
                          }
                          return OrderNoteView(
                            orderNote: orderNote,
                            onSelectedOrderRule:
                                orderNote.isSatisfied
                                    ? null
                                    : (orderRule) {
                                      showMixMatchDialog(orderNote, orderRule);
                                    },
                          );
                        }),
                      ),
            ),

            const SizedBox(height: 16),

            // Expand button
            Material(
              color: Colors.black,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
              child: InkWell(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
                onTap: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
                child: SizedBox(
                  width: double.infinity,
                  height: 32,
                  child: Center(
                    child: Icon(
                      isExpanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OrderRequirementsHeader extends StatelessWidget {
  final int missingCount;
  const _OrderRequirementsHeader({super.key, required this.missingCount});

  @override
  Widget build(BuildContext context) {
    if (missingCount > 0) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Missing Order Requirement',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: YLiftColor.orange,
            ),
            alignment: Alignment.center,
            width: 24,
            height: 24,
            child: Text(
              '$missingCount',
              style: TextStyle(color: Colors.white, fontSize: 13.33),
            ),
          ),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Order Requirement Fulfilled',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        Icon(Icons.check, color: Colors.green, size: 16),
      ],
    );
  }
}
