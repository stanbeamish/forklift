import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:forklift/pages/detect_page.dart';
import 'package:forklift/pages/finger_move_page.dart';

import 'package:forklift/pages/simple_movement_page.dart';
import 'package:forklift/pages/splashscreen_page.dart';
import 'package:forklift/pages/start_page.dart';
import 'package:forklift/utils/special_color.dart';

List<CameraDescription> cameras;

Future<Null> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch:
            MaterialColorUtils.createMaterialColor(Color(0xFFBF1537)),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      title: 'forklift',
      initialRoute: MySplashScreen.SplashScreenRoute,
      routes: {
        MySplashScreen.SplashScreenRoute: (context) => MySplashScreen(cameras),
        StartPage.StartPageRoute: (context) => StartPage(cameras),
        DetectPage.DetectPageRoute: (context) => DetectPage(),
        SimpleMovementPage.SimpleMovementPageRoute: (context) =>
            SimpleMovementPage(),
        FingerMovePage.FingerMovePageRoute: (context) => FingerMovePage(),
      },
    );
  }
}
