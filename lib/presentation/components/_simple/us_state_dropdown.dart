import 'package:galaxy_models/galaxy_models.dart';
import 'package:flutter/material.dart';

class UsStateDropdownMenu extends StatefulWidget {
  final String? labelText;
  final USState? value;
  final void Function(USState? state)? onChanged;
  final double menuHeight;
  final String? errorText;

  const UsStateDropdownMenu({
    super.key,
    this.labelText,
    this.value,
    this.onChanged,
    this.menuHeight = 400,
    this.errorText,
  });

  @override
  State<UsStateDropdownMenu> createState() => _UsStateDropdownMenuState();
}

class _UsStateDropdownMenuState extends State<UsStateDropdownMenu> {
  final controller = TextEditingController();

  @override
  void initState() {
    controller.text = widget.value?.label ?? '';
    super.initState();
  }

  @override
  void didUpdateWidget(covariant UsStateDropdownMenu oldWidget) {
    if (widget.value != oldWidget.value) {
      controller.text = widget.value?.label ?? '';
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return DropdownMenu(
      enableSearch: false,
      requestFocusOnTap: false,
      expandedInsets: EdgeInsets.zero,
      onSelected: widget.onChanged,
      menuHeight: widget.menuHeight,
      label: Text(widget.labelText ?? 'State*'),
      helperText: '',
      errorText: widget.errorText,
      initialSelection: widget.value,
      dropdownMenuEntries: USState.values
          .map((e) {
            return DropdownMenuEntry(value: e, label: e.label);
          })
          .toList(growable: false),
    );
  }
}

class USStateDropdown extends StatefulWidget {
  final String? labelText;
  final USState? value;
  final void Function(USState? state)? onChanged;
  final double menuHeight;
  final String? errorText;

  const USStateDropdown({
    super.key,
    this.labelText,
    this.value,
    this.onChanged,
    this.menuHeight = 400,
    this.errorText,
  });

  @override
  State<USStateDropdown> createState() => _USStateDropdownState();
}

class _USStateDropdownState extends State<USStateDropdown> {
  final controller = TextEditingController();

  @override
  void initState() {
    controller.text = widget.value?.label ?? '';
    super.initState();
  }

  @override
  void didUpdateWidget(covariant USStateDropdown oldWidget) {
    if (widget.value != oldWidget.value) {
      controller.text = widget.value?.label ?? '';
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return DropdownMenu(
      // enableSearch: false,
      // requestFocusOnTap: false,
      expandedInsets: EdgeInsets.zero,
      onSelected: (value) {
        final usState = USState.values.firstWhere((element) => element.label == value);
        debugPrint('US State selected: $usState');
        widget.onChanged?.call(usState);
      },
      menuHeight: widget.menuHeight,
      label: Text(widget.labelText ?? 'State*'),
      helperText: '',
      errorText: widget.errorText,
      initialSelection: widget.value,
      dropdownMenuEntries: USState.values
          .map((e) {
            return DropdownMenuEntry(value: e.label, label: e.label);
          })
          .toList(growable: false),
    );
  }
}
