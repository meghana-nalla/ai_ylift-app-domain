import 'package:YLift/core/controllers/global.dart';
import 'package:YLift/presentation/pages/desktop/__primary_courses/components/events_checkout/event_detail_dialog.dart';
import 'package:flutter/material.dart';
import 'package:galaxy_ui/galaxy_ui.dart';
import 'package:get/get.dart';
import 'package:galaxy_models/galaxy_models.dart';
class MyMobileVideoLibrarySection extends StatefulWidget {
  const MyMobileVideoLibrarySection({super.key});

  @override
  State<MyMobileVideoLibrarySection> createState() => _MyVideoLibrarySectionState();
}

class _MyVideoLibrarySectionState extends State<MyMobileVideoLibrarySection> {
  final _global = Get.find<GlobalController>();

  bool isLoading = false;
  List<VirtualContent> videos = <VirtualContent>[];
  List<TrainingCourse> trainingCourses = <TrainingCourse>[];

  @override
  void initState() {
    loadVideos();
    super.initState();
  }

  void loadVideos() async {
    try {
      setState(() {
        isLoading = true;
      });
      final videos = _global.user.value.virtualContent ?? <VirtualContent>[];
      final trainingCourses = await _global.userController.getTrainingCourses();
      final trainingVideos = trainingCourses.map(
            (e) => VirtualContent(
          type: VirtualProductsType.training,
          name: e.name,
          image: e.videos.firstOrNull?.thumbnailUrl,
          description: '',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          virtualProductId: '',
        ),
      );

      setState(() {
        this.videos.clear();
        this.videos = [...videos, ...trainingVideos];
        this.trainingCourses = trainingCourses;
      });
    } catch (e) {
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void navigateToVideo(
      String videoName, {
        Map<String, dynamic>? metadata,
        required VirtualContent video,
      }) async {
    videoName = videoName.toLowerCase();
    // if (videoName.contains('zoe')) {
    if (video.metadata['type'] == 'TRAINING') {
      await _global.vroute.navigateTo('/courses/view/${video.virtualProductId}');
      return;
    } else if (video.metadata['type'] == 'EVENTS_PHYSICAL') {
      if (metadata == null) return;
      showDialog(
        context: context,
        builder:
            (context) => EventDetailDialog(
          name: metadata['name'] ?? '',
          imageUrl: metadata['imageUrl'] ?? metadata['image'] ?? '',
          description: metadata['title'] ?? '',
        ),
      );
      return;
    } else {
      final course = trainingCourses.firstWhereOrNull(
            (course) => course.name.toLowerCase() == videoName,
      );
      if (course == null) return;
      _global.selectedTrainingCourse.value = course;
      _global.vroute.navigateTo('/training/videos/${course.name}');
    }
  }

  String getThumbnailUrl(VirtualContent video) {
    final videoName = video.name?.toLowerCase() ?? '';
    if (videoName.contains('booty')) {
      return 'https://media.stage.ylift.app/api/optimized/variant/image/file/6587cc8f-80b3-43bd-8036-d2cc560e5257';
    }
    if (videoName.contains('mag')) {
      return 'https://media.stage.ylift.app/api/optimized/variant/image/file/aea9be54-4373-4764-a430-57adc357add7';
    }
    return video.metadata['imageUrl'] ?? video.image ?? '';
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const SizedBox.shrink();
    }
    if (videos.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Your purchased content will show up here. If you just purchased new content, please refresh the page.',
          style: TextStyle(
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(), // ✅ Add this line
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 400,
            mainAxisExtent: 280,
            crossAxisSpacing: 24,
            mainAxisSpacing: 24,
          ),
          itemCount: videos.length,
          itemBuilder: (context, index) {
            final video = videos[index];
            final title = video.name?.isNotEmpty ?? false
                ? video.name!
                : video.description;
            return MyMobileVideoCourseCard(
              thumbnailUrl: getThumbnailUrl(video),
              title: video.metadata['title'] ?? title,
              authorName: video.metadata['authorName'] ?? '',
              chapters: '',
              onTap: () => navigateToVideo(title, metadata: video.metadata, video: video),
            );
          },
        ),

      ],
    );
  }
}
