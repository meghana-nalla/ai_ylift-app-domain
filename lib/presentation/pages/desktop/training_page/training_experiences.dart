import 'package:YLift/core/constants/constant.dart';
import 'package:YLift/core/constants/index.dart';
import 'package:YLift/models/z-index_export.dart';
import 'package:flutter/material.dart';
import 'package:galaxy_ui/galaxy_ui.dart';
class _PhotoData {
  final String imageUrl;
  final String title;
  final String subtitle;

  const _PhotoData({
    required this.imageUrl,
    required this.title,
    required this.subtitle,
  });

  static final list = <_PhotoData>[
    _PhotoData(
      imageUrl: '$API_WEB_LINK/${ApiUrl.getImage.path}/78242a79-6ec2-4ac4-8eb5-c927f36063b6',
      title: 'Shape Aesthetics and Wellness & Dermally',
      subtitle: 'SurgYLift Training',
    ),
    _PhotoData(
      imageUrl: '$API_WEB_LINK/${ApiUrl.getImage.path}/c803b405-4430-4fdc-8abb-bbea3b348ff0',
      title: 'Revitalize Medspa',
      subtitle: 'Y LIFT Training',
    ),
    _PhotoData(
      imageUrl: '$API_WEB_LINK/${ApiUrl.getImage.path}/7260ab10-fa82-4be7-a645-128255e83f50',
      title: 'Chernoff Cosmetic Surgery Indianapolist',
      subtitle: 'MagnYm Training',
    ),
    _PhotoData(
      imageUrl: '$API_WEB_LINK/${ApiUrl.getImage.path}/4280430d-f644-4f12-9463-f24f40ffeadc',
      title: 'Shape Aesthetics and Wellness & Dermally',
      subtitle: 'SurgYLift Training',
    ),
    _PhotoData(
      imageUrl: '$API_WEB_LINK/${ApiUrl.getImage.path}/887c6eee-e15e-4bd7-a55f-f00b685be626',
      title: 'Shape Aesthetics and Wellness & Dermally',
      subtitle: 'SurgYLift Training',
    ),
    _PhotoData(
      imageUrl: '$API_WEB_LINK/${ApiUrl.getImage.path}/ce988a5f-7788-40c2-9bad-8706fa678e01',
      title: 'Omni Aesthetics',
      subtitle: 'SurgYLift Training',
    ),
    _PhotoData(
      imageUrl: '$API_WEB_LINK/${ApiUrl.getImage.path}/c84c3b1d-d9f6-4bad-857f-cb40b12266bd',
      title: 'Princeton Plastic Surgeons',
      subtitle: 'Y LIFT + SurgYLift Training',
    ),
    _PhotoData(
      imageUrl: '$API_WEB_LINK/${ApiUrl.getImage.path}/2d567458-aae6-4309-8fea-87a2264dddae',
      title: 'Charlie Sheen\'s SurgYLift Transformation',
      subtitle: 'Y LIFT + West Coast plastic Surgery Center',
    ),
  ];
}

class TrainingExperiences extends StatefulWidget {
  const TrainingExperiences({super.key});

  @override
  State<TrainingExperiences> createState() => _TrainingExperiencesState();
}

class _TrainingExperiencesState extends State<TrainingExperiences> {
  final scrollController = ScrollController();

  static const _width = 440.0;
  static const _gap = 30.0;

  bool isAtStart = true;
  bool isAtEnd = false;

  void scrollListener() {
    final position = scrollController.position;
    setState(() {
      isAtStart = position.pixels == position.minScrollExtent;
      isAtEnd = position.pixels == position.maxScrollExtent;
    });
  }

  void scrollLeft() async {
    var nextPosition = scrollController.position.pixels - _width;
    if (nextPosition < 0 || nextPosition < _width) nextPosition = 0;
    await scrollController.animateTo(
      nextPosition,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void scrollRight() async {
    var nextPosition = scrollController.position.pixels + _width + _gap;
    final max = scrollController.position.maxScrollExtent;
    if (nextPosition > max) nextPosition = max;
    await scrollController.animateTo(
      nextPosition,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void initState() {
    scrollController.addListener(scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: YLiftConstant.pageWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Training experience with Us', style: TextStyle(fontSize: 33, fontWeight: FontWeight.bold)),
              const Spacer(),
              ArrowButton(
                direction: ArrowDirection.left,
                onPressed: isAtStart ? null : scrollLeft,
              ),
              const SizedBox(width: 16),
              ArrowButton(
                direction: ArrowDirection.right,
                onPressed: isAtEnd ? null : scrollRight,
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 330,
            child: ListView.separated(
              controller: scrollController,
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: _PhotoData.list.length,
              separatorBuilder: (context, index) => const SizedBox(width: _gap),
              itemBuilder: (context, index) {
                final photo = _PhotoData.list[index];
                return SizedBox(
                  width: _width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        child: Image.network(photo.imageUrl),
                      ),
                      const SizedBox(height: 16),
                      Text(photo.title, style: TextStyle(fontWeight: FontWeight.w500)),
                      Text(photo.subtitle, style: TextStyle(fontSize: 13.33, fontWeight: FontWeight.w500)),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
