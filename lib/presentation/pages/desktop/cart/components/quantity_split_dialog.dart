import 'package:YLift/core/controllers/global.dart';
import 'package:YLift/core/repositories/address_repository.dart';
import 'package:YLift/models/z-index_export.dart';
import 'package:YLift/presentation/components/z-index_export.dart';
import 'package:YLift/presentation/pages/desktop/cart/components/shipping_options.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:galaxy_ui/galaxy_ui.dart';
import 'package:galaxy_models/galaxy_models.dart';

enum _QuantitySplitPage { selectAddresses, setQuantity }

class QuantitySplitDialog extends StatefulWidget {
  final CartItemSimple product;
  const QuantitySplitDialog({
    super.key,
    required this.product,
  });

  @override
  State<QuantitySplitDialog> createState() => _QuantitySplitDialogState();
}

class _QuantitySplitDialogState extends State<QuantitySplitDialog> {
  final global = Get.find<GlobalController>();

  static const _addressRepository = AddressRepository();
  List<AddressSimple>? addresses;

  final pageController = PageController();

  final selectedAddresses = <AddressSimple>{};
  _QuantitySplitPage _page = _QuantitySplitPage.selectAddresses;

  Map<String, (int, ShippingType)>? splitData;
  String? errorMessage;

  bool isLoading = false;

  void loadAddresses() async {
    final addresses = await _addressRepository.getAddressses(profileId: global.user.value.profileId.toString());
    setState(() {
      this.addresses = addresses;
    });
  }

  void setSplitQuantity() async {
    try {
      setState(() {
        errorMessage = null;
        isLoading = true;
      });
      if (splitData == null) return;

      final data = splitData!.entries.map((entry) {
        return {
          "shippingAddressId": entry.key,
          "quantity": entry.value.$1,
          "shippingType": entry.value.$2,
        };
      }).toList();
      data.removeWhere((element) => element['quantity'] == 0 || element['shippingType'] == ShippingType.none);
      print(data);
      if (data.isEmpty) {
        setState(() {
          errorMessage = 'Please have at least 1 quantity for each address and select the shipping options';
        });
        return;
      }

      await global.basket.setCartItemSplitQuantity(profileId: global.user.value.profileId.toString(), skuId: widget.product.sku.skuId, data: data);
      if (!mounted) return;
      Navigator.pop(context);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    loadAddresses();
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Split Quantity'),
      content: addresses == null
          ? null
          : SizedBox(
              width: 560,
              height: 600,
              child: Column(
                children: [
                  Expanded(
                    child: PageView(
                      physics: const NeverScrollableScrollPhysics(),
                      controller: pageController,
                      children: [
                        // Select addresses
                        ListView.builder(
                          itemCount: addresses!.length,
                          itemBuilder: (context, index) {
                            final address = addresses![index];
                            // final isSelected = address.addressId == selectedAddress?.addressId;
                            final isSelected = selectedAddresses.contains(address);

                            return ListTile(
                              onTap: () {
                                if (selectedAddresses.contains(address)) {
                                  setState(() {
                                    selectedAddresses.remove(address);
                                  });
                                  return;
                                }
                                setState(() {
                                  selectedAddresses.add(address);
                                });
                              },
                              title: Text(address.display),
                              subtitle: Text(address.name, style: const TextStyle(color: Colors.black38)),
                              trailing: isSelected ? const Icon(Icons.check_circle, color: Colors.green) : null,
                            );
                          },
                        ),

                        // Set quantities
                        ListView.separated(
                          itemCount: selectedAddresses.length,
                          separatorBuilder: (context, index) => const GapY(),
                          itemBuilder: (context, index) {
                            final address = selectedAddresses.elementAt(index);
                            final data = splitData![address.addressId]!;

                            return Column(
                              children: [
                                Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(address.display),
                                        Text(address.name, style: const TextStyle(color: Colors.black38)),
                                      ],
                                    ),
                                    const Spacer(),
                                    QuantityCounter(
                                      value: data.$1,
                                      quantityRule: QuantityRule(
                                        min: widget.product.sku.quantityMinimum,
                                        max: widget.product.sku.quantityMaximum,
                                        increment: widget.product.sku.quantityIncrement,
                                      ),
                                      onChanged: (newValue) {
                                        setState(() {
                                          splitData![address.addressId] = (newValue, data.$2);
                                        });
                                      },
                                    )
                                  ],
                                ),
                                OverflowBar(
                                  children: [
                                    ShippingOption(
                                      isSelected: data.$2 == ShippingType.regular,
                                      onTap: () {
                                        setState(() {
                                          splitData![address.addressId] = (data.$1, ShippingType.regular);
                                        });
                                      },
                                      labelText:
                                          'Regular Ground \$${widget.product.shippingSettings!.regularRate / 100}',
                                    ),
                                    ShippingOption(
                                      isSelected: data.$2 == ShippingType.express,
                                      onTap: () {
                                        setState(() {
                                          splitData![address.addressId] = (data.$1, ShippingType.express);
                                        });
                                      },
                                      labelText:
                                          'Express 2 Days \$${widget.product.shippingSettings!.expressRate / 100}',
                                    ),
                                    ShippingOption(
                                      isSelected: data.$2 == ShippingType.overnight,
                                      onTap: () {
                                        setState(() {
                                          splitData![address.addressId] = (data.$1, ShippingType.overnight);
                                        });
                                      },
                                      labelText: 'Overnight \$${widget.product.shippingSettings!.overnightRate / 100}',
                                    ),
                                  ],
                                )
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  if (errorMessage != null) Text(errorMessage!, style: const TextStyle(color: Colors.red)),
                ],
              ),
            ),
      actions: _buildActions(),
    );
  }

  List<Widget> _buildActions() {
    if (isLoading) return const [CircularProgressIndicator()];

    if (_page == _QuantitySplitPage.selectAddresses) {
      return [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            if (selectedAddresses.isEmpty) return;
            splitData = {for (final address in selectedAddresses) address.addressId: (1, ShippingType.none)};

            setState(() {
              _page = _QuantitySplitPage.setQuantity;
            });

            pageController.animateToPage(
              1,
              duration: const Duration(milliseconds: 200),
              curve: Curves.linear,
            );
          },
          child: const Text('Next'),
        ),
      ];
    } else {
      return [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              _page = _QuantitySplitPage.selectAddresses;
            });
            pageController.previousPage(duration: const Duration(milliseconds: 200), curve: Curves.linear);
          },
          child: const Text('Back'),
        ),
        FilledButton(
          onPressed: setSplitQuantity,
          child: const Text('Finish'),
        ),
      ];
    }
  }
}

class SelectAddressesPage extends StatefulWidget {
  final List<AddressSimple> addresses;

  const SelectAddressesPage({
    super.key,
    required this.addresses,
  });

  @override
  State<SelectAddressesPage> createState() => _SelectAddressesPageState();
}

class _SelectAddressesPageState extends State<SelectAddressesPage> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {},
    );
  }
}
