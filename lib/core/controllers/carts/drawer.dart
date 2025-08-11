import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartDrawerController extends GetxController {

  final _scaffoldKeys = <String, GlobalKey<ScaffoldState>>{};
  final Rx<String> activeKeyId = ''.obs;


  GlobalKey<ScaffoldState> get scaffoldKey {
    if (activeKeyId.value.isEmpty) {
      return createNewKey();
    }
    return _scaffoldKeys[activeKeyId.value]!;
  }


  GlobalKey<ScaffoldState> createNewKey() {
    final newKeyId = DateTime.now().millisecondsSinceEpoch.toString();
    final newKey = GlobalKey<ScaffoldState>(debugLabel: 'scaffold_cart_drawer_$newKeyId');
    _scaffoldKeys[newKeyId] = newKey;
    activeKeyId.value = newKeyId;
    return newKey;
  }

  void openEndDrawer() {
    scaffoldKey.currentState?.openEndDrawer();
  }

  void closeEndDrawer() {
    scaffoldKey.currentState?.closeEndDrawer();
  }


  void _cleanupOldKeys() {
    if (_scaffoldKeys.length > 5) {  // Keep only recent keys
      final keysToRemove = _scaffoldKeys.keys
          .where((key) => key != activeKeyId.value)
          .take(_scaffoldKeys.length - 5);
      for (final key in keysToRemove) {
        _scaffoldKeys.remove(key);
      }
    }
  }
}