import 'package:flutter/material.dart';

class YLiftStepper extends StatefulWidget {
  final int quantityIncrement;
  final int quantityMax;
  final int quantityMin;
  final int? currentValue;
  final Function(int)? onQuantityChanged;

  final double? height;

  YLiftStepper({
    required this.quantityIncrement,
    required this.quantityMax,
    required this.quantityMin,
    this.currentValue,
    this.onQuantityChanged,
    this.height,
  });

  @override
  _YLiftStepperState createState() => _YLiftStepperState();
}

class _YLiftStepperState extends State<YLiftStepper> {
  late int _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.currentValue ?? widget.quantityMin;
  }

  void _updateValue(int newValue) {
    setState(() {
      _currentValue = newValue;
    });

    widget.onQuantityChanged?.call(_currentValue);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: theme.colorScheme.outline),
        borderRadius: BorderRadius.circular(32),
        color: theme.colorScheme.surface,
      ),
      height: widget.height,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (widget.height != null)
            GestureDetector(
              onTap: () {
                if (_currentValue - widget.quantityIncrement >= widget.quantityMin) {
                  _updateValue(_currentValue - widget.quantityIncrement);
                }
              },
              child: const Icon(Icons.remove),
            )
          else
            IconButton(
              onPressed: () {
                if (_currentValue - widget.quantityIncrement >= widget.quantityMin) {
                  _updateValue(_currentValue - widget.quantityIncrement);
                }
              },
              icon: Icon(Icons.remove, color: theme.colorScheme.primary),
            ),
          Container(
            width: 30,
            alignment: Alignment.center,
            child: Text(
              '$_currentValue',
              style: TextStyle(
                fontSize: widget.height == null ? 13 : 14,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
          if (widget.height != null)
            GestureDetector(
              onTap: () {
                if (_currentValue + widget.quantityIncrement <= widget.quantityMax) {
                  _updateValue(_currentValue + widget.quantityIncrement);
                }
              },
              child: const Icon(Icons.add),
            )
          else
            IconButton(
              onPressed: () {
                if (_currentValue + widget.quantityIncrement <= widget.quantityMax) {
                  _updateValue(_currentValue + widget.quantityIncrement);
                }
              },
              icon: Icon(Icons.add, color: theme.colorScheme.primary),
            ),
        ],
      ),
    );
  }
}
