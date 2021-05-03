import 'package:admob_flutter/admob_flutter.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:qoutes_app/provider/ConnectivityProvider.dart';
import 'package:qoutes_app/provider/LikeProvider.dart';
import 'package:qoutes_app/utils/Customcolors.dart';
import 'package:qoutes_app/utils/Screensize.dart';
import 'package:qoutes_app/utils/strings.dart';
import 'package:qoutes_app/widgets/Tabs.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FirebaseAdMob.instance.initialize(appId: Strings.appId);
  Admob.initialize();

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Customcolors.green, // status bar color
  ));
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<LikeProvider>(
        create: (BuildContext context) {
          return LikeProvider();
        },
      ),
      ChangeNotifierProvider<ConnectivityProvider>(
        create: (BuildContext context) {
          return ConnectivityProvider();
        },
      ),
    ],
    child: QuoteApp(),
  ));
}

class QuoteApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constrainsts) {
        Screensize().init(constrainsts);
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: ThemeData(
              accentColor: Customcolors.green,
              primaryColor: Customcolors.green,
              primaryColorDark: Customcolors.green,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            home: Tabs());
      },
    );
  }
}
