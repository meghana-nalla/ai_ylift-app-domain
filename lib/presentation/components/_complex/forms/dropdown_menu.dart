import 'package:flutter/material.dart';

class YLiftDropdownMenu<T> extends StatelessWidget {
  final String labelText;
  final T? value;
  final List<T> list;
  final void Function(T value) onSelected;
  final String Function(T option)? display;
  final String? errorMessage;

  const YLiftDropdownMenu({
    super.key,
    this.value,
    required this.labelText,
    required this.list,
    required this.onSelected,
    this.display,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownMenu(
      expandedInsets: EdgeInsets.zero,
      enableSearch: false,
      requestFocusOnTap: false,
      label: Text(labelText),
      onSelected: (value) {
        if (value == null) return;
        onSelected(value);
      },
      initialSelection: value,
      helperText: '',
      errorText: errorMessage,
      dropdownMenuEntries: list.map(
        (e) {
          return DropdownMenuEntry(
            value: e,
            label: display?.call(e) ?? '$e',
          );
        },
      ).toList(growable: false),
    );
  }
}
