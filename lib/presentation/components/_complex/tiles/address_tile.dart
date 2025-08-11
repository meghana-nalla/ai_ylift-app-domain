import 'package:galaxy_models/galaxy_models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:galaxy_models/galaxy_models.dart';

class AddressTileComponent extends StatefulWidget {
  final AddressSimple? address;
  final bool? isSelected;
  final bool? isValid;
  final Widget? edit;
  final void Function()? onTap;

  const AddressTileComponent({
    super.key,
    this.address,
    this.isSelected = false,
    this.isValid = false,
    this.edit,
    required this.onTap,});

  @override
  State<AddressTileComponent> createState() => _AddressTileComponentState();
}

class _AddressTileComponentState extends State<AddressTileComponent> {
  late AddressSimple address;

  @override
  void initState() {
    address = widget.address!;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Ink(
        padding: EdgeInsets.all(16.0),
        color: widget.isSelected! ? YLiftColor.beige : null,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SafeArea(child:
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(address.display,
                    style: widget.isValid! ? TextStyle(
                        color: widget.isValid! ? Colors.black : Colors
                            .black26)
                        : TextStyle(
                        color: widget.isValid! ? Colors.black38 : Colors
                            .black26)
                ),
                Text(widget.isValid!
                    ? address.name
                    : 'Invalid address, please edit',
                    style: const TextStyle(
                        color: Colors.black38, fontSize: 13.33)),
              ],
            ),
            ),
            if (widget.isSelected!) Icon(
                        Icons.check_circle,
                        color: Colors.green,
                      ),
            SizedBox(width: 8,),
            if (widget.edit != null) widget.edit!,
          ],
        ),
      ),
    );
  }
}