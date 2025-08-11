import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:YLift/core/controllers/global.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  final GlobalController global = Get.find<GlobalController>();
  bool _isDisposed = false;
  Worker? _loadingWorker;
  Worker? _splashWorker;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _opacity = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    // setup safer workers instead of 'ever'
    _loadingWorker = ever(global.loading.isLoading, _handleLoadingChange);
    _splashWorker = ever(global.showingSplash, _handleSplashChange);

    // start animation immediately
    _controller.forward();
  }

  void _handleLoadingChange(bool isLoading) {
    if (!_isDisposed) {
      // Only start fade out when loading is complete AND splash is ready to be hidden
      // but do not act immediately on loading change alone
      if (!isLoading && !global.showingSplash.value) {
        _startFadeOut();
      }
    }
  }

  void _handleSplashChange(bool showing) {
    if (!_isDisposed) {
      // Only trigger fade out when showing is false AND loading is complete
      if (!showing && !global.loading.isLoading.value) {
        _startFadeOut();
      }
    }
  }

  Future<void> _startFadeOut() async {
    if (!_isDisposed) {
      // Check again to ensure loading is completely done before fading out
      if (!global.loading.isLoading.value && 
          _controller.status != AnimationStatus.forward &&
          _controller.status != AnimationStatus.completed) {
        await _controller.forward();
      }
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    _loadingWorker?.dispose();
    _splashWorker?.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _opacity,
      builder: (context, child) {
        return Opacity(
          opacity: _opacity.value,
          child: Scaffold(
            backgroundColor: Colors.black,
            // body: SizedBox.expand(
            //   child: Image.asset(
            //     'msc/images/Loading_optimized.gi',
            //     fit: BoxFit.cover,
            //     cacheWidth: 1920,
            //     cacheHeight: 1440,
            //     filterQuality: FilterQuality.low,
            //     gaplessPlayback: true,
            //   ),
            // ),
          ),
        );
      },
    );
  }
}