import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Screensize {
    static  double _screenWidth;
  static  double _screenHeight;
  static  double _blockWidth = 0;
  static  double _blockHeight = 0;

  static  double textMultiplier;
  static  double imageSizeMultiplier;
  static  double heightMultiplier;
  static  double widthMultiplier;

  void init(BoxConstraints constraints) {
    _screenWidth = constraints.maxWidth;
    _screenHeight = constraints.maxHeight;
    _blockWidth = _screenWidth / 100;
    _blockHeight = _screenHeight / 100;
    textMultiplier = _blockHeight;
    imageSizeMultiplier = _blockHeight;
    heightMultiplier = _blockHeight;
    widthMultiplier = _blockWidth;

    print(heightMultiplier);
  }
}
