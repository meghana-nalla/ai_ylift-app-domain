import 'package:flutter/material.dart';
import 'package:galaxy_ui/galaxy_ui.dart';
import '../../../components/_complex/desktop_view/page_scaffold.dart';
import 'components/online_view/popular_courses.dart';
import 'components/view_video_course.dart';

class ViewVideoCourse extends StatelessWidget {
  const ViewVideoCourse({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  GalaxyPageScaffold(
      backgroundColor: Colors.white,
      children: [
        SizedBox(height: 20),
        // VideoCoursePage(),
        buildPrototype(),
      ],
    );
  }


  Widget buildPrototype() {
    return Column(
            children: [
              GalaxySingleVideoPage(
                videoUrl: "https://media.stage.ylift.app/api/video/stream/7a6f36ea-d7c2-489b-92f4-83e78eff2d50",
                chapters: [
                  Chapter(
                    title: 'Chapter 1 - Beginner - Introduction to Filler Injection',
                    lessons: [
                      Lesson(
                        title: 'Preview - Words from Dr. Yuly',
                        duration: const Duration(minutes: 1, seconds: 20),
                        currentPosition: const Duration(seconds: 30),
                        isPreview: true,
                      ),
                      Lesson(
                        title: 'Introduction to modern filler injection technique - Filler on bone',
                        currentPosition:const Duration(minutes: 2) ,
                        duration: const Duration(minutes: 10),
                      ),
                    ],
                  ),
                  Chapter(
                    title: 'Chapter 2 - Learn The Y LIFT Methodology',
                    lessons: [
                      Lesson(
                        title: 'Introduction to Y LIFT',
                        duration: const Duration(minutes: 30, seconds: 20),
                      ),
                    ],
                  ),
                ],
              ),
              PopularVideoCourse(),
            ]);
  }

}