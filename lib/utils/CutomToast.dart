import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'Customcolors.dart';

class CustomToast {
  static void ShowToast(String text) {
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Customcolors.green,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
