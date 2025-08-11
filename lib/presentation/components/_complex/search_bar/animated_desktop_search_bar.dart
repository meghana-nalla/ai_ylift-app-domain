import 'package:flutter/material.dart';
import 'package:YLift/presentation/components/_complex/search_bar/normal_search_bar.dart';
import 'package:YLift/presentation/components/_complex/search_bar/desktop_search_bar.dart';


class AnimatedDesktopSearchBar extends StatefulWidget {
  final bool isVisible;
  const AnimatedDesktopSearchBar({Key? key, required this.isVisible})
      : super(key: key);
  @override
  _AnimatedDesktopSearchBarState createState() => _AnimatedDesktopSearchBarState();
}

class _AnimatedDesktopSearchBarState extends State<AnimatedDesktopSearchBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<double>(begin: -60, end: 0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    if (widget.isVisible) {
      _animationController.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(AnimatedDesktopSearchBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible != oldWidget.isVisible) {
      if (widget.isVisible) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _animation.value),
          child: widget.isVisible
              ? DesktopSearchBar()
              : Container(),
        );
      },
    );
  }
}
