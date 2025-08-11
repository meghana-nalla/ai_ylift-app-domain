
import 'package:flutter/material.dart';
import 'package:galaxy_models/galaxy_models.dart';

class GalaxySKUDropdownMenu extends StatefulWidget {
  final SkuSimple? value;
  final List<SkuSimple> skus;
  final void Function(SkuSimple? sku) onSelected;

  final bool withLabel;
  final bool isExpanded;
  final bool withBorder;

  final bool isActive;

  const GalaxySKUDropdownMenu({
    super.key,
    required this.skus,
    required this.onSelected,
    this.isActive = true,
    this.withLabel = true,
    this.isExpanded = true,
    this.withBorder = true,
    this.value,
  });

  @override
  State<GalaxySKUDropdownMenu> createState() => _GalaxySKUDropdownMenuState();
}

class _GalaxySKUDropdownMenuState extends State<GalaxySKUDropdownMenu> {
  final controller = TextEditingController();

  @override
  void initState() {
    controller.text = widget.value?.attributeName ?? '';
    super.initState();
  }

  @override
  void didUpdateWidget(covariant GalaxySKUDropdownMenu oldWidget) {
    if (widget.value != oldWidget.value) {
      controller.text = widget.value?.attributeName ?? '';
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    Widget skuDropdown = DropdownMenu<SkuSimple>(
      controller: controller,
      initialSelection: widget.value,
      enabled: widget.isActive,
      hintText: 'Select a variety',
      requestFocusOnTap: false,
      enableSearch: false,
      expandedInsets: widget.isExpanded ? EdgeInsets.zero : null,
      trailingIcon: const Icon(Icons.keyboard_arrow_down),
      selectedTrailingIcon: const Icon(Icons.keyboard_arrow_up),
      inputDecorationTheme: InputDecorationTheme(
        border: widget.withBorder ? const OutlineInputBorder() : InputBorder.none,
      ),
      textStyle: widget.withBorder ? textTheme.bodyMedium : textTheme.bodySmall,
      dropdownMenuEntries: widget.skus.map(
        (sku) {
          return DropdownMenuEntry(value: sku, label: sku.attributeName ?? 'Default');
        },
      ).toList(growable: false),
      onSelected: widget.onSelected,
    );

    if (widget.withLabel) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Choose a variety:'),
          const SizedBox(height: 8),
          skuDropdown,
        ],
      );
    }

    return skuDropdown;
  }
}
