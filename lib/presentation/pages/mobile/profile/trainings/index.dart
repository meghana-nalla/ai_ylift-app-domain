import 'package:YLift/presentation/components/z-index_export.dart';
import 'package:YLift/presentation/pages/mobile/profile/trainings/manage.dart';
import 'package:YLift/presentation/pages/mobile/profile/trainings/recrutment.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'package:YLift/core/controllers/z-index_export.dart';
import '../../resources/index.dart';
import '../orders/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ProfileKnowledgeScreen extends StatefulWidget {
  @override
  _ProfileKnowledgeScreenState createState() => _ProfileKnowledgeScreenState();
}

class _ProfileKnowledgeScreenState extends State<ProfileKnowledgeScreen>
    with SingleTickerProviderStateMixin {
  final GlobalController controller = Get.find<GlobalController>();

  late TabController _tabController;

  final List<String> tabs = [
    'My Library',
    'Upload Training',
    'My Performance',
    'Recruitment',
    'Instructor Resources',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: AnimatedRouteDisplay(
          parentRoute: 'Know Y',
          childRoute: tabs[_tabController.index],
        ),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: tabs.map((String name) => Tab(text: name)).toList(),
          indicatorColor: Theme.of(context).colorScheme.primary,
          labelColor: Theme.of(context).colorScheme.onSurface,
          unselectedLabelColor:
              Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: tabs.map((String name) {
          return _buildTabContent(name);
        }).toList(),
      ),
    );
  }

  List<Map<String, dynamic>> pendingInvitationsJson = [
    {
      "id": "ac2cb3d8-6730-44fd-8025-9ddfa3cd154d",
      "profileId": 167,
      "email": "braxtond@ylift.com",
      "createdAt": "2020-05-17T23:09:22.000Z",
      "updatedAt": "2020-05-17T23:09:22.000Z"
    },
    {
      "id": "b29dd350-047d-458a-9a20-c44fd19eec58",
      "profileId": 167,
      "email": "design@leannalasso.com",
      "createdAt": "2020-05-12T12:40:25.000Z",
      "updatedAt": "2020-05-12T12:40:25.000Z"
    }
  ];

  List<PendingInvitation> get pendingInvitations {
    return pendingInvitationsJson
        .map((json) => PendingInvitation.fromJson(json))
        .toList();
  }

  Widget _buildTabContent(String tabName) {
    switch (tabName) {
      case 'My Library':
        return PurchasedTrainings();
      case 'Upload Training':
        return MyTrainings();
      case 'My Performance':
        return TrainingManagement();
      case 'Recruitment':
        return RecruitmentWidget(pendingInvitations: pendingInvitations);

      case 'Instructor Resources':
        return Center(child: Text('Content for $tabName coming soon'));
      // return ResourceCenter(banner: false);
      default:
        return Center(child: Text('Content for $tabName'));
    }
  }
}

