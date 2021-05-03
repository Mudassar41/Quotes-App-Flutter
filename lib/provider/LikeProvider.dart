import 'package:flutter/cupertino.dart';
import 'package:qoutes_app/models/Images.dart';

class LikeProvider extends ChangeNotifier {
  List<Images> likedImages = [];
  int _Total;

  int get Total => _Total;

  set Total(int value) {
    _Total = value;
    notifyListeners();
  }

  Future<List<Images>> getLikedImages() async => likedImages;

  setLikedImages(List<Images> value) {
    likedImages = value;
    notifyListeners();
  }
}
