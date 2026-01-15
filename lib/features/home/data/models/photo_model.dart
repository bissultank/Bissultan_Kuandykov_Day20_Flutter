import 'package:spa_project/features/home/domain/entity/photo_entity.dart';

class PhotoModel {
  const PhotoModel({
    required this.id,
    required this.path,
    this.title,
    this.author,
    this.description,
    this.likes,
  });

  final String id;
  final String path;
  final String? title;
  final String? author;
  final String? description;
  final int? likes;

  factory PhotoModel.fromJson(Map<String, dynamic> json) {
    return PhotoModel(
      id: json['id'] as String,
      path: json['urls']['regular'] as String,
      title: json['alt_description'] as String?,
      author: json['user']?['name'] as String?,
      description: json['description'] as String?,
      likes: json['likes'] as int?,
    );
  }

  PhotoEntity toEntity() {
    return PhotoEntity(
      id: id,
      path: path,
      title: title,
      author: author,
      description: description,
      likes: likes,
    );
  }
}
