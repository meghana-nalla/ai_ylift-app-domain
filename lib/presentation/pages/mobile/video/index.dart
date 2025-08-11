import 'package:YLift/presentation/pages/mobile/training/index.dart';
import 'package:flutter/material.dart';

import 'package:YLift/presentation/components/_complex/know_y/knowy_category_selector.dart';
import 'package:YLift/presentation/components/_complex/know_y/knowy_popular_video_view.dart';
import 'package:YLift/presentation/components/_complex/know_y/knowy_standard_video_view.dart';
import 'package:YLift/presentation/components/_complex/know_y/knowy_training_image.dart';

class VideoScreen extends StatefulWidget {
  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Tab Bar
        TabBar(
          controller: _tabController,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.brown,
          indicatorWeight: 3,
          tabs: const [
            Tab(text: 'Trainings'),
            Tab(text: 'Online Courses'),
          ],
        ),

        // Tab Bar View
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              // Trainings Tab Content
              const MobileTrainingPage(),

              // Online Courses Tab Content
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 25.0,),
                  
                      // Popular Video Title
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Most Popular',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0,),
                  
                      // Popular Videos Display
                      const KnowYPopularVideoView(numVideos: 3),
                      const SizedBox(height: 35.0,),
                  
                      // Categories Title
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Categories',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0,),
                  
                      // Categories view
                      KnowYCategorySelector(),

                      // Standard Videos View
                      const KnowYStandardVideoView(numVideos: 5),

                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class BulletPoint extends StatelessWidget {
  final String text;
  BulletPoint({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.check, size: 18, color: Colors.white),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


// top bar text:
class KnowYTrainingsHeader extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return Container(
      color: Theme.of(context).colorScheme.tertiary,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Enjoy Y LIFT Network Benefits',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'After registering for trainings',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            BulletPoint(
                text:
                'Master the latest minimally invasive techniques'),
            BulletPoint(
                text: 'Get exclusive top-tier pricing on products'),
            BulletPoint(
                text: 'Use of all Media Kit promotional materials'),
            BulletPoint(text: 'Patient leads sent to you'),
          ],
        ),
      ),
    );

  }
}