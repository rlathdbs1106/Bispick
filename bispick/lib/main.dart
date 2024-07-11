import 'package:bispick/firebase_options.dart';
import 'package:bispick/pages/alllostthings.dart';
import 'package:bispick/pages/camerapage.dart';
import 'package:bispick/pages/clothing.dart';
import 'package:bispick/pages/edevice.dart';
import 'package:bispick/pages/homepage.dart';
import 'package:bispick/pages/itemsdetail.dart';
import 'package:bispick/pages/others.dart';
import 'package:bispick/pages/registerpage.dart';
import 'package:bispick/pages/requestpage.dart';
import 'package:bispick/pages/stationary.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'pages/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Bispick', initialRoute: 'loginView', routes: {
      'loginView': (context) => Homepage(),
      'registerView': (context) => RegisterPage(),
      'homeView': (context) => MainPage(),
      'cameraView': (context) => CameraPage(),
      'allLostItemsView': (context) => AllLostThings(),
      'requestView': (context) => RequestPage(),
      'othersView': (context) => Others(),
      'stationaryView': (context) => Stationary(),
      'edeviceView': (context) => Edevice(),
      'clothingView': (context) => Clothing(),
    });
  }
}
