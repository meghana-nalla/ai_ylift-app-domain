import 'package:YLift/presentation/components/_complex/grid_dynamic_product.dart';
import 'package:flutter/material.dart';

import 'package:YLift/models/simple/tbd/search_result.dart';

class FullSearchResultsScreen extends StatelessWidget {
  final String searchQuery;
  final SearchResult searchResults;

  const FullSearchResultsScreen({
    Key? key,
    required this.searchQuery,
    required this.searchResults,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Search Results'),
      //   bottom: PreferredSize(
      //     preferredSize: Size.fromHeight(40),
      //     child: Container(
      //       padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      //       alignment: Alignment.centerLeft,
      //       child: Text(
      //         'Results for "$searchQuery"',
      //         style: TextStyle(
      //           color: Colors.white,
      //           fontSize: 16,
      //           fontWeight: FontWeight.bold,
      //         ),
      //       ),
      //     ),
      //   ),
      // ),

      body: DynamicProductGridView(PageContents: 'Results for \"$searchQuery\"'),
      // body: ListView.builder(
      //   itemCount: searchResults.products?.length ?? 0,
      //   itemBuilder: (context, index) {
      //     return ListTile(
      //       title: Text(searchResults.products?[index].name ?? 'Product Not found' ),
      //       onTap: () {
      //         // action tapping on a search result
      //         // TODO: implement action
      //         print('Tapped on ${searchResults.products?[index].name}');
      //       },
      //     );
      //   },
      // ),
    );
  }
}