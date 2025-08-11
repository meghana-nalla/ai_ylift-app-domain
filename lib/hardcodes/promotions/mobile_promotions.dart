class MobilePromotionData{
  final String name;

  final String? description;

  final String imageUrl;
  final String? videoUrl;

  const MobilePromotionData({
    required this.name,
    required this.imageUrl,
    this.videoUrl,
    this.description,
  });


}