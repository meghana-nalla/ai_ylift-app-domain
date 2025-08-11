import 'package:YLift/core/controllers/global.dart';
import 'package:YLift/presentation/components/_complex/desktop_view/page_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:galaxy_models/galaxy_models.dart';

class VideoCoursePage extends StatefulWidget {
  const VideoCoursePage({Key? key}) : super(key: key);

  @override
  State<VideoCoursePage> createState() => _VideoCoursePageState();
}

class _VideoCoursePageState extends State<VideoCoursePage> {
  final GlobalController _global = Get.find<GlobalController>();
  
  VideoTrainingCourse? _course;
  bool _isLoading = true;
  String? _error;
  int _selectedVideoIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadVideoDetails();
  }

  Future<void> _loadVideoDetails() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Get the video ID from the URL
      final currentPath = Uri.base.path;
      if (currentPath.startsWith('/courses/view/')) {
        final videoId = currentPath.split('/').last;
        
        // Load user's training courses
        final course = await _global.userController.getVirtualContent(videoId);
        
        if(course != null && course.videos.isNotEmpty) {
          setState(() {
            _course = course;
            _selectedVideoIndex = course.videos.indexOf(0);
            _isLoading = false;
          });
          return;
        }

        // If no course found with this video ID
        setState(() {
          _error = "Video not found in your library";
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = "Invalid URL format";
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = "Error loading video: $e";
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GalaxyPageScaffold(
      children: [
        _buildNavigationBar(),
        _isLoading 
          ? _buildLoadingState()
          : _error != null
            ? _buildErrorState()
            : _buildVideoContent(),
      ],
    );
  }

  Widget _buildNavigationBar() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
      child: Row(
        children: [
          TextButton.icon(
            onPressed: () {
              _global.vroute.navigateTo('/courses');
            },
            icon: Icon(Icons.arrow_back),
            label: Text('Back to Courses'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 100),
          CircularProgressIndicator(),
          SizedBox(height: 20),
          Text('Loading video...'),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 100),
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 20),
          Text(_error ?? 'An unknown error occurred', 
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => _global.vroute.navigateTo('/courses'),
            child: const Text('Return to Courses'),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoContent() {
    if (_course == null || _course!.videos.isEmpty) {
      return const Center(child: Text('No video content available'));
    }
    
    final currentVideo = _course!.videos[_selectedVideoIndex];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _course?.name ?? 'Video Course',
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Video player area
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Video player placeholder
                  Container(
                    height: 400,
                    color: Colors.black87,
                    child: Center(
                      child: currentVideo.videoUrl != null && currentVideo.videoUrl!.isNotEmpty
                        ? _buildVideoPlayer(currentVideo.videoUrl!)
                        : const Icon(Icons.video_library, size: 64, color: Colors.white54),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    currentVideo.title,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    currentVideo.description ?? 'No description available',
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 24),
            // Course videos list
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Course Content',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  ..._buildVideoList(),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildVideoPlayer(String videoUrl) {
    // This is a placeholder for a real video player
    // In a real implementation, you would use a Flutter video player plugin
    return const Center(
      child: Text(
        'Video Player Would Be Here',
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  }

  List<Widget> _buildVideoList() {
    return _course!.videos.asMap().entries.map((entry) {
      final index = entry.key;
      final video = entry.value;
      final isSelected = index == _selectedVideoIndex;
      
      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade50 : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: ListTile(
          onTap: () {
            setState(() {
              _selectedVideoIndex = index;
            });
          },
          leading: CircleAvatar(
            backgroundColor: isSelected ? Colors.blue : Colors.grey.shade200,
            child: Text(
              '${index + 1}',
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
              ),
            ),
          ),
          title: Text(
            video.title,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          subtitle: Text(
            video.duration ?? 'Unknown duration',
            style: const TextStyle(fontSize: 12),
          ),
          trailing: Icon(
            isSelected ? Icons.play_circle_filled : Icons.play_circle_outline,
            color: isSelected ? Colors.blue : Colors.grey,
          ),
        ),
      );
    }).toList();
  }
}