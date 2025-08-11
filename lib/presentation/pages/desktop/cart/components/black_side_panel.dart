import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:galaxy_models/core/constants/y_lift_color.dart';

const _headerColor = Color(0xFF343434);
const _radius = Radius.circular(8);

class BlackSidePanel extends StatefulWidget {
  final Widget title;
  final Widget? headerIcon;
  final List<Widget> children;
  final EdgeInsets childrenPadding;

  const BlackSidePanel({
    super.key,
    required this.title,
    required this.children,
    this.headerIcon,
    this.childrenPadding = EdgeInsets.zero,
  });

  @override
  State<BlackSidePanel> createState() => _BlackSidePanelState();
}

class _BlackSidePanelState extends State<BlackSidePanel> {
  final controller = ExpansibleController();

  @override
  void initState() {
    controller.expand();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expansible(
      curve: Curves.easeInOut,
      duration: const Duration(milliseconds: 400),
      controller: controller,
      headerBuilder: (context, animation) {
        return Padding(
          padding: EdgeInsets.all(16),
          child: DefaultTextStyle.merge(
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                widget.title,
                if (widget.headerIcon != null) widget.headerIcon!,
              ],
            ),
          ),
        );
      },
      bodyBuilder: (context, animation) {
        return Padding(
          padding: widget.childrenPadding,
          child: DefaultTextStyle.merge(
            style: TextStyle(fontSize: 13.33, color: Colors.white),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(
                  color: Colors.white,
                  indent: 16 - widget.childrenPadding.left,
                  endIndent: 16 - widget.childrenPadding.right,
                  thickness: 0.5,
                  height: 2,
                ),
                const SizedBox(height: 16),
                ...widget.children,
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
      expansibleBuilder: (context, header, body, animation) {
        return Material(
          clipBehavior: Clip.hardEdge,
          color: _headerColor,
          borderRadius: const BorderRadius.all(_radius),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              header,
              body,
              _CollapsibleButton(
                animation: animation,
                onTap:
                    controller.isExpanded
                        ? controller.collapse
                        : controller.expand,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CollapsibleButton extends StatelessWidget {
  final Animation<double> animation;
  final void Function() onTap;

  const _CollapsibleButton({
    super.key,
    required this.animation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          width: double.infinity,
          height: 32,
          child: Center(
            child: Transform.rotate(
              angle: animation.value * math.pi,
              child: Icon(
                Icons.keyboard_arrow_down,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class OrangeLineTextButton extends StatelessWidget {
  final String label;
  final double fontSize;
  final bool isUnderlined;

  final void Function()? onTap;

  const OrangeLineTextButton({
    super.key,
    required this.label,
    this.fontSize = 13.33,
    this.isUnderlined = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      hoverColor: Colors.white10,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 4,
        ),
        child: SizedBox(
          width: double.infinity,
          child: Text(
            label,
            style: TextStyle(
              fontSize: fontSize,
              color: YLiftColor.orange,
              decoration:
                  isUnderlined ? TextDecoration.underline : TextDecoration.none,
              decorationColor: isUnderlined ? YLiftColor.orange : null,
            ),
          ),
        ),
      ),
    );
  }
}
