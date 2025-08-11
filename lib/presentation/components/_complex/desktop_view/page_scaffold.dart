import 'package:YLift/core/constants/constant.dart';
import 'package:YLift/presentation/components/_complex/footer.dart';
import 'package:flutter/material.dart';

class GalaxyPageScaffold extends StatelessWidget {
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final Color? backgroundColor;
  final EdgeInsets padding;
  final CrossAxisAlignment crossAxisAlignment;
  final List<Widget> children;
  final Widget? endDrawer;
  final bool showGalaxyFooter;

  final ScrollController? scrollController;

  const GalaxyPageScaffold({
    super.key,
    this.padding = YLiftConstant.pagePadding,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    required this.children,
    this.backgroundColor,
    this.scaffoldKey,
    this.endDrawer,
    this.showGalaxyFooter = true,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: backgroundColor ?? Colors.white,
      endDrawer: endDrawer,
      body: SingleChildScrollView(
        controller: scrollController,
        padding: padding,
        child: Column(
          children: [
            Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: YLiftConstant.pageWidth,
                  minHeight: MediaQuery.of(context).size.height -
                      YLiftConstant.totalTopNavigation -
                      YLiftConstant.footerHeight,
                ),
                child: Column(
                  crossAxisAlignment: crossAxisAlignment,
                  children: children,
                ),
              ),
            ),
            if (showGalaxyFooter) GalaxyFooter(),
          ],
        ),
      ),
    );
  }
}
