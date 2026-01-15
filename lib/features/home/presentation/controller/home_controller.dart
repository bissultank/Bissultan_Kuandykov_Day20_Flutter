import 'package:flutter/material.dart';
import 'package:spa_project/core/utils/status_enum.dart';
import 'package:spa_project/features/home/data/repository_impl/home_repository_impl.dart';
import 'package:spa_project/features/home/domain/entity/photo_entity.dart';
import 'package:spa_project/features/home/domain/repository/home_repository.dart';

class HomeController extends ChangeNotifier {
  HomeController();

  final HomeRepository _repository = HomeRepositoryImpl();

  List<PhotoEntity>? get photo => _photos;

  List<PhotoEntity>? _photos = [];
  StatusEnum status = StatusEnum.initial;

  Future<void> randomPhotos() async {
    status = StatusEnum.loading;
    notifyListeners();
    final response = await _repository.randomPhotos();

    if (response == null) {
      status = StatusEnum.error;
      notifyListeners();
      return;
    }

    _photos = response;
    status = StatusEnum.success;
    notifyListeners();
  }

  Future<void> search(String value) async {
    if (value.isEmpty) {
      await randomPhotos();
      return;
    }
    
    status = StatusEnum.loading;
    notifyListeners();
    
    final response = await _repository.searchPhotos(value);

    if (response == null) {
      status = StatusEnum.error;
      notifyListeners();
      return;
    }

    _photos = response;
    status = StatusEnum.success;
    notifyListeners();
  }

  void addPhoto(PhotoEntity photo) {
    _photos?.insert(0, photo);
    notifyListeners();
  }

  void removePhoto(String id) {
    _photos?.removeWhere((photo) => photo.id == id);
    notifyListeners();
  }

  void updatePhoto(PhotoEntity updatedPhoto) {
    final index = _photos?.indexWhere((photo) => photo.id == updatedPhoto.id);
    if (index != null && index != -1) {
      _photos![index] = updatedPhoto;
      notifyListeners();
    }
  }
}
