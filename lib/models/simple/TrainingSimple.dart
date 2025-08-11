

import '../../presentation/pages/mobile/profile/trainings/index.dart';

class TrainingSimple {
  final String id;
  final String title;
  final String subtitle;
  final String author;
  final String? overview;
  final String? details;
  final String thumbnailUrl;

  // Constructor
  TrainingSimple({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.author,
    this.overview,
    this.details,
    required this.thumbnailUrl,
  });

  factory TrainingSimple.fromTraining(Training training) {
    return TrainingSimple(
      id: training.id,
      title: training.title,
      subtitle: training.subtitle,
      author: training.author ?? 'NullAuthor',
      overview: training.overview,
      details: training.details,
      thumbnailUrl: training.thumbnailUrl ?? 'NullThumbnailUrl',
    );
  }

  // toJson method for serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'author': author,
      'overview': overview,
      'details': details,
      'thumbnailUrl': thumbnailUrl,
    };
  }

  // toString method for easy debugging and logging
  @override
  String toString() {
    return 'TrainingSimple(id: $id, title: $title, subtitle: $subtitle, author: $author, '
        'overview: $overview, details: $details, thumbnailUrl: $thumbnailUrl)';
  }
}