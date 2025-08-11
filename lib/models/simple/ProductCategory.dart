import 'package:YLift/core/constants/index.dart';
import 'package:YLift/core/repositories/image_repository.dart';
import 'package:YLift/core/utils/date_time_util.dart';
import 'package:YLift/models/z-index_export.dart';

class ProductCategory {
  final String id;
  final int categoryId;
  final String name;
  final String imageUrl;
  final int position;
  final int clicks;
  final bool isActive;
  final bool featured;
  final bool isArchived;

  const ProductCategory({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.imageUrl,
    this.position = 0,
    this.clicks = 0,
    this.isActive = true,
    this.featured = false,
    this.isArchived = false,
  });

  factory ProductCategory.dummy() => ProductCategory(id: '', categoryId: 0, name: '', imageUrl: '');

  factory ProductCategory.fromJson(Map<String, dynamic> json) {
    final imageUuid = _categoryImageUuids['${json['categoryId']}'] ?? '';

    return ProductCategory(
      id: '${json['id']}',
      categoryId: json['categoryId'],
      name: json['name'] ?? '',
      imageUrl: ImageRepository.getBannerImage(imageUuid),
      position: json['position'] ?? 0,
      clicks: json['clicks'] ?? 0,
      isActive: json['isActive'] ?? false,
      featured: json['featured'] ?? false,
      isArchived: json['isArchived'] ?? false,
    );
  }

  // toJson Method
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'categoryId': categoryId,
      'name': name,
      'position': position,
      'clicks': clicks,
      'isActive': isActive,
      'featured': featured,
      'isArchived': isArchived,
    };
  }

  ProductCategory copyWith({
    String? name,
    int? position,
    int? clicks,
    bool? isActive,
    bool? featured,
    bool? isArchived,
    DateTime? updatedAt,
  }) {
    return ProductCategory(
      id: id,
      categoryId: categoryId,
      name: name ?? this.name,
      imageUrl: imageUrl,
      position: position ?? this.position,
      clicks: clicks ?? this.clicks,
      isActive: isActive ?? this.isActive,
      featured: featured ?? this.featured,
      isArchived: isArchived ?? this.isArchived,
    );
  }

  @override
  String toString() => 'ProductCategory(name: $name)';
}

const _categoryImageUuids = <String, String>{
  '110': 'fb334294-f968-4e30-8a27-96acbea54a33', // Injectable Fillers
  '116': 'e48b4819-a453-42bc-af30-387f557f50be', // Neurotoxin
  '117': '1f662c02-92da-4248-bf78-1e9e46cd5d48', //
  '114': 'c02bd5bb-bc12-432b-8ce6-2510770c15a0', // Medical Supplies
  '123': '17a051ae-e029-4fcd-bf6c-331801d004b1', // Medical Devices
  '121': '54993209-cc66-4cb3-ba2a-64322e89272f', // Cannulas
  '122': 'daa842bd-a0fa-4b35-8f83-1ea5bb5c4072', //
  '119': 'b8247f40-bc57-401a-afc7-1b7b31f137ce', // Skincare
  '124': '69635b5d-86fb-4f3e-9043-a7362936eaf9', // PRP
  '129': '7f4fc490-d5ed-4847-b4ae-b902ac1078c5', // Supplements
  '131': '7e9b5bd1-a101-46c6-963c-b001b0ae70d5', // Threads
  '132': '2a47e1a8-36f4-4f1d-b342-29eaa92dee24', // Exosomes
  '134': 'b46bd0bd-fb9c-4c40-8bd2-cb939907bad0', // Sexual Health
  '135': '6303bd35-08e2-4970-a585-2556c84335cd', // DermaCeuticals
  '136': '71cb62d9-dbc5-43bd-bdf9-7bf807ae5460', // Peptides
  '137': 'fd9575b7-be1f-4557-8f40-bcc54cc2e3f1', // GLP
};
