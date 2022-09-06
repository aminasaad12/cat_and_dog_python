import 'package:cat_and_dog_python/home.dart';
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

// @dart=2.9
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DOG VS CAT',
      home: SplashScreen(
        seconds: 14,
        navigateAfterSeconds: Home(),
        photoSize: 50.0,
        title:  Text(
          'DOG AND CAT',
          style:  TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
        ),
        image:  Image.asset(
            'assets/images/cat.png'),
        backgroundColor: Colors.black,
        loaderColor: Colors.yellow,
      ),
    );
  }
}


