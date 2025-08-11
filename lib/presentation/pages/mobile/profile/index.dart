import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:YLift/core/controllers/z-index_export.dart';
import 'package:YLift/core/constants/index.dart';

import 'package:video_player/video_player.dart';

import 'package:YLift/presentation/pages/mobile/profile/ask.dart';

import 'package:YLift/presentation/pages/mobile/profile/my_account.dart';
import 'package:YLift/presentation/pages/mobile/profile/shopping/index.dart';
import 'package:YLift/presentation/pages/mobile/profile/subscriptions.dart';
import 'package:YLift/presentation/pages/mobile/profile/trainings/index.dart';

import 'campaigns.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  final GlobalController controller = Get.find<GlobalController>();

  late VideoPlayerController _videoController;
  late TabController _tabController;
  late ScrollController _scrollController;
  double _opacity = 1.0;

  final List<String> tabs = [
    'My Account',
    'Shop Y',
    'Know Y',
    'Ask Y',
    'Campaigns',
    'Subscriptions',
  ];

  @override
  void initState() {
    super.initState();
    final Uri videoUrl = Uri.parse(
        "https://ylift.app/api/v2/mars/file/public/media/not_logged_in.mp4");
    _videoController = VideoPlayerController.networkUrl(videoUrl)
      ..initialize().then((_) {
        setState(() {
          _videoController.setLooping(true);
          _videoController.play();
        });
      });
    _tabController = TabController(length: tabs.length, vsync: this);
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _tabController.addListener(_tabListener);
  }

  void _scrollListener() {
    if (_tabController.index == 0) {
      setState(() {
        _opacity = (1.0 - (_scrollController.offset / 200)).clamp(0.0, 1.0);
      });
    }
  }

  void _tabListener() {
    if (_tabController.index == 0) {
      setState(() {
        _opacity = 1.0 - (_scrollController.offset / 200).clamp(0.0, 1.0);
      });
    } else {
      setState(() {
        _opacity = 0.0;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _videoController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (controller.isAuthenticated.isTrue) {
      return _buildUserProfile(context);
    } else {
      return _buildNotLoggedIn(context);
    }
  }

  Widget _buildUserProfile(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverToBoxAdapter(
              child: AnimatedOpacity(
                opacity: _opacity,
                duration: Duration(milliseconds: 300),
                child: Column(
                  children: [
                    if (_opacity > 0.0 && _tabController.index == 0) ...[]
                  ],
                ),
              ),
            ),
            SliverPersistentHeader(
              delegate: _SliverAppBarDelegate(
                TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  tabs: tabs.map((String name) => Tab(text: name)).toList(),
                  indicatorColor: Theme.of(context).colorScheme.primary,
                  labelColor: Theme.of(context).colorScheme.onSurface,
                  unselectedLabelColor:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              pinned: true,
              floating: true,
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            SingleChildScrollView(child: ProfileSettings()),
            ProfileShoppingScreen(),
            ProfileKnowledgeScreen(),
            StreamProfilePage(),
            ProviderCampaignManagement(),
            ProfileSubscriptionsScreen(),
          ],
        ),
      ),
    );
  }

  Widget _buildNotLoggedIn(BuildContext context) {
    return Stack(
      children: [
        SizedBox.expand(
          child: FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: _videoController.value.size?.width ?? 0,
              height: _videoController.value.size?.height ?? 0,
              child: VideoPlayer(_videoController),
            ),
          ),
        ),
        Positioned(
          bottom: 25,
          left: 0,
          right: 0,
          child: Center(
            child: ElevatedButton(
              // onPressed: () => controller.auth0
              //     .loginWithRedirect(redirectUrl: CURRENT_REDIRECT_URI),
              // TODO: Change to login
              onPressed: (){},
              child: Text('Login To Unlock Pricing and More..'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(150, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
