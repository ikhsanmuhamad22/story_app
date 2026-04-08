import 'package:flutter/material.dart';
import 'package:story_app/ui/login_page.dart';
import 'package:story_app/ui/signin_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 00, 82, 204),
        ),
      ),
      home: const SigninPage(),
    );
  }
}
