import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spa_project/features/home/domain/entity/photo_entity.dart';
import 'package:spa_project/features/home/presentation/controller/home_controller.dart';
import 'package:spa_project/features/home/presentation/screens/add_photo_screen.dart';

class PhotoDetailScreen extends StatelessWidget {
  final PhotoEntity photo;

  const PhotoDetailScreen({
    super.key,
    required this.photo,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(photo.title ?? 'Детали фото'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddPhotoScreen(photo: photo),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              _showDeleteDialog(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: photo.id,
              child: Image.network(
                photo.path,
                width: double.infinity,
                height: 400,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 400,
                    color: Colors.grey[300],
                    child: Icon(
                      Icons.broken_image,
                      size: 100,
                      color: Colors.grey[600],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (photo.title != null) ...[
                    Text(
                      photo.title!,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12),
                  ],
                  if (photo.author != null) ...[
                    Row(
                      children: [
                        Icon(Icons.person, size: 20, color: Colors.grey[600]),
                        SizedBox(width: 8),
                        Text(
                          'Автор: ${photo.author}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                  ],
                  if (photo.likes != null) ...[
                    Row(
                      children: [
                        Icon(Icons.favorite, size: 20, color: Colors.red),
                        SizedBox(width: 8),
                        Text(
                          '${photo.likes} лайков',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                  ],
                  if (photo.description != null) ...[
                    Divider(),
                    SizedBox(height: 8),
                    Text(
                      'Описание',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      photo.description!,
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Удалить фото?'),
          content: Text('Вы уверены, что хотите удалить это фото?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text('Отмена'),
            ),
            TextButton(
              onPressed: () {
                context.read<HomeController>().removePhoto(photo.id);
                Navigator.pop(dialogContext);
                Navigator.pop(context);
              },
              child: Text(
                'Удалить',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
