import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';

class ConnectivityProvider extends ChangeNotifier{

String _connectionStatus;

String get connectionStatus => _connectionStatus;

  set connectionStatus(String value) {
    _connectionStatus = value;
    notifyListeners();
  }
}