import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spa_project/features/home/domain/entity/photo_entity.dart';
import 'package:spa_project/features/home/presentation/controller/home_controller.dart';

class AddPhotoScreen extends StatefulWidget {
  final PhotoEntity? photo;

  const AddPhotoScreen({super.key, this.photo});

  @override
  State<AddPhotoScreen> createState() => _AddPhotoScreenState();
}

class _AddPhotoScreenState extends State<AddPhotoScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _urlController;
  late TextEditingController _titleController;
  late TextEditingController _authorController;
  late TextEditingController _descriptionController;
  late TextEditingController _likesController;

  @override
  void initState() {
    super.initState();
    _urlController = TextEditingController(text: widget.photo?.path ?? '');
    _titleController = TextEditingController(text: widget.photo?.title ?? '');
    _authorController = TextEditingController(text: widget.photo?.author ?? '');
    _descriptionController =
        TextEditingController(text: widget.photo?.description ?? '');
    _likesController =
        TextEditingController(text: widget.photo?.likes?.toString() ?? '0');
  }

  @override
  void dispose() {
    _urlController.dispose();
    _titleController.dispose();
    _authorController.dispose();
    _descriptionController.dispose();
    _likesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.photo != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Редактировать фото' : 'Добавить фото'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _urlController,
                decoration: InputDecoration(
                  labelText: 'URL изображения',
                  hintText: 'https://example.com/image.jpg',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.link),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите URL';
                  }
                  if (!value.startsWith('http')) {
                    return 'URL должен начинаться с http или https';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Название',
                  hintText: 'Введите название фото',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.title),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _authorController,
                decoration: InputDecoration(
                  labelText: 'Автор',
                  hintText: 'Имя автора',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Описание',
                  hintText: 'Описание фотографии',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _likesController,
                decoration: InputDecoration(
                  labelText: 'Лайки',
                  hintText: '0',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.favorite),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    if (int.tryParse(value) == null) {
                      return 'Введите число';
                    }
                  }
                  return null;
                },
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _savePhoto,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  isEdit ? 'Сохранить изменения' : 'Добавить фото',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _savePhoto() {
    if (_formKey.currentState!.validate()) {
      final photo = PhotoEntity(
        id: widget.photo?.id ?? DateTime.now().toString(),
        path: _urlController.text,
        title: _titleController.text.isEmpty ? null : _titleController.text,
        author: _authorController.text.isEmpty ? null : _authorController.text,
        description: _descriptionController.text.isEmpty
            ? null
            : _descriptionController.text,
        likes: int.tryParse(_likesController.text),
      );

      final controller = context.read<HomeController>();

      if (widget.photo != null) {
        controller.updatePhoto(photo);
      } else {
        controller.addPhoto(photo);
      }

      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.photo != null
                ? 'Фото успешно обновлено'
                : 'Фото успешно добавлено',
          ),
        ),
      );
    }
  }
}
