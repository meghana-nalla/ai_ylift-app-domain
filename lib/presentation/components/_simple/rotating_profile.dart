import 'dart:math' as math;
import 'package:flutter/material.dart';

class RotatingProfilePicture extends StatefulWidget {
  final String frontImageUrl;
  final String backImageUrl;
  final double size;
  final Duration rotationDuration;
  final Duration stayDuration;

  const RotatingProfilePicture({
    Key? key,
    required this.frontImageUrl,
    required this.backImageUrl,
    this.size = 100.0,
    this.rotationDuration = const Duration(milliseconds: 500),
    this.stayDuration = const Duration(seconds: 5),
  }) : super(key: key);

  @override
  _RotatingProfilePictureState createState() => _RotatingProfilePictureState();
}

class _RotatingProfilePictureState extends State<RotatingProfilePicture>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _showFrontSide = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.rotationDuration,
    );

    _startRotationTimer();
  }

  void _startRotationTimer() {
    Future.delayed(widget.stayDuration, () {
      if (mounted) {
        _controller.forward(from: 0.0).then((_) {
          setState(() {
            _showFrontSide = !_showFrontSide;
          });
          _controller.reset();
          _startRotationTimer();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final angle = _controller.value * math.pi;
        final transform = Matrix4.rotationY(angle);
        return Transform(
          transform: transform,
          alignment: Alignment.center,
          child: _showFrontSide ? _buildSide(widget.frontImageUrl) : _buildSide(widget.backImageUrl, flipped: true),
        );
      },
    );
  }

  Widget _buildSide(String imageUrl, {bool flipped = false}) {
    return Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: flipped ? Transform(
        alignment: Alignment.center,
        transform: Matrix4.rotationY(math.pi),
        child: Container(),
      ) : null,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}