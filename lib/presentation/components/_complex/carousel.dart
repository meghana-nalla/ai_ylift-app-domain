import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';


import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:YLift/presentation/components/z-index_export.dart';



class ImageCarousel extends StatefulWidget {
  final List<Map<String, String>> items;
  ImageCarousel({required this.items});
  @override
  _ImageCarouselState createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  List<Size> _imageSizes = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _preloadImageDimensions();
  }

  Future<void> _preloadImageDimensions() async {
    List<Size> imageSizes = [];
    for (var item in widget.items) {
      final size = await _calculateImageDimension(item['imageUrl']!);
      imageSizes.add(size);
    }
    setState(() {
      _imageSizes = imageSizes;
      _loading = false;
    });
  }

  Future<Size> _calculateImageDimension(String imageUrl) async {
    final Completer<Size> completer = Completer();
    final Image image = Image.network(imageUrl);
    image.image.resolve(ImageConfiguration()).addListener(
      ImageStreamListener((ImageInfo info, bool _) {
        completer.complete(
            Size(info.image.width.toDouble(), info.image.height.toDouble()));
      }),
    );
    return completer.future;
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Center(child: CircularProgressIndicator());
    }

    if (widget.items.length == 1) {
      // If there's only one item, return a stationary image
      final imageUrl = widget.items[0]['imageUrl']!;
      final aspectRatio = _imageSizes[0].width / _imageSizes[0].height;
      final height = MediaQuery.of(context).size.width / aspectRatio;
      return GestureDetector(
        onTap: () => _launchURL(widget.items[0]['link']!),
        child: Container(
          height: height,
          width: MediaQuery.of(context).size.width,
          child: ImageWithFallback(imageUrl: imageUrl),
        ),
      );
    }

    // If there's more than one item, we use the carousel
    return CarouselSlider.builder(
      options: CarouselOptions(
        enlargeCenterPage: true,
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 3),
        autoPlayAnimationDuration: Duration(milliseconds: 800),
        autoPlayCurve: Curves.fastOutSlowIn,
        pauseAutoPlayOnTouch: true,
        viewportFraction: 0.8,
      ),
      itemCount: widget.items.length,
      itemBuilder: (BuildContext context, int index, int realIndex) {
        final imageUrl = widget.items[index]['imageUrl']!;
        final aspectRatio =
            _imageSizes[index].width / _imageSizes[index].height;
        final height = MediaQuery.of(context).size.width / aspectRatio;
        return GestureDetector(
          onTap: () => _launchURL(widget.items[index]['link']!),
          child: Container(
            height: height,
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.symmetric(horizontal: 5.0),
            child: ImageWithFallback(imageUrl: imageUrl),
          ),
        );
      },
    );
  }
}
