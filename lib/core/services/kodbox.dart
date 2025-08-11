import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web/web.dart' as web;

class StorageChild {
  final String sign;
  final String type;
  final Map<String, String>? description;
  final bool? domestic;

  StorageChild({
    required this.sign,
    required this.type,
    this.description,
    this.domestic,
  });
}

class KodBoxService {
  static final KodBoxService _instance = KodBoxService._internal();
  factory KodBoxService() => _instance;

  KodBoxService._internal();

  final Map<String, dynamic> _storageBoxProperty = {};
  final Map<String, Function> _lambdaProperty = {};
  final BehaviorSubject<Map<String, dynamic>> _sBoxSubject = BehaviorSubject<Map<String, dynamic>>.seeded({});

  Stream<Map<String, dynamic>> get sBoxObservable$ => _sBoxSubject.stream;

  bool _firewallSetOnceOpened = false;
  bool _isWeb = false;

  void _setStorageBox(Map<String, dynamic> newStorageBox, {bool beingSet = false}) {
    if (beingSet && _firewallSetOnceOpened) {
      _firewallSetOnceOpened = false;
      _savePersistence(newStorageBox);
    }
    _sBoxSubject.add(newStorageBox);
  }

  Future<void> _savePersistence(Map<String, dynamic> newStorageBox) async {
    if (_isWeb) {
      _saveToCookie(newStorageBox);
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('StorageBox', jsonEncode(newStorageBox));
    }
  }

  void _saveToCookie(Map<String, dynamic> newStorageBox) {
    final cookieValue = jsonEncode(newStorageBox);
    final expirationDate = DateTime.now().add(Duration(days: 30));
    web.document.cookie = 'StorageBox=$cookieValue; expires=${expirationDate.toUtc()}; path=/';
  }

  Map<String, dynamic>? _getFromCookie() {
    final cookies = web.document.cookie?.split(';') ?? [];
    for (var cookie in cookies) {
      var parts = cookie.trim().split('=');
      if (parts[0] == 'StorageBox') {
        return jsonDecode(Uri.decodeComponent(parts[1]));
      }
    }
    return null;
  }

  Future<void> initialize() async {
    _isWeb = kIsWeb;
    if (_isWeb) {
      final cookieData = _getFromCookie();
      if (cookieData != null) {
        _storageBoxProperty.addAll(cookieData);
        _setStorageBox(_storageBoxProperty, beingSet: true);
      }
    } else {
      final prefs = await SharedPreferences.getInstance();
      final storageBoxJson = prefs.getString('StorageBox');
      if (storageBoxJson != null) {
        final storageBoxProperties = jsonDecode(storageBoxJson);
        _storageBoxProperty.addAll(storageBoxProperties);
        _setStorageBox(_storageBoxProperty, beingSet: true);
      }
    }
  }

  dynamic getProperty(String key) => _storageBoxProperty[key];

  void setProperty(String key, dynamic value) {
    _storageBoxProperty[key] = value;
  }

  void setLambda(String functionName, Function bindedFunctionReference) {
    if (kDebugMode) {
      some_print("\t\tBinding Function { $functionName } to the lambdaProperty object");
    }
    _lambdaProperty[functionName] = bindedFunctionReference;
  }

  Future<dynamic> get(String key) async {
    if (_storageBoxProperty.containsKey(key)) {
      return _storageBoxProperty[key];
    } else {
      if (_isWeb) {
        final cookieData = _getFromCookie();
        if (cookieData != null && cookieData.containsKey(key)) {
          _storageBoxProperty.addAll(cookieData);
          _firewallSetOnceOpened = true;
          _setStorageBox(_storageBoxProperty, beingSet: true);
          return _storageBoxProperty[key];
        }
      } else {
        final prefs = await SharedPreferences.getInstance();
        final storageBoxJson = prefs.getString('StorageBox');
        if (storageBoxJson != null) {
          final storageBoxProperties = jsonDecode(storageBoxJson);
          if (storageBoxProperties.containsKey(key)) {
            _storageBoxProperty.addAll(storageBoxProperties);
            _firewallSetOnceOpened = true;
            _setStorageBox(_storageBoxProperty, beingSet: true);
            return _storageBoxProperty[key];
          }
        }
      }
      return null;
    }
  }

  Future<void> set(String key, dynamic value, {bool readonly = false, bool updatePersistence = false}) async {
    if (!readonly) {
      _storageBoxProperty[key] = value;
    } else {
      _storageBoxProperty['_$key'] = value;
      _storageBoxProperty[key] = () => _storageBoxProperty['_$key'];
    }

    if (updatePersistence) {
      await _savePersistence(_storageBoxProperty);
    }
    _setStorageBox(_storageBoxProperty);
  }

  dynamic lambda(String bindedFunctionName) {
    if (_lambdaProperty.containsKey(bindedFunctionName)) {
      return _lambdaProperty[bindedFunctionName];
    } else {
      some_print("\tFunction $bindedFunctionName does not exist inside the lambdaProperty object, maybe it was never bound?");
      return null;
    }
  }

  bool has(String key) {
    return _storageBoxProperty.containsKey(key) || _lambdaProperty.containsKey(key);
  }

  bool binded(String key) {
    return _storageBoxProperty.containsKey(key) && _lambdaProperty.containsKey(key);
  }

  void update() {
    _setStorageBox(_storageBoxProperty);
  }

  Future<void> updateAsync({bool rewritePersistence = false}) async {
    if (rewritePersistence) {
      _firewallSetOnceOpened = true;
    }
    _setStorageBox(_storageBoxProperty, beingSet: rewritePersistence);
  }

  void remove(String key, {bool destroy = false}) {
    if (destroy || _storageBoxProperty.containsKey(key)) {
      _storageBoxProperty.remove(key);
    } else {
      some_print("$key Property is readonly or doesn't exist. Cannot be removed.");
    }
  }

  Future<void> destroy() async {
    _storageBoxProperty.clear();
    _lambdaProperty.clear();
    if (_isWeb) {
      web.document.cookie = 'StorageBox=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;';
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('StorageBox');
    }
    _setStorageBox(_storageBoxProperty);
  }

  void some_print(String s, {bool detailed = false, bool printData = false}) {
    if (detailed) {
      _storageBoxProperty.forEach((key, value) {
        print("StorageBox Property: $key");
        if (printData) {
          print("Value: $value");
        }
      });
    } else {
      _storageBoxProperty.keys.forEach((key) {
        print("StorageBox Property: $key");
      });
    }
  }
}