class PurchasedTrainings extends StatelessWidget {
  // TODO: Replace with actual API call
  final List<TrainingVideo> videos = [
    TrainingVideo(
      id: 7,
      title: "Y LIFT Pre-training Webinar",
      caption: null,
      description: null,
      fileUrl:
          "https://api.ylift.com/mars/file/info/pre_training_webinar_v9.mp4",
      thumbnailUrl: "https://api.ylift.com/mars/file/thumb.png",
      mimeType: "video/mp4",
      views: 0,
      size: 2040108421,
      isDownloadable: false,
      tags: [],
    ),
    TrainingVideo(
      id: 11,
      title: "How Long Do Fillers Really Last?",
      caption: "Learn how long fillers actually last!",
      description: "Learn how long fillers actually last!",
      fileUrl: "https://api.ylift.com/mars/file/maintenance_video.mp4",
      thumbnailUrl: "https://api.ylift.com/mars/file/thumb.png",
      mimeType: "video/mp4",
      views: 0,
      size: 427994646,
      isDownloadable: false,
      tags: [],
    ),
    TrainingVideo(
      id: 13,
      title: "flexYguide® - Anatomically Correct Guide Tutorial",
      caption: " ",
      description:
          "A step-by-step tutorial instructed by creator Dr. Yan Trokel on how to use the flexYguide®.",
      fileUrl:
          "https://store.ylift.com/uploads/network-media/e621d706-0eaa-41f5-a12d-6f77aa703403",
      thumbnailUrl:
          "https://store.ylift.com/uploads/network-media/09e673b8-891e-4fc0-b628-7bb5e66b5a3f",
      mimeType: "video/mp4",
      views: 0,
      size: 580213055,
      isDownloadable: false,
      tags: [],
    ),
    TrainingVideo(
      id: 14,
      title: "Patient Photography Tutorial",
      caption:
          "How to properly take Before and After pictures of Y LIFT patients",
      description:
          "How to properly take Before and After pictures of Y LIFT patients",
      fileUrl:
          "https://store.ylift.com/uploads/network-media/b56860eb-429e-4e04-8b65-d30f2835236c",
      thumbnailUrl:
          "https://store.ylift.com/uploads/network-media/e51c47bb-a395-4dd4-9bce-ef6cb3c8b83c",
      mimeType: "video/mp4",
      views: 0,
      size: 811467007,
      isDownloadable: false,
      tags: [],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Purchased Training Courses'),
      ),
      body: ListView.builder(
        itemCount: videos.length,
        itemBuilder: (context, index) {
          final video = videos[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.network(
                    video.thumbnailUrl,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        video.title,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      if (video.caption != null && video.caption!.isNotEmpty)
                        Text(
                          video.caption!,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      SizedBox(height: 8),
                      if (video.description != null &&
                          video.description!.isNotEmpty)
                        Text(
                          video.description!,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      // SizedBox(height: 8),
                      // Text(
                      //   'Size: ${(video.size / 1024 / 1024).toStringAsFixed(2)} MB',
                      //   style: Theme.of(context).textTheme.bodySmall,
                      // ),
                    ],
                  ),
                ),
                ButtonBar(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _playVideo(context, video);
                      },
                      child: Text('Watch Video'),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _playVideo(BuildContext context, TrainingVideo video) {
    // TODO : Logic to play the video
  }
}

class TrainingVideo {
  final int id;
  final String title;
  final String? caption;
  final String? description;
  final String fileUrl;
  final String thumbnailUrl;
  final String mimeType;
  final int views;
  final int size;
  final bool isDownloadable;
  final List<String> tags;

  TrainingVideo({
    required this.id,
    required this.title,
    this.caption,
    this.description,
    required this.fileUrl,
    required this.thumbnailUrl,
    required this.mimeType,
    required this.views,
    required this.size,
    required this.isDownloadable,
    required this.tags,
  });
}

class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;

  VideoPlayerScreen({required this.videoUrl});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Player'),
      ),
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : CircularProgressIndicator(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _controller.value.isPlaying
                ? _controller.pause()
                : _controller.play();
          });
        },
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}

class MyTrainings extends StatefulWidget {
  @override
  _MyTrainingsState createState() => _MyTrainingsState();
}

class _MyTrainingsState extends State<MyTrainings> {
  List<Training> trainings = [];
  bool isEditingCreating = false;
  Training? selectedTraining;

  @override
  void initState() {
    super.initState();
    getTrainings();
  }

  void getTrainings() {
    // TODO: Replace with actual API call
    setState(() {
      trainings = [
        Training(
          id: "0d8c9edf-3c81-47e1-a375-fd447242395d",
          title: "bootYlift® - Non-surgical Buttock Enhancement",
          subtitle:
              "Minimally Invasive Enhancement Procedure for the Perfect Buttock",
          price: 69900,
          listPrice: 69900,
          isActive: false,
          approvedByAdmin: "APPROVED",
        ),
        Training(
          id: "0d8c9edf-3c81-47e1-a375-fd447242395e",
          title: "bootYlift® - Non-surgical Buttock Enhancement (Digital Plus)",
          subtitle:
              "Minimally Invasive Enhancement Procedure for the Perfect Buttock",
          price: 450000,
          listPrice: 450000,
          isActive: false,
          approvedByAdmin: "APPROVED",
        ),
      ];
    });
  }

  void deleteTraining(Training training) {
    setState(() {
      trainings.removeWhere((t) => t.id == training.id);
    });
  }

  String formatPrice(int price) {
    return (price / 100).toStringAsFixed(2);
  }

