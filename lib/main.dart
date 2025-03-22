import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutterapk/screens/Ngo_food.dart';
import 'package:flutterapk/screens/choose_user.dart';
import 'package:flutterapk/screens/donar_screen.dart';
import 'package:flutterapk/screens/donarhome_screen.dart';
import 'package:flutterapk/screens/home_screen.dart';
import 'package:flutterapk/screens/ngo_homescreen.dart';
import 'package:flutterapk/screens/ngo_screen.dart';
import 'package:flutterapk/screens/ngohome_screen.dart';
import 'package:flutterapk/screens/signin_screen.dart';
import 'package:flutterapk/screens/profile_screen.dart';

import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Food waste',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: SplashScreen(),
    );
  }
}
