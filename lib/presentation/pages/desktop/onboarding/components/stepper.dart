import 'package:YLift/models/z-index_export.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:galaxy_models/galaxy_models.dart';

class OnboardingStepper extends StatelessWidget {
  final OnboardingProcess process;
  const OnboardingStepper({
    super.key,
    required this.process,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        (OnboardingProcess.values.length - 1) * 2 - 1,
            (index) {
          if (index.isOdd) return const Expanded(child: Divider());
          final process = OnboardingProcess.values[index ~/ 2];
          final isSelected = process == this.process;
          Widget? icon;
          if (process.index < this.process.index) {
            icon = Icon(Icons.check);
          }
          return Container(
            decoration: ShapeDecoration(
              color: isSelected ? YLiftColor.khaki : null,
              shape: StadiumBorder(
                side: isSelected ? BorderSide.none : const BorderSide(),
              ),
            ),
            width: 40,
            height: 40,
            alignment: Alignment.center,
            child: icon ??
                Text(
                  '${process.index + 1}',
                  style: TextStyle(color: isSelected ? Colors.white : null),
                ),
          );
        },
      ),
    );
  }
}