  void saveTraining(Training training) {
    setState(() {
      if (selectedTraining != null) {
        int index = trainings.indexWhere((t) => t.id == selectedTraining!.id);
        if (index != -1) {
          trainings[index] = training;
        }
      } else {
        // Creating new training
        trainings.add(training);
      }
      isEditingCreating = false;
      selectedTraining = null;
    });
  }

  void editTraining(Training training) {
    setState(() {
      selectedTraining = training;
      isEditingCreating = true;
    });
  }

  void createTraining() {
    setState(() {
      selectedTraining = null;
      isEditingCreating = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isEditingCreating) {
      return TrainingEditWidget(
        training: selectedTraining,
        onSave: saveTraining,
        onCancel: () {
          setState(() {
            isEditingCreating = false;
            selectedTraining = null;
          });
        },
      );
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 32),
              Row(
                children: [
                  Text(
                    'Created Training Courses',
                    style: TextStyle(fontSize: 36),
                  ),
                  Spacer(),
                  ElevatedButton(
                    onPressed: createTraining,
                    child: Text('Create'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                  )
                ],
              ),
              SizedBox(height: 32),
              trainings.isEmpty
                  ? Center(child: Text('No trainings available'))
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minWidth: MediaQuery.of(context).size.width - 32,
                        ),
                        child: DataTable(
                          columnSpacing: 16,
                          columns: [
                            DataColumn(label: Text('Title')),
                            DataColumn(label: Text('Price')),
                            DataColumn(label: Text('Active')),
                            DataColumn(label: Text('Status')),
                            DataColumn(label: Text('Actions')),
                          ],
                          rows: trainings
                              .map((training) => DataRow(
                                    cells: [
                                      DataCell(Text(training.title)),
                                      DataCell(Text(
                                          '\$${formatPrice(training.price)}')),
                                      DataCell(Text(
                                          training.isActive ? 'Yes' : 'No')),
                                      DataCell(
                                        Text(
                                          training.approvedByAdmin == 'APPROVED'
                                              ? 'Published'
                                              : training.approvedByAdmin ==
                                                      'PENDING'
                                                  ? 'In review'
                                                  : 'Disapproved',
                                          style: TextStyle(
                                            color: training.approvedByAdmin ==
                                                    'APPROVED'
                                                ? Colors.green
                                                : training.approvedByAdmin ==
                                                        'PENDING'
                                                    ? Colors.orange
                                                    : Colors.red,
                                          ),
                                        ),
                                      ),
                                      DataCell(Row(
                                        children: [
                                          IconButton(
                                            icon: Icon(Icons.edit),
                                            onPressed: () =>
                                                editTraining(training),
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.delete),
                                            onPressed: () =>
                                                deleteTraining(training),
                                          ),
                                        ],
                                      )),
                                    ],
                                  ))
                              .toList(),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class Training {
  final String id;
  String title;
  String subtitle;
  String? author;
  String? overview;
  String? details;
  String? thumbnailUrl;
  DateTime? startTime;
  DateTime? endTime;
  String? timezone;
  int price;
  int listPrice;
  bool isActive;
  bool? featured;
  bool? hasLiveStream;
  String? locationId;
  String approvedByAdmin;

  Training({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.listPrice,
    required this.isActive,
    required this.approvedByAdmin,
    this.author,
    this.overview,
    this.details,
    this.thumbnailUrl,
    this.startTime,
    this.endTime,
    this.timezone,
    this.featured,
    this.hasLiveStream,
    this.locationId,
  });
}

class TrainingEditWidget extends StatefulWidget {
  final Training? training;
  final Function(Training) onSave;
  final VoidCallback onCancel;

  TrainingEditWidget({
    Key? key,
    this.training,
    required this.onSave,
    required this.onCancel,
  }) : super(key: key);

  @override
  _TrainingEditWidgetState createState() => _TrainingEditWidgetState();
}

class _TrainingEditWidgetState extends State<TrainingEditWidget> {
  late Training _training;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _training = widget.training ??
        Training(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: '',
          subtitle: '',
          author: '',
          overview: '',
          details: '',
          thumbnailUrl: '',
          startTime: DateTime.now(),
          endTime: DateTime.now().add(Duration(hours: 1)),
          timezone: 'America/New_York',
          price: 0,
          listPrice: 0,
          isActive: false,
          featured: false,
          hasLiveStream: false,
          locationId: '',
          approvedByAdmin: 'PENDING',
        );
  }

  void _saveTraining() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      widget.onSave(_training);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.training == null ? 'Create Training' : 'Edit Training'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveTraining,
          ),
          IconButton(
            icon: Icon(Icons.cancel),
            onPressed: widget.onCancel,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  initialValue: _training.title,
                  decoration: InputDecoration(labelText: 'Title'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter a title' : null,
                  onSaved: (value) => _training.title = value!,
                ),
                TextFormField(
                  initialValue: _training.subtitle,
                  decoration: InputDecoration(labelText: 'Subtitle'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter a subtitle' : null,
                  onSaved: (value) => _training.subtitle = value!,
                ),
                TextFormField(
                  initialValue: _training.author,
                  decoration: InputDecoration(labelText: 'Author'),
                  onSaved: (value) => _training.author = value,
                ),
                TextFormField(
                  initialValue: _training.overview,
                  decoration: InputDecoration(labelText: 'Overview'),
                  maxLines: 3,
                  onSaved: (value) => _training.overview = value,
                ),
                TextFormField(
                  initialValue: _training.details,
                  decoration: InputDecoration(labelText: 'Details'),
                  maxLines: 5,
                  onSaved: (value) => _training.details = value,
                ),
                TextFormField(
                  initialValue: _training.thumbnailUrl,
                  decoration: InputDecoration(labelText: 'Thumbnail URL'),
                  onSaved: (value) => _training.thumbnailUrl = value,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        initialValue: DateFormat('yyyy-MM-dd HH:mm')
                            .format(_training.startTime!),
                        decoration: InputDecoration(labelText: 'Start Time'),
                        validator: (value) =>
                            value!.isEmpty ? 'Please enter a start time' : null,
                        onSaved: (value) => _training.startTime =
                            DateFormat('yyyy-MM-dd HH:mm').parse(value!),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        initialValue: DateFormat('yyyy-MM-dd HH:mm')
                            .format(_training.endTime!),
                        decoration: InputDecoration(labelText: 'End Time'),
                        validator: (value) =>
                            value!.isEmpty ? 'Please enter an end time' : null,
                        onSaved: (value) => _training.endTime =
                            DateFormat('yyyy-MM-dd HH:mm').parse(value!),
                      ),
                    ),
                  ],
                ),
                TextFormField(
                  initialValue: _training.timezone,
                  decoration: InputDecoration(labelText: 'Timezone'),
                  onSaved: (value) => _training.timezone = value,
                ),
                TextFormField(
                  initialValue: (_training.price / 100).toString(),
                  decoration: InputDecoration(
                      labelText: 'Price (\$)'), // Escaped dollar sign
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter a price' : null,
                  onSaved: (value) =>
                      _training.price = (double.parse(value!) * 100).round(),
                ),
                TextFormField(
                  initialValue: (_training.listPrice / 100).toString(),
                  decoration: InputDecoration(
                      labelText: 'Retail Price (\$)'), // Escaped dollar sign
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter a retail price' : null,
                  onSaved: (value) => _training.listPrice =
                      (double.parse(value!) * 100).round(),
                ),
                SwitchListTile(
                  title: Text('Is Active'),
                  value: _training.isActive,
                  onChanged: (bool value) {
                    setState(() {
                      _training.isActive = value;
                    });
                  },
                ),
                SwitchListTile(
                  title: Text('Featured'),
                  value: _training.featured!,
                  onChanged: (bool value) {
                    setState(() {
                      _training.featured = value;
                    });
                  },
                ),
                SwitchListTile(
                  title: Text('Has Live Stream'),
                  value: _training.hasLiveStream!,
                  onChanged: (bool value) {
                    setState(() {
                      _training.hasLiveStream = value;
                    });
                  },
                ),
                TextFormField(
                  initialValue: _training.locationId,
                  decoration: InputDecoration(labelText: 'Location ID'),
                  onSaved: (value) => _training.locationId = value,
                ),
                DropdownButtonFormField<String>(
                  value: _training.approvedByAdmin,
                  decoration: InputDecoration(labelText: 'Approval Status'),
                  items:
                      ['PENDING', 'APPROVED', 'REJECTED'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _training.approvedByAdmin = newValue!;
                    });
                  },
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


// ************************************************************************************************

// ************************************************************************************************

// ************************************************************************************************

// ************************************************************************************************






