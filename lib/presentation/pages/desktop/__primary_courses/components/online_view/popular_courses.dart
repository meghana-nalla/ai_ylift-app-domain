import 'package:flutter/material.dart';
import 'package:galaxy_ui/galaxy_ui.dart';

import '../../../../../components/_complex/desktop_view/page_scaffold.dart';

class PopularVideoCourse extends StatelessWidget {

  final List<TrainingData> sampleTrainings = [
    TrainingData(
      imageUrl: "https://picsum.photos/200/300",
      title: "Flutter Basics",
      authorName: "Dr. Jane Smith",
      chapterCount: "8 Chapters",
    ),
    TrainingData(
      imageUrl: "https://picsum.photos/200/301",
      title: "Advanced Dart Programming",
      authorName: "Prof. Alan Turing",
      chapterCount: "12 Chapters",
    ),
    TrainingData(
      imageUrl: "https://picsum.photos/200/300",
      title: "Flutter Basics",
      authorName: "Dr. Jane Smith",
      chapterCount: "8 Chapters",
    ),
    TrainingData(
      imageUrl: "https://picsum.photos/200/301",
      title: "Advanced Dart Programming",
      authorName: "Prof. Alan Turing",
      chapterCount: "12 Chapters",
    ),
    TrainingData(
      imageUrl: "https://picsum.photos/200/300",
      title: "Flutter Basics",
      authorName: "Dr. Jane Smith",
      chapterCount: "8 Chapters",
    ),
    TrainingData(
      imageUrl: "https://picsum.photos/200/301",
      title: "Advanced Dart Programming",
      authorName: "Prof. Alan Turing",
      chapterCount: "12 Chapters",
    ),    TrainingData(
      imageUrl: "https://picsum.photos/200/300",
      title: "Flutter Basics",
      authorName: "Dr. Jane Smith",
      chapterCount: "8 Chapters",
    ),
    TrainingData(
      imageUrl: "https://picsum.photos/200/301",
      title: "Advanced Dart Programming",
      authorName: "Prof. Alan Turing",
      chapterCount: "12 Chapters",
    ),
    // Add more training data as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
            children: [
              const SizedBox(height: 30),
              VideoSectionsAlsoMightLike(
                trainings: sampleTrainings,
                title: "Popular Courses",
                onViewAllPressed: () {
                  // Handle view all button tap
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Container()));
                },
              ),
              const SizedBox(height: 216),
            ]);
  }
}