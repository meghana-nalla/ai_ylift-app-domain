import 'package:YLift/core/controllers/global.dart';
import 'package:flutter/material.dart';
import 'package:galaxy_models/core/core.dart';
import 'package:get/get.dart';

class StoreCreditToggleTile extends StatefulWidget {
  final bool value;
  final void Function(int? storeCreditBalance) onChanged;
  const StoreCreditToggleTile({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  State<StoreCreditToggleTile> createState() => _StoreCreditToggleTileState();
}

class _StoreCreditToggleTileState extends State<StoreCreditToggleTile> {
  final global = Get.find<GlobalController>();
  late Future<int?> _storeCreditBalanceFuture;

  @override
  void initState() {
    _storeCreditBalanceFuture = global.userController.getStoreCreditBalance();
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _storeCreditBalanceFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox.shrink();
        } else if (snapshot.hasError) {
          return Text('Failed to load store credit balance: ${snapshot.error}');
        } else {
          final balance = (snapshot.data ?? 0) * 100;
          if(balance == 0) return const SizedBox.shrink();

          return GestureDetector(
            onTap: () => widget.onChanged(!widget.value ? balance : null),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4.0,
                    // offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(32.0),
              width: double.infinity,
              child: Row(
                children: [
                  Text(
                    'Store Credit Available: ',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    balance.toCurrency(),
                    style: TextStyle(fontSize: 16),
                  ),
                  // const Spacer(),
                  // Switch(
                  //   value: widget.value,
                  //   onChanged: (value) {
                  //     if (value) {
                  //       widget.onChanged(balance);
                  //     } else {
                  //       widget.onChanged(balance);
                  //     }
                  //   },
                  //   activeColor: YLiftColor.orange,
                  //   trackOutlineColor: WidgetStateProperty.resolveWith(
                  //     (states) {
                  //       if (states.contains(WidgetState.selected)) {
                  //         return YLiftColor.orange;
                  //       } else {
                  //         return null;
                  //       }
                  //     },
                  //   ),
                  // ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
