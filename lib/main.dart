import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:smartplant/gps/location.dart';
import 'package:smartplant/list/homelist.dart';
import 'package:smartplant/mqtt/mqtt.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  await Hive.initFlutter();
  await Hive.openBox('plantDb');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.grey[900],
        backgroundColor: Colors.grey[900],
        scaffoldBackgroundColor: Colors.grey[900],
      ),
      home: AnimatedSplashScreen(
          splashIconSize: 300,
          duration: 2000,
          splash: Container(
            child: Image.asset('images/plant.png'),
          ),
          nextScreen: MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => Location()),
              ChangeNotifierProvider(create: (_) => Mqtt()),
            ],
            child: MyHomeList(),
          ),
          splashTransition: SplashTransition.slideTransition,
          pageTransitionType: PageTransitionType.fade,
          animationDuration: Duration(seconds: 2),
          backgroundColor: Colors.grey[900]!),
    );
  }
}
