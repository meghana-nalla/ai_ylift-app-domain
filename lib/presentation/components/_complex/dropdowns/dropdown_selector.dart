import 'package:flutter/material.dart';

class DropdownSelector extends StatefulWidget {
  final String labelName;
  final Function? onTap;

  const DropdownSelector({
    super.key,
    required this.labelName,
    this.onTap,
  });

  @override
  State<DropdownSelector> createState() => _DropdownSelectorState();
}

class _DropdownSelectorState extends State<DropdownSelector> {

  /// Text Styling logic
  final TextStyle _unselectedTextStyle = const TextStyle(
    color: Color(0xFF606060),
    fontSize: 13.33,
    letterSpacing: 1.8,
  );

  final TextStyle _selectedTextStyle = const TextStyle(
    color: Color(0xFF606060),
    fontSize: 13.33,
    letterSpacing: 1.8,
    fontWeight: FontWeight.bold,
  );

  TextStyle? _currentTextStyle;

  void _toggleTextStyle() {
    setState(() {
      _currentTextStyle = (_currentTextStyle == _unselectedTextStyle)
          ? _selectedTextStyle
          : _unselectedTextStyle;
    });
  }

  // build logic

  @override
  void initState() {
    super.initState();
    _currentTextStyle = _unselectedTextStyle;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 8),
        MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) {
            _toggleTextStyle();
          },
          onExit: (_) {
            _toggleTextStyle();
          },
          child: GestureDetector(
            onTap: () => widget.onTap!.call(),
            child: Text(
              widget.labelName,
              style: _currentTextStyle,
            ),
          ),
        ),
      ],
    );
  }
}