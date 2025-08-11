import 'package:YLift/core/repositories/image_repository.dart';
import 'package:YLift/presentation/components/z-index_export.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:YLift/core/controllers/global.dart';

class WhatsNewSection extends StatelessWidget {
  const WhatsNewSection({super.key});

  static const List<String> images = [
    '60325aa7-8c2b-4e21-8484-ccf045e1e126',
    '23150dbd-3b7d-4dd0-8f43-e53ec23af9fc',
    '11e43420-0d2b-4c19-8332-35e37d47764a',
    'd69c4886-5459-427a-ad45-5e0f3d0dec3f'
  ];
  static const _imageRepository = ImageRepository();
  static final global = Get.find<GlobalController>();

  Widget _buildNetworkImage(
      String imageId,
      String title,
      String description,
      Function() onTap,
      ) {
    return HoverableImage(
      imageUrl: _imageRepository.getImageUrl(imageId),
      title: title,
      description: description,
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SectionTitle(labelText: 'What\'s New'),
        SizedBox(
          height: 400,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _buildNetworkImage(
                  images[1],
                  'Shop Sculptra®',
                  'Explore the biostimulatory aesthetic injectable',
                  () {
                    global.vroute.navigateToProduct(553);
                  },
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: _buildNetworkImage(
                        images[2],
                        'Shop All Brands',
                        'Discover our latest products',
                          () {
                            global.vroute.navigateTo('/shop/all_brands');
                          },
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildNetworkImage(
                              images[3],
                              'Become A Provider',
                              'Register to learn the \'30 Minute Miracle Facelift\' and more',
                                () {
                                  global.vroute.navigateTo('/training');
                                },
                            ),
                          ),
                          Expanded(
                            child: _buildNetworkImage(
                              images[0],
                              'Shop Dysport®',
                              'Click to learn more',
                                () {
                                  global.vroute.navigateToProduct(554);
                                },
                            ),
                          ),
                        ],
                      ),
                    ),
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

class HoverableImage extends StatefulWidget {
  final String imageUrl;
  final String title;
  final String description;
  final VoidCallback onTap;

  const HoverableImage({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  State<HoverableImage> createState() => _HoverableImageState();
}

class _HoverableImageState extends State<HoverableImage> with SingleTickerProviderStateMixin {
  bool isHovered = false;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<double>(begin: -1, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() => isHovered = true);
        _controller.forward();
      },
      onExit: (_) {
        setState(() => isHovered = false);
        _controller.reverse();
      },
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // The base image that's always visible
                Image.network(
                  widget.imageUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Icon(Icons.error_outline, color: Colors.red),
                    );
                  },
                ),
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, _animation.value * 400),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                        ),
                        // The overlay content
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.title,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  widget.description,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}