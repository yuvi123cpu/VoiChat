import 'package:Talkify/animatedloader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Talkify/speechscreen.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      home: SpeechScreen(),
      debugShowCheckedModeBanner: false,
      title: "Talkify",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}

