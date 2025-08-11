import 'package:YLift/core/constants/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class QuantityDropdown extends StatefulWidget {
  final bool withLabel;
  final int value;
  final int? minQty;
  final int? maxQty;
  final int? incrementQty;

  final bool isExpanded;
  final bool isDense;
  final void Function(int newValue) onChanged;

  final bool isActive;

  final EdgeInsets? contentPadding;

  const QuantityDropdown({
    super.key,
    this.withLabel = true,
    this.isExpanded = true,
    this.isDense = false,
    required this.value,
    required this.onChanged,
    this.isActive = true,
    this.contentPadding,
    this.minQty,
    this.maxQty,
    this.incrementQty,
  });

  @override
  State<QuantityDropdown> createState() => _QuantityDropdownState();
}

class _QuantityDropdownState extends State<QuantityDropdown> {
  final controller = TextEditingController();
  final _key = GlobalKey();
  OverlayEntry? _overlayEntry;

  bool isInsidePopup = false;

  void togglePopup() {
    if (_overlayEntry == null) {
      _showPopup(context, _key);
    } else {
      _hidePopup();
    }
  }

  void _hidePopup() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _showPopup(BuildContext context, GlobalKey key) {
    final renderBox = key.currentContext?.findRenderObject() as RenderBox?;
    final position = renderBox?.localToGlobal(Offset.zero) ?? Offset.zero;
    final size = renderBox?.size ?? Size.zero;



    int? maxQty;
    if (widget.minQty == 0 && widget.maxQty != null) {
      maxQty = widget.maxQty! + 1;
    }

    double? minHeight;
    if (maxQty != null && maxQty < 7) {
      minHeight = maxQty * 48;
    }

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        fit: StackFit.expand,
        children: [
          GestureDetector(
            onTap: () {
              _hidePopup();
            },
            child: Container(color: Colors.transparent),
          ),
          Positioned(
            left: position.dx,
            top: position.dy + size.height, // Position below the button
            child: Material(
              elevation: 4.0,
              color: Colors.white,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                side: BorderSide(color: YLiftColor.grey3),
              ),
              child: SizedBox(
                width: size.width,
                height: minHeight ?? 400,
                child: ListView.builder(
                  itemCount: maxQty ?? widget.maxQty,
                  itemBuilder: (context, index) {
                    // var quantity = (widget.incrementQty ?? 1) * (index + 1);
                    // if (widget.minQty != null) quantity += widget.minQty! - 1;
                    // final baseIncrement = (index + 1) * (widget.incrementQty ?? 1);
                    // final quantity = (widget.minQty ?? 0) + baseIncrement;
                    final minQty = widget.minQty ?? 1;
                    final quantity = (widget.minQty ?? 1) + (index * (widget.incrementQty ?? 1));
                    return ListTile(
                      selected: quantity == widget.value,
                      onTap: () {
                        widget.onChanged(quantity);
                        _hidePopup();
                      },
                      title: Text('$quantity'),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void updateQuantity(int? newValue) {
    if (newValue == null) return;
    widget.onChanged!(newValue);
  }

  @override
  void initState() {
    controller.text = '${widget.value}';
    super.initState();
  }

  @override
  void dispose() {
    _hidePopup();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant QuantityDropdown oldWidget) {
    if (widget.value != oldWidget.value) {
      controller.text = '${widget.value}';
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    Widget quantityDropdown = GestureDetector(
      onTap: togglePopup,
      child: Container(
        key: _key,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(6)),
          border: Border.all(color: Colors.black26),
        ),
        height: 48,
        width: 120,
        padding: widget.contentPadding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Text('${widget.value}'),
            const Spacer(),
            Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );

    // final int maxItems = widget.maxQty ?? 200;
    // final int startFrom = widget.minQty ?? 1;

    // Widget quantityDropdown = IconButtonTheme(
    //   data: IconButtonThemeData(
    //     style: IconButton.styleFrom(
    //       padding: EdgeInsets.zero,
    //     ),
    //   ),
    //   child: DropdownMenu<int>(
    //     enabled: widget.isActive,
    //     controller: controller,
    //     enableSearch: false,
    //     requestFocusOnTap: false,
    //     menuHeight: 400,
    //     expandedInsets: widget.isExpanded ? EdgeInsets.zero : null,
    //     initialSelection: widget.value,
    //     inputDecorationTheme: InputDecorationTheme(
    //       isDense: widget.isDense,
    //       contentPadding: widget.contentPadding,
    //     ),
    //     textStyle: TextStyle(fontSize: 13.33),
    //     dropdownMenuEntries: List.generate(
    //       maxItems - startFrom + 1,
    //       (index) {
    //         final q = index + startFrom;
    //         return DropdownMenuEntry(
    //           value: q,
    //           label: '$q',
    //           enabled: q >= (widget.minQty ?? 1),
    //         );
    //       },
    //     ),
    //     onSelected: (value) {
    //       if (value != null && value >= (widget.minQty ?? 1)) {
    //         updateQuantity(value);
    //       }
    //     },
    //   ),
    // );

    if (widget.withLabel) {
      quantityDropdown = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Quantity:'),
          const SizedBox(height: 8),
          quantityDropdown,
        ],
      );
    }

    return quantityDropdown;
  }
}
