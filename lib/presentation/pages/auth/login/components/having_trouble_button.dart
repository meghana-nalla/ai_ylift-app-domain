import 'package:YLift/core/controllers/global.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:YLift/presentation/pages/auth/having_trouble/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:galaxy_models/galaxy_models.dart';
import 'package:YLift/core/constants/index.dart';
import 'package:YLift/core/controllers/global.dart';
import 'package:YLift/presentation/components/z-index_export.dart';

class HavingTroubleButton extends StatefulWidget {
  const HavingTroubleButton({super.key});

  @override
  State<HavingTroubleButton> createState() => _HavingTroubleButtonState();
}

class _HavingTroubleButtonState extends State<HavingTroubleButton> {
  // void _goToHavingTrouble() {
  void _goToHavingTrouble() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return HavingTroubleDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: Colors.white,
            endIndent: 16,
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(

              child: Text(
                'Having Some Trouble?',
                style: TextStyle(color: Color(0xFF006AFF), fontSize: 15),

              ),
              onTap: _goToHavingTrouble,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: Colors.white,
            indent: 16,
          ),
        ),
      ],
    );
  }
}
