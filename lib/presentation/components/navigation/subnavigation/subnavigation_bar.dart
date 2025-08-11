import 'package:YLift/core/constants/constant.dart';
import 'package:YLift/core/controllers/global.dart';
import 'package:YLift/presentation/components/navigation/brand_subnavigation/brand_subnavigation_button.dart';
import 'package:YLift/presentation/components/navigation/brand_subnavigation/brand_subnavigation_panel.dart';
import 'package:YLift/presentation/components/navigation/category_subnavigation/category_subnavigation_button.dart';
import 'package:YLift/presentation/components/navigation/category_subnavigation/category_subnavigation_panel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubNavigationBar extends StatefulWidget {
  const SubNavigationBar({super.key});

  @override
  State<SubNavigationBar> createState() => _SubNavigationBarState();
}

class _SubNavigationBarState extends State<SubNavigationBar> {
  final _key = GlobalKey();
  OverlayEntry? _overlayEntry;
  String? _panelName;

  bool isInsidePopup = false;

  void togglePopup(bool isHovered) {
    if (isHovered && _overlayEntry == null) {
      _showPopup(context, _key);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: _key,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.black12)),
      ),
      width: double.infinity,
      height: YLiftConstant.subNavigationHeight,
      alignment: Alignment.center,
      child: SizedBox(
        width: YLiftConstant.pageWidth,
        child: Row(
          children: [
            GestureDetector(
              onTap: (){
                final global = Get.find<GlobalController>();
                global.vroute.navigateTo('/shop/all');
              },
              child: const Row(
                children: [
                  Icon(Icons.search_outlined, size: 16),
                  SizedBox(width: 8),
                  Text('SHOP ALL', style: TextStyle(fontSize: 13.33),)
                ],
              ),
            ),
            const SizedBox(width: 64),
            BrandSubNavigationButton(
              onHover: (isHovered) {
                if (isHovered) {
                  if(_panelName != 'BRANDS') _hidePopup();

                  _panelName = 'BRANDS';
                }
                togglePopup(isHovered);
              },
            ),
            const SizedBox(width: 64),
            CategorySubNavigationButton(
              onHover: (isHovered) {
                if (isHovered) {
                  if(_panelName != 'CATEGORIES') _hidePopup();
                  _panelName = 'CATEGORIES';
                }
                togglePopup(isHovered);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _hidePopup() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _showPopup(BuildContext context, GlobalKey key) {
    final renderBox = key.currentContext?.findRenderObject() as RenderBox?;
    final position = renderBox?.localToGlobal(Offset.zero) ?? Offset.zero;
    final size = renderBox?.size ?? Size.zero;

    Widget? panel;

    switch (_panelName) {
      case 'BRANDS':
        panel = BrandSubNavigationPanel(
          onHover: (isHovered) {
            isInsidePopup = isHovered;
            if (!isInsidePopup) {
              _hidePopup();
            }
          },
          onBrandSelected: () {
            _hidePopup();
          },
        );
        break;

      case 'CATEGORIES':
        panel = CategorySubNavigationPanel(
          onHover: (isHovered) {
            isInsidePopup = isHovered;
            if (!isInsidePopup) {
              _hidePopup();
            }
          },
          onCategorySelected: () {
            _hidePopup();
          },
        );
        break;
    }
    if (panel == null) return;

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: 0,
        top: position.dy + size.height, // Position below the button
        child: Material(
          elevation: 4.0,
          color: Colors.transparent,
          shadowColor: Colors.transparent,
          child: panel,
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }
}
