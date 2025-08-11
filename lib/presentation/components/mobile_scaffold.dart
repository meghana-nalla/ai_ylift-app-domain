import 'package:flutter/material.dart';

class MobileScaffold extends StatelessWidget {
  final void Function()? onBackPressed;
  final String title;

  final Color? backgroundColor;

  final Widget? bottomBar;
  final Widget body;

  const MobileScaffold({
    super.key,
    required this.title,
    required this.body,
    this.onBackPressed,
    this.bottomBar,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return SelectionArea(
      child: Scaffold(
        backgroundColor: backgroundColor ?? Colors.grey.shade100,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MobileTopBar(
                title: title,
                onBackPressed: onBackPressed,
              ),
              Expanded(
                child: body,
              ),
              if (bottomBar != null) bottomBar!,
            ],
          ),
        ),
      ),
    );
  }
}

class MobileTopBar extends StatelessWidget {
  final void Function()? onBackPressed;
  final String title;

  const MobileTopBar({
    super.key,
    this.onBackPressed,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return MobileBar(
      height: 48,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (onBackPressed != null)
            Positioned(
              left: 8,
              child: IconButton(
                onPressed: onBackPressed,
                icon: const Icon(Icons.chevron_left),
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
              ),
            ),
          Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class MobileBar extends StatelessWidget {
  final double? height;
  final EdgeInsets padding;
  final Widget child;

  const MobileBar({
    super.key,
    required this.child,
    this.height,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
          ),
        ],
      ),
      height: height,
      width: double.infinity,
      padding: padding,
      child: child,
    );
  }
}
