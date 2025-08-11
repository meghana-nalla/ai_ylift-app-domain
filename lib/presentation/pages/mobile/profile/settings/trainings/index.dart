import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PurchasedTrainingsView extends StatefulWidget {
  @override
  _PurchasedTrainingsViewState createState() => _PurchasedTrainingsViewState();
}

class _PurchasedTrainingsViewState extends State<PurchasedTrainingsView> {
  List<Map<String, dynamic>> trainings = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTrainings();
  }

  Future<void> _loadTrainings() async {
    // TODO : Replace sample of Simulating API call
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      trainings = [
        {'id': 1, 'title': 'Introduction to Y Lift', 'description': 'Learn the basics of Y Lift'},
        {'id': 2, 'title': 'Advanced Y Lift Techniques', 'description': 'Master advanced Y Lift procedures'},
        {'id': 3, 'title': 'Y Lift Patient Care', 'description': 'Best practices for Y Lift patient care'},
      ];
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Purchased Training Courses'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : trainings.isEmpty
          ? Center(child: Text('No purchased trainings found'))
          : ListView(
        padding: EdgeInsets.all(16),
        children: [
          Text(
            'Purchased Training Courses',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.75,
            ),
            itemCount: trainings.length,
            itemBuilder: (context, index) {
              final training = trainings[index];
              return TrainingResultCard(training: training);
            },
          ),
        ],
      ),
    );
  }
}

class TrainingResultCard extends StatelessWidget {
  final Map<String, dynamic> training;

  const TrainingResultCard({Key? key, required this.training}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              color: Colors.grey[300],
              child: Center(
                child: FaIcon(FontAwesomeIcons.video, size: 48, color: Colors.grey[600]),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  training['title'],
                  style: Theme.of(context).textTheme.labelSmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Text(
                  training['description'],
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}