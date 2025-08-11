import 'package:YLift/core/controllers/global.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StoreCreditLoader extends StatefulWidget {
  final Widget Function()? onLoading;

  /// Builder function that receives the store credit balance.
  ///
  /// The `balance` parameter is the store credit balance in cents.
  final Widget Function(BuildContext context, int balance) builder;

  const StoreCreditLoader({
    super.key,
    required this.builder,
    this.onLoading,
  });

  @override
  State<StoreCreditLoader> createState() => _StoreCreditLoaderState();
}

class _StoreCreditLoaderState extends State<StoreCreditLoader> {
  final global = Get.find<GlobalController>();
  late Future<int?> _storeCreditFuture;

  @override
  void initState() {
    _storeCreditFuture = global.userController.getStoreCreditBalance();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _storeCreditFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox.shrink();
        } else if (snapshot.hasError) {
          return Text('Failed to load store credit');
        }
        final balance = (snapshot.data ?? 0) * 100;
        if (balance == 0) return const SizedBox.shrink();
        return widget.builder(context, balance);
      },
    );
  }
}
