import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:url_launcher/url_launcher.dart';

class ResourceCenter extends StatefulWidget {
  final bool banner;

  const ResourceCenter({Key? key, this.banner = false}) : super(key: key);

  @override
  _ResourceCenterState createState() => _ResourceCenterState();
}

class _ResourceCenterState extends State<ResourceCenter> {
  late VideoPlayerController _knowYController;
  late VideoPlayerController _askYController;

  @override
  void initState() {
    super.initState();
    _knowYController = VideoPlayerController.network(
      'https://s3.amazonaws.com/static.ylift.com/know+Y+Video+Tutorial.mp4',
    )..initialize().then((_) {
        setState(() {});
      });

    _askYController = VideoPlayerController.network(
      'https://chime-meeting-sdk-546030726103-us-east-1-recordings.s3.amazonaws.com/tutorials/AskY+(1)/Ask+Y+Video+Tutorial+-+Getting+Started_01.mp4',
    )..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _knowYController.dispose();
    _askYController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text(
            'Explore the Resource Center',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          if (widget.banner)
            Container(
              margin: EdgeInsets.only(top: 16),
              padding: EdgeInsets.all(16),
              color: Colors.green,
              child: Text(
                'Congrats! You are now a know Y Instructor!',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          Row(
            children: [
              Expanded(child: _buildKnowYSection()),
              Expanded(child: _buildAskYSection()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKnowYSection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('msc/images/knowY_red.png', width: 50),
            Text('Know Y', style: Theme.of(context).textTheme.headlineSmall),
          ],
        ),
        _buildVideoPlayer(_knowYController),
      ],
    );
  }

  Widget _buildAskYSection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('msc/images/ask_Y_logo.png', width: 50),
            Text('Ask Y', style: Theme.of(context).textTheme.headlineSmall),
          ],
        ),
        _buildVideoPlayer(_askYController),
      ],
    );
  }

  Widget _buildVideoPlayer(VideoPlayerController controller) {
    return AspectRatio(
      aspectRatio: controller.value.aspectRatio,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          VideoPlayer(controller),
          VideoProgressIndicator(controller, allowScrubbing: true),
          _PlayPauseOverlay(controller: controller),
        ],
      ),
    );
  }
}

class _PlayPauseOverlay extends StatelessWidget {
  final VideoPlayerController controller;

  const _PlayPauseOverlay({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedSwitcher(
          duration: Duration(milliseconds: 50),
          reverseDuration: Duration(milliseconds: 200),
          child: controller.value.isPlaying
              ? SizedBox.shrink()
              : Container(
                  color: Colors.black26,
                  child: Center(
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 100.0,
                    ),
                  ),
                ),
        ),
        GestureDetector(
          onTap: () {
            controller.value.isPlaying ? controller.pause() : controller.play();
          },
        ),
      ],
    );
  }
}
