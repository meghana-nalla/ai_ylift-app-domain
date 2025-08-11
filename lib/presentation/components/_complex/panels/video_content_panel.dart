import 'package:YLift/core/controllers/global.dart';
import 'package:YLift/presentation/components/z-index_export.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:galaxy_ui/galaxy_ui.dart';
import 'package:galaxy_models/galaxy_models.dart';
class VideoContentsPanel extends StatefulWidget {
  const VideoContentsPanel({super.key});

  @override
  State<VideoContentsPanel> createState() => _VideoContentsPanelState();
}

class _VideoContentsPanelState extends State<VideoContentsPanel> {
  final GlobalController global = Get.find<GlobalController>();
  bool _isLoading = false;

  final trainings = <TrainingCourse>[];

  Future<void> fetchVideoContents() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final trainingCourses = await global.userController.getTrainingCourses();
      setState(() {
        trainings.addAll(trainingCourses);
      });
    } catch (e, s) {
      print('$e\n$s');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    fetchVideoContents();
    super.initState();
  }

  Future<void> refreshVideoContents() async {
    setState(() {
      _isLoading = true;
    });

    await fetchVideoContents();
    setState(() {
      _isLoading = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (trainings.isEmpty) {
      return buildNoVideoListFound(context);
    }

    return Column(
      children: [
        ...trainings.map((course) {
          return Card(
            clipBehavior: Clip.hardEdge,
            child: ListTile(
              tileColor: Colors.white,
              title: Text(course.name),
              onTap: () {
                global.selectedTrainingCourse.value = course;
                global.vroute.navigateTo('/training/videos/${course.name}');
              },
            ),
          );
        }),
      ],
    );

    // return (likedProducts != null && likedProducts!.isNotEmpty)
    //     ? buildVideoList(context)
    //     : buildNoVideoListFound(context);
  }

  Widget buildNoVideoListFound(BuildContext context) {
    return Center(
      child: Container(
          height: 500,
          width: 500,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.movie_creation,
                size: 100,
              ),
              const SizedBox(height: 8),
              const Text('No Video Content Found 😢', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
              const SizedBox(
                height: 24,
              ),
              SizedBox(
                height: 50,
                width: 200,
                child: YLiftFilledButton(
                    onPressed: () async => await global.vroute.navigateTo('/shop'),
                    child: const Text('Continue to shop')),
              )
            ],
          )),
    );
  }

  Widget buildVideoList(BuildContext context) {
    return Center(
      child: Container(
          height: 500,
          width: 500,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.movie_creation,
                size: 100,
              ),
              const SizedBox(height: 8),
              const Text('No videos found', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
              const SizedBox(
                height: 24,
              ),
              SizedBox(
                height: 50,
                width: 200,
                child: YLiftFilledButton(
                    onPressed: () async => await global.vroute.navigateTo('/shop'),
                    child: const Text('Continue to shop')),
              )
            ],
          )),
    );
  }
}