import 'package:flutter/material.dart';

class RegistrationStep extends StatefulWidget {
  final int step;
  final String title;
  final Widget content;
  final List<Widget> actions;
  final bool isExpanded;
  final bool isCompleted;

  const RegistrationStep({
    super.key,
    required this.step,
    required this.title,
    required this.content,
    this.isExpanded = false,
    this.isCompleted = false,
    this.actions = const <Widget>[],
  });

  @override
  State<RegistrationStep> createState() => _RegistrationStepState();
}

class _RegistrationStepState extends State<RegistrationStep> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isExpanded = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    if(widget.isExpanded) _controller.value = 1.0;
  }

  @override
  void didUpdateWidget(covariant RegistrationStep oldWidget) {
    if (widget.isExpanded) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 40,
          child: Row(
            children: [
              Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black,
                ),
                width: 40,
                height: 40,
                alignment: Alignment.center,
                child: Text(
                  '${widget.step}',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(width: 16),
              Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  height: 0.8,
                ),
              ),
              const SizedBox(width: 16),
              if (widget.isCompleted) Icon(Icons.check_circle, color: Colors.green),
            ],
          ),
        ),
        Row(
          children: [
            const SizedBox(width: 40 + 16),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: SizeTransition(
                  sizeFactor: _animation,
                  child: widget.content,
                ),
              ),
            ),
          ],
        ),
      ],
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black,
          ),
          width: 40,
          height: 40,
          alignment: Alignment.center,
          child: Text(
            '${widget.step}',
            style: const TextStyle(color: Colors.white),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: _toggleExpanded,
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 2, bottom: 16),
                        child: Text(
                          widget.title,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    RotationTransition(
                      turns: Tween(begin: 0.0, end: 0.5).animate(_animation),
                      child: const Icon(Icons.keyboard_arrow_down),
                    ),
                  ],
                ),
              ),
              SizeTransition(
                sizeFactor: _animation,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    widget.content,
                    if (widget.actions.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Row(
                        children: widget.actions,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
