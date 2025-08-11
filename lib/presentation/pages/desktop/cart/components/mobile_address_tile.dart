import 'package:flutter/material.dart';
import 'package:galaxy_models/galaxy_models.dart';

class MobileAddressTile extends StatefulWidget {
  final AddressSimple? address;
  final VoidCallback? onTap;

  const MobileAddressTile({
    super.key,
    required this.address,
    this.onTap,
  });

  @override
  State<MobileAddressTile> createState() => _CollapsibleAddressTileState();
}

class _CollapsibleAddressTileState extends State<MobileAddressTile> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final address = widget.address;

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Color(0x11000000),
              blurRadius: 6,
              offset: Offset(0, 1),
              spreadRadius: 1,
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Row: Label + Short address + Chevron
            Row(
              children: [
                const Text(
                  'Address',
                  style: TextStyle(
                    color: Color(0xFF343434),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    address!.display ?? 'No address selected',
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF787878),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      height: 1.2,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
                IconButton(
                  icon: AnimatedRotation(
                    duration: const Duration(milliseconds: 200),
                    turns: _isExpanded ? 0.5 : 0,
                    child: const Icon(Icons.keyboard_arrow_down_rounded),
                  ),
                  onPressed: () => setState(() => _isExpanded = !_isExpanded),
                ),
              ],
            ),

            /// Expanded info
            if (_isExpanded && address != null) ...[
              const SizedBox(height: 8),
              Text(
                address.display,
    style: const TextStyle(
                  color: Colors.black,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${address.name} • ${address.phone}',
                style: const TextStyle(
                  color: Color(0xFF818181),
                  fontSize: 13,
                ),
              ),
              if (address.isValid == false)
                const Padding(
                  padding: EdgeInsets.only(top: 4),
                  child: Text(
                    'Invalid address, please select another one.',
                    style: TextStyle(color: Color(0xFFE57300), fontSize: 11),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
