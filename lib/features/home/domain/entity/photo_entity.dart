class PhotoEntity {
  const PhotoEntity({
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
}
