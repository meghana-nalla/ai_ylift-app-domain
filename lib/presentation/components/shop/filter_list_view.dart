import 'package:YLift/presentation/components/shop/vendor_and_brands_filter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class FilterListView<T> extends StatefulWidget {
  final String name;
  final Set<T> list;
  final Set<T> selectedFilters; // Add this
  final String Function(T value) display;
  final void Function(Set<T> filters)? onSelectedFilters;

  const FilterListView({
    super.key,
    required this.name,
    required this.list,
    required this.display,
    required this.selectedFilters, // Add this
    this.onSelectedFilters,
  });

  @override
  State<FilterListView<T>> createState() => _FilterListViewState<T>();
}

class _FilterListViewState<T> extends State<FilterListView<T>> {
  late Set<T> filters;

  @override
  void initState() {
    super.initState();
    filters = Set<T>.from(widget.selectedFilters);
  }

  @override
  void didUpdateWidget(covariant FilterListView<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!setEquals(widget.selectedFilters, filters)) {
      filters = Set<T>.from(widget.selectedFilters);
    }
  }

  void toggleFilter(T? value) {
    if (value == null) {
      setState(() {
        filters.clear();
      });
    } else {
      setState(() {
        if (filters.contains(value)) {
          filters.remove(value);
        } else {
          filters.add(value);
        }
      });
    }
    widget.onSelectedFilters?.call(filters);
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(widget.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13.33, letterSpacing: 1)),
      initiallyExpanded: true,
      shape: const RoundedRectangleBorder(),
      backgroundColor: Colors.white,
      collapsedBackgroundColor: Colors.white,
      childrenPadding: const EdgeInsets.only(left: 16),
      children: [
        // TextButton(
        //   onPressed: () => toggleFilter(null),
        //   child: const Text('Reset'),
        // ),
        ...widget.list.map(
          (e) {
            final isSelected = filters.contains(e);
            return GestureDetector(
              onTap: () => toggleFilter(e),
              child: FilterTile(
                value: isSelected,
                title: Text(widget.display(e), style: TextStyle(fontSize: 13.33, letterSpacing: 1),),
                onChanged: (_) => toggleFilter(e),
              ),
              // child: Row(
              //   children: [
              //     const SizedBox(width: 32),
              //     Checkbox(
              //       value: isSelected,
              //       onChanged: (_) => toggleFilter(e),
              //     ),
              //     const SizedBox(width: 16),
              //     Text(widget.display(e)),
              //   ],
              // ),
            );
          },
        )
      ],
    );
  }
}
