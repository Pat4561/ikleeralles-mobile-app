import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n_delegate.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_stetho/flutter_stetho.dart';
import 'package:ikleeralles/constants.dart';
import 'package:ikleeralles/network/auth/service.dart';
import 'package:ikleeralles/network/auth/userinfo.dart';
import 'package:ikleeralles/pages/login.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

Future main() async {
  final FlutterI18nDelegate flutterI18nDelegate = FlutterI18nDelegate(
      useCountryCode: false,
      fallbackFile: 'nl',
      path: MainApp.localizationAssetPath,
      forcedLocale: new Locale('nl'));
  WidgetsFlutterBinding.ensureInitialized();//For testing cases
  Stetho.initialize();

  await Purchases.setDebugLogsEnabled(true);
  await Purchases.setup("lZwNhhpJqSOiIzyEtooQCAJyqLNikxuD");

  await flutterI18nDelegate.load(null);


  runApp(MainApp(flutterI18nDelegate));
}




class MainApp extends StatefulWidget {

  static const String localizationAssetPath = "assets/i18n";

  final FlutterI18nDelegate flutterI18nDelegate;

  MainApp (this.flutterI18nDelegate);

  @override
  State<StatefulWidget> createState() {
    return MainAppState();
  }
}



class MainAppState extends State<MainApp> {



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Constants.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginPage(),
      localizationsDelegates: [
        this.widget.flutterI18nDelegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
    );
  }

}