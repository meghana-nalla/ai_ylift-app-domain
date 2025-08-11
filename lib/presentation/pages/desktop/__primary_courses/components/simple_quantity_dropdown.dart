import 'dart:math';

import 'package:YLift/core/constants/color.dart';
import 'package:flutter/material.dart';

class SimpleQuantityDropdown extends StatefulWidget {
  final int value;
  final int maxQuantity;
  final void Function(int value) onChanged;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Border? border;
  final BorderRadius? borderRadius;
  final EdgeInsets? padding;

  const SimpleQuantityDropdown({
    super.key,
    this.value = 1,
    this.maxQuantity = 100,
    required this.onChanged,
    this.backgroundColor,
    this.border,
    this.borderRadius,
    this.padding,
    this.foregroundColor,
  });

  @override
  State<SimpleQuantityDropdown> createState() => _SimpleQuantityDropdownState();
}

class _SimpleQuantityDropdownState extends State<SimpleQuantityDropdown> {
  int quantity = 0;

  @override
  void initState() {
    quantity = widget.value;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant SimpleQuantityDropdown oldWidget) {
    if (widget.value != oldWidget.value) {
      setState(() {
        quantity = widget.value;
      });
    }
    super.didUpdateWidget(oldWidget);
  }

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

    int maxQuantity = max(quantity, widget.maxQuantity) + 1;

    double? minHeight;
    if (maxQuantity < 7) {
      minHeight = maxQuantity * 48;
    }
    minHeight ??= 320;

    final renderBox = key.currentContext?.findRenderObject() as RenderBox?;
    final position = renderBox?.localToGlobal(Offset(0, -minHeight - 52)) ?? Offset.zero;
    final size = renderBox?.size ?? Size.zero;

    _overlayEntry = OverlayEntry(
      builder:
          (context) => Stack(
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
                    height: minHeight ?? 320,
                    child: ListView.builder(
                      reverse: true,
                      itemCount: maxQuantity,
                      itemBuilder: (context, index) {
                        final value = index;
                        return ListTile(
                          selected: quantity == widget.value,
                          onTap: () {
                            setState(() {
                              quantity = value;
                            });
                            widget.onChanged(quantity);
                            _hidePopup();
                          },
                          title: Text('$value'),
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
  void dispose() {
    _hidePopup();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: togglePopup,
      child: Container(
        key: _key,
        decoration: BoxDecoration(
          color: widget.backgroundColor ?? Colors.black,
          borderRadius: widget.borderRadius ?? BorderRadius.only(
            topRight: Radius.circular(8),
            bottomRight: Radius.circular(8),
          ),
          border: widget.border,
        ),
        padding: widget.padding ?? const EdgeInsets.only(
          left: 16,
          right: 12,
          top: 16,
          bottom: 16,
        ),
        child: Row(
          children: [
            SizedBox(
              width: 32,
              child: Text(
                '$quantity',
                style: TextStyle(color: widget.foregroundColor ?? Colors.white, fontSize: 13.33),
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.keyboard_arrow_down,
              color: widget.foregroundColor ?? Colors.white,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
