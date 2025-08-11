import 'package:YLift/models/simple/z-index_export.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:galaxy_ui/galaxy_ui.dart';
import 'package:YLift/core/controllers/z-index_export.dart';
import 'package:YLift/presentation/components/z-index_export.dart';
import 'package:galaxy_models/galaxy_models.dart';
class DesktopSearchBar extends StatefulWidget {
  @override
  _DesktopSearchBarState createState() => _DesktopSearchBarState();
}

class _DesktopSearchBarState extends State<DesktopSearchBar> {
  final controller = Get.find<GlobalController>();
  
  List<ProductSimple> _searchResults = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void _handleSearch(String query) async {
    await _performSearch(query);
  }

  void _handleSearchChange(String value) {
    setState(() {
      if (value.isEmpty) {
        _searchResults.clear();
      }
    });
  }

  void _removePreviousSearch(String search) {
    setState(() {
      controller.previousSearches.remove(search);
    });
  }

  void _clearSearch() {
    setState(() {
      _searchController.clear();
      _searchResults.clear();
    });
  }

  void _onPreviousSearchTap(String query) {
    _searchController.text = query;
    _performSearch(query);
  }

  Future<void> _performSearch(String query) async {
    try {
      await controller.executeSearch(query);
      setState(() {
        _searchResults = controller.dynamicProducts;
        if (!controller.previousSearches.contains(query)) {
          controller.previousSearches.insert(0, query);
          if (controller.previousSearches.length > 5) {
            controller.previousSearches.removeLast();
          }
        }
      });
    } catch (e) {
      print('Error performing search: $e');
    }
  }

  void _viewFullResults() {
    // TODO: Implement navigation to full results page

  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [Center(
      child: SizedBox(
      width: 600, // Adjust the width to make it shorter (adjust this value as needed)
          child: ProductSearchBar(
            onSearch: _handleSearch,
            onChanged: _handleSearchChange,
            previousSearches: controller.previousSearches,
            onRemovePreviousSearch: _removePreviousSearch,
            onPreviousSearchTap: _onPreviousSearchTap,
            controller: _searchController,
            onClear: _clearSearch,
          ))),
          if (_searchResults.isNotEmpty) ...[
            Flexible(
              child: Container(
                height: _searchResults.length > 3 ? 250 : 200,
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: _searchResults.length > 3 ? 3 : _searchResults.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(_searchResults[index].name),
                            subtitle:
                            _searchResults[index].price == null || _searchResults[index].price == 0
                                ? null
                                :
                            Text('\$${
                                _searchResults[index].price == null ? '0.00' : _formatPrice(_searchResults[index].price!).toStringAsFixed(2)}'),
                            leading: _searchResults[index].imageUrl != null
                                ? Image.network(_searchResults[index].imageUrl!)
                                : null,
                            onTap: () {
                              controller.products.select(_searchResults[index]);
                            },
                          );
                        },
                      ),
                    ),
                    if (_searchResults.length > 3)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: ElevatedButton(
                          onPressed: _viewFullResults,
                          child: Text('View all [${controller.recentSearch.value.count}] results'),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(200, 40),
                          ),
                        ),
                      ),
                    SizedBox(height: 8),
                  ],
                ),
              ),
            )
          ]
          else if (_searchController.text.isEmpty) ... [
            Center(child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child:Column(
                  children: [
                    SizedBox(height: 8),
                    Center(child: Obx(() {
                      if (controller.quickLinks.isEmpty) {
                        return Center(child: LinearProgressIndicator());
                      } else {
                        return Center(
                          child: DesktopQuickLinksNav(controller.quickLinks as List<QuickLinksSimple>),
                        );
                      }
                    }))
                    ,
                    SizedBox(height: 8),
                  ],
                )
            )),
          ]
        ],
      ),
    );
  }

  int _formatPrice(double price) {
    return (price / 100).round();
  }
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}