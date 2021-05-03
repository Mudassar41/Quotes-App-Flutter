import 'package:flutter/material.dart';

import 'Customcolors.dart';

class Lists {
  static List images = [
    'image.jpg',
    'image.jpg',
    'image.jpg',
    'image.jpg',
    'image.jpg',
    'image.jpg',
    'image.jpg',
    'image.jpg',
    'image.jpg'
  ];
  static List<IconData> icons = [
    Icons.arrow_back_outlined,
    Icons.text_fields,
    Icons.color_lens,
    Icons.text_format,
    Icons.format_align_center,
    Icons.font_download_outlined,
    Icons.height
  ];
  static List<Color> colors = [
    Customcolors.white,
    Customcolors.green,
    Customcolors.blue,
    Customcolors.grey,
    Customcolors.black,
    Customcolors.orange,
    Customcolors.yellow,
    Customcolors.red,
    Customcolors.aqua,
    Customcolors.darkgreen,
    Customcolors.lime,
    Customcolors.maroon,
    Customcolors.olive,
    Customcolors.purple,
    Customcolors.pink,
    Customcolors.silver,
    Customcolors.teal,
    Customcolors.chocolate
  ];
  static List<AlignmentText> align = [
    AlignmentText(
      'Justify',
      TextAlign.justify,
    ),
    AlignmentText(
      'Center',
      TextAlign.center,
    ),
    AlignmentText(
      'Start',
      TextAlign.start,
    ),
    AlignmentText(
      'Right',
      TextAlign.right,
    ),
    AlignmentText(
      'Left',
      TextAlign.left,
    ),
  ];
  static List fonts = [
    'Libre Baskerville',
    'FredokaOne',
    'AlfaSlab',
    'PermanentMarker',
    'Pacifico',
    'Arvo',
    'Lobster',
    'Crimson',
    'BebasNeue',
    'Nunitno'
  ];
}

class AlignmentText {
  String txt;
  TextAlign align;

  AlignmentText(this.txt, this.align);
}
