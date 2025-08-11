import 'package:YLift/core/constants/hardcoded_id.dart';

class TrainingEventData {
  final String id;
  final String title;
  final String description;
  final String speakerImageUrl;
  final String speakerName;
  final String unlockMessage;
  final String? additionalMessage;
  final List<String> products;
  final int minimumQuantity;
  final List<DateTime> dateRange;

  const TrainingEventData({
    required this.id,
    required this.title,
    required this.description,
    required this.speakerImageUrl,
    required this.speakerName,
    required this.unlockMessage,
    this.additionalMessage,
    this.products = const <String>[],
    required this.minimumQuantity,
    required this.dateRange,
  });

  static final examples = <TrainingEventData>[
    TrainingEventData(
      id: HardcodedId.eventTwoDay,
      title: '2-Day Pass',
      description: '',
      speakerImageUrl:
          'https://d26n8ibxbj8243.cloudfront.net/optimized/custom_images/combine_doc.png',
      speakerName: 'Dr. Zoe Flor & Dr. Amy B. Lewis',
      unlockMessage: 'Unlock with 60-box Radiesse',
      additionalMessage: '+ Get 36 Radiesse Free',
      products: [],
      minimumQuantity: 60,
      dateRange: [
        DateTime(2024, 6, 21),
        DateTime(2024, 6, 22),
      ],
    ),
    TrainingEventData(
      id: HardcodedId.eventZoeID,
      title: 'Body Day with Dr. Zoe Flor',
      description: '',
      speakerImageUrl:
          'https://d26n8ibxbj8243.cloudfront.net/optimized/custom_images/dr_zoe.jpeg',
      speakerName: 'Dr. Zoe Flor',
      unlockMessage: 'Unlock with 40-box Radiesse',
      additionalMessage: '+ Get 18 Radiesse Free',
      products: [],
      minimumQuantity: 40,
      dateRange: [
        DateTime(2024, 6, 21),
      ],
    ),
    TrainingEventData(
      id: HardcodedId.eventAmyID,
      title: 'Face Day with Dr. Amy B. Lewis',
      description: '',
      speakerImageUrl:
          'https://d26n8ibxbj8243.cloudfront.net/optimized/custom_images/dr_amy.jpg',
      speakerName: 'Dr. Amy B. Lewis',
      unlockMessage: 'Unlock with 40-box Radiesse',
      additionalMessage: '+ Get 18 Radiesse Free',
      products: [],
      minimumQuantity: 40,
      dateRange: [
        DateTime(2024, 6, 22),
      ],
    ),
  ];
}
