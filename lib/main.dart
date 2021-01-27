import 'package:flutter/material.dart';
import 'package:forklift/pages/simple_movement_page.dart';
import 'package:forklift/pages/splashscreen.dart';
import 'package:forklift/pages/start_page.dart';
import 'package:forklift/utils/special_color.dart';

import 'package:camera/camera.dart';

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
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => MySplashScreen(cameras),
        '/start': (context) => StartPage(cameras),
        SimpleMovementPage.SimpleMovementPageRoute: (context) =>
            SimpleMovementPage(),
      },
      title: 'forklift',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: createMaterialColor(Color(0xFFBF1537)),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}
