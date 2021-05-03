import 'package:connectivity/connectivity.dart';
import 'package:qoutes_app/provider/ConnectivityProvider.dart';

class ConnectionService {
  void checkConnection(ConnectivityProvider connectivityProvider) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      connectivityProvider.connectionStatus = connectivityResult.toString();
    } else {
      connectivityProvider.connectionStatus = 'None';
    }
  }
}
