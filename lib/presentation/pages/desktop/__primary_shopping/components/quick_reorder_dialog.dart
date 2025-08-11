import 'package:flutter/material.dart';
import 'package:galaxy_models/galaxy_models.dart';
import 'package:YLift/presentation/components/z-index_export.dart';


class QuickReorderDialog extends StatefulWidget {
  final OrderSimple previousOrder;

  const QuickReorderDialog({
    super.key,
    required this.previousOrder,
  });

  @override
  State<QuickReorderDialog> createState() => _QuickReorderDialogState();
}

class _QuickReorderDialogState extends State<QuickReorderDialog> {
  int? _selectedCardId;

  @override
  void initState() {
    super.initState();
  }

  void _handleAddToCart() {

  }

    @override
    Widget build(BuildContext context) {
      return Dialog(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        backgroundColor: Colors.white,
        child: Container(
          height: 600,
          width: 900,
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              QuickOrderView(
                previousOrder: widget.previousOrder,
                onSelectedCard: (cardPayment) {
                  setState(() {
                    _selectedCardId= int.parse(cardPayment.id);
                  });
                },
              ),
              const VerticalDivider(color: Colors.grey),
              OrderSummaryView(
                previousOrder: widget.previousOrder,
                onAddToCart: _handleAddToCart,
                cardId: _selectedCardId,
              ),
            ],
          ),
        ),
      );
    }
}
