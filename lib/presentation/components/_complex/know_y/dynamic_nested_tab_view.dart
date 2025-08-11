import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class DynamicNestedTabView extends StatefulWidget {
  DynamicNestedTabView({
    super.key,
    // TODO: accept children and titles as required arguments
    // required this.children,
    // required this.listTitles,
  });

  // TODO: replace list with children argument
  final List<Widget> children =  <Widget>[
    Container(
      height: 400,
      width: double.infinity,
      color: Colors.red,
      child: const Text('Pagasdadasde 0'),
    ),
    Container(
      height: 400,
      width: double.infinity,
      color: Colors.green,
      child: const Text('Page 1'),
    ),
    Container(
      height: 400,
      width: double.infinity,
      color: Colors.blue,
      child: const Text('Page 2'),
    ),
  ];

  // TODO: replace list with pageTitles argument
  final List<String> pageTitles = const <String> [
    'Chapters',
    'Q&A',
    'Materials',
  ];

  @override
  State<DynamicNestedTabView> createState() => _DynamicNestedTabViewState();
}

class _DynamicNestedTabViewState extends State<DynamicNestedTabView> {

  int _displayIndex = 0;

  @override
  Widget build(BuildContext context) {

    void _handleNavigation(int index) {
      print('Callback function _navigate called');
      setState(() {
        _displayIndex = index;
      });
    }

    /// NestedTabBarView
    return Column(
      children: [
        /// Tab Bar header
        NestedTabBarNavigator(
          pageTitles: widget.pageTitles,
          navigate: _handleNavigation,
        ),
        /// view content
        widget.children[_displayIndex],
      ],
    );
  }
}

/// Nested Tab Bar Navigator - builds the header
class NestedTabBarNavigator extends StatefulWidget {
  const NestedTabBarNavigator({
    super.key,
    required this.pageTitles,
    required this.navigate,
  });

  final List<String> pageTitles;
  final Function(int) navigate;

  @override
  State<NestedTabBarNavigator> createState() => _NestedTabBarNavigatorState();
}

class _NestedTabBarNavigatorState extends State<NestedTabBarNavigator> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 65,
      width: double.infinity,
      child: Row(
        children: List.generate(
          widget.pageTitles.length,
          (index) {
            return Expanded(
              flex: 1,
              child: NestedTabBar(
                titleText: Text(widget.pageTitles[index]),
                navigate: widget.navigate,
                index: index,
              ),
            );
          },
        ),
      ),
    );
  }
}



/// NestedTabBar - represents a single tab component
class NestedTabBar extends StatefulWidget {
  const NestedTabBar({
    super.key,
    required this.titleText,
    required this.index,
    required this.navigate,
    this.color,
    this.indicatorFocusColor,
    this.indicatorDefaultColor,
  });

  final Text titleText;
  final int index;
  final Function(int) navigate;
  final Color? color;
  final Color? indicatorFocusColor;
  final Color? indicatorDefaultColor;

  @override
  State<NestedTabBar> createState() => _NestedTabBarState();
}

class _NestedTabBarState extends State<NestedTabBar> {



  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      // TODO: implement onTap logic
      onTap: () {
        print('on tap in nested tab bar called');
        print('index: ${widget.index.toString()}');
        widget.navigate(widget.index);

        },
      child: Column(
        children: [
          Container(
            height: 60,
            color: widget.color ?? Colors.white,
            child: Center(
              child: widget.titleText,
            )
          ),
          Container(
              height: 5,
              // TODO: implement color handler & replace hardcoded value
              color: widget.indicatorFocusColor ?? Colors.brown,
          ),
        ],
      ),
    );
  }
}

