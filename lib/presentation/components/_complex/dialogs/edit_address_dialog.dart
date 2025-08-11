import 'package:YLift/core/constants/constant.dart';
import 'package:YLift/models/z-index_export.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'package:YLift/core/controllers/global.dart';
import 'package:galaxy_models/galaxy_models.dart';
import 'package:YLift/presentation/components/z-index_export.dart';

class EditAddressDialog extends StatelessWidget {
  final AddressSimple address;
  final void Function(AddressSimple) onEdit;

  const EditAddressDialog({
    super.key,
    required this.address,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Dialog(
        backgroundColor: Colors.white,
        shape: const Border(),
        child: Padding(
          padding: const EdgeInsets.all(YLiftConstant.gap),
          child: SizedBox(
            width: 640,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Edit Address', style: TextStyle(fontSize: 24)),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.clear),
                    ),
                  ],
                ),
                const Divider(height: YLiftConstant.gap * 2),
                AddressForm(
                  address: address,
                  // TODO: inject this
                  controller: Get.find<GlobalController>(),
                  onCancel: () {
                    Navigator.pop(context);
                  },
                  onSubmit: (address) {
                    Navigator.pop(context);
                    onEdit(address);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
