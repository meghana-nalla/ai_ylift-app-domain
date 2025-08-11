import 'package:flutter/material.dart';

class YLiftPaginationWidget extends StatefulWidget {
  final int totalNumItems;
  final int itemsPerPage;
  final int currentPage;
  final Function(int) onPageChanged;

  const YLiftPaginationWidget({
    super.key,
    required this.totalNumItems,
    required this.itemsPerPage,
    required this.currentPage,
    required this.onPageChanged,
  });

  @override
  State<YLiftPaginationWidget> createState() => _YLiftPaginationWidgetState();
}

class _YLiftPaginationWidgetState extends State<YLiftPaginationWidget> {
  void _changePage(int change) {
    final totalPages = (widget.totalNumItems / widget.itemsPerPage).ceil();
    final newPage = widget.currentPage + change;
    if (newPage >= 1 && newPage <= totalPages) {
      widget.onPageChanged(newPage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: widget.currentPage > 5 ? () => _changePage(-5) : null,
          icon: const Icon(Icons.keyboard_double_arrow_left),
        ),
        IconButton(
          onPressed: widget.currentPage > 1 ? () => _changePage(-1) : null,
          icon: const Icon(Icons.chevron_left),
        ),
        SizedBox(
          width: 40,
          child: Text(
            widget.currentPage.toString(),
            textAlign: TextAlign.center,
          ),
        ),
        IconButton(
          onPressed: widget.currentPage < (widget.totalNumItems / widget.itemsPerPage).ceil() ? () => _changePage(1) : null,
          icon: const Icon(Icons.chevron_right),
        ),
        IconButton(
          onPressed: widget.currentPage < (widget.totalNumItems / widget.itemsPerPage).ceil() - 4 ? () => _changePage(5) : null,
          icon: const Icon(Icons.keyboard_double_arrow_right),
        ),
      ],
    );
  }
}
