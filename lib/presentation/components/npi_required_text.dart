import 'package:YLift/core/controllers/global.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:galaxy_models/core/constants/y_lift_color.dart';
import 'package:get/get.dart';

class NPIRequiredText extends StatefulWidget {
  const NPIRequiredText({super.key});

  @override
  State<NPIRequiredText> createState() => _NPIRequiredTextState();
}

class _NPIRequiredTextState extends State<NPIRequiredText> {
  final global = Get.find<GlobalController>();
  final addNPIRecognizer = TapGestureRecognizer();

  @override
  void initState() {
    addNPIRecognizer.onTap = (){
      global.vroute.navigateTo('/profile#medical_license');
    };
    super.initState();
  }

  @override
  void dispose() {
    addNPIRecognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          color: YLiftColor.orange,
          fontSize: 13.33,
        ),
        children: [
          TextSpan(
            text: 'This product requires an NPI number. ',
          ),
          TextSpan(
            mouseCursor: SystemMouseCursors.click,
            recognizer: addNPIRecognizer,
            text: 'Add NPI to your medical license >>',
            style: const TextStyle(
              decoration: TextDecoration.underline,
            ),
          ),
        ],
      ),
    );
  }
}
