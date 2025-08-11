import 'package:flutter/material.dart';
import 'package:galaxy_models/galaxy_models.dart';
import 'package:YLift/presentation/pages/desktop/cart/components/black_order_requirements/order_note_view.dart';

class BlackOrderRequirementsMobileView extends StatelessWidget {
  final List<OrderNote> orderNotes;
  final void Function(OrderNote orderNote, CartOrderRule orderRule)? onTapOrderRule;

  const BlackOrderRequirementsMobileView({
    Key? key,
    required this.orderNotes,
    this.onTapOrderRule,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF232323),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Order Requirements",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          ...orderNotes.map((note) => Card(
            color: const Color(0xFF343434),
            margin: const EdgeInsets.symmetric(vertical: 4),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: OrderNoteView(
                orderNote: note,
                onSelectedOrderRule: onTapOrderRule == null
                    ? null
                    : (rule) => onTapOrderRule!(note, rule),
              ),
            ),
          )),
        ],
      ),
    );
  }
}
