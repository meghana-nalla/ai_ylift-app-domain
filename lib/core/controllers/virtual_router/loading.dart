import 'dart:async';
import 'package:get/get.dart';
import 'package:YLift/core/controllers/z-index_export.dart';

class LoadingService extends GetxController {
  // observable boolean for loading state
  final RxBool isLoading = false.obs;

  // counter to track active loading operations
  final RxInt _activeLoadingOperations = 0.obs;

  // map to track loading operations by ID
  final _loadingOperations = <String, Completer<void>>{};

  @override
  void onInit() {
    super.onInit();
    // listen to active operations count and update isLoading appropriately
    ever(_activeLoadingOperations, (count) {
      isLoading.value = count > 0;
    });
  }

  // start a new loading operation
  Future<T> withLoading<T>({
    required Future<T> Function() operation,
    String? operationId,
  }) async {
    final id = operationId ?? DateTime.now().millisecondsSinceEpoch.toString();
    print('Starting loading operation: $id');

    try {
      _startLoading(id);
      return await operation();
    } finally {
      _endLoading(id);
    }
  }

  // handle multiple concurrent loading operations
  Future<List<T>> withMultiLoading<T>({
    required List<Future<T> Function()> operations,
    String? groupId,
  }) async {
    final id = groupId ?? DateTime.now().millisecondsSinceEpoch.toString();

    try {
      _startLoading(id);
      final futures = operations.map((op) => op()).toList();
      return await Future.wait<T>(futures);
    } finally {
      _endLoading(id);
    }
  }

  void _startLoading(String id) {
    _activeLoadingOperations.value++;
    _loadingOperations[id] = Completer<void>();
    print('Active loading operations: ${_activeLoadingOperations.value}');
  }

  void _endLoading(String id) {
    if (_activeLoadingOperations.value > 0) {
      _activeLoadingOperations.value--;
    }
    final completer = _loadingOperations.remove(id);
    if (completer != null && !completer.isCompleted) {
      completer.complete();
    }

    print('Active loading operations after end: ${_activeLoadingOperations.value}');
  }

  // cancel a specific loading operation
  void cancelLoading(String operationId) {
    if (_loadingOperations.containsKey(operationId)) {
      _endLoading(operationId);
    }
  }

  // cancel all loading operations
  void cancelAllLoading() {
    final operations = List<String>.from(_loadingOperations.keys);
    for (final id in operations) {
      cancelLoading(id);
    }
  }
}