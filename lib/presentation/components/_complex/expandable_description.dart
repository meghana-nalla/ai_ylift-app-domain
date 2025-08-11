import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class ExpandableDescription extends StatefulWidget {
  final String description;

  const ExpandableDescription({
    super.key,
    required this.description,
  });

  @override
  State<ExpandableDescription> createState() => _ExpandableDescriptionState();
}

class _ExpandableDescriptionState extends State<ExpandableDescription> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      initiallyExpanded: true,
      title: const Text('Product Description'),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: isExpanded ? null : 72, // limit height to 3 lines
                child: Stack(
                  children: [
                    Html(
                      data: widget.description,
                    ),
                    if (!isExpanded)
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 32,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.white.withOpacity(0),
                                Colors.white,
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              if (!isExpanded)
                TextButton(
                  onPressed: () {
                    setState(() {
                      isExpanded = true;
                    });
                  },
                  child: const Text('Show more...'),
                ),
              if(isExpanded)
                TextButton(
                  onPressed: () {
                    setState(() {
                      isExpanded = false;
                    });
                  },
                  child: const Text('Show less...'),
                ),
            ],
          ),
        ),
      ],
    );
  }
}