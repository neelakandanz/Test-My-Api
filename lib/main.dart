import 'package:flutter/material.dart';
import 'app/mvc/view/home_screen.dart';

void main() {
  runApp(const ApiTesterApp());
}

class ApiTesterApp extends StatelessWidget {
  const ApiTesterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'API Tester',
      theme: ThemeData(primarySwatch: Colors.blue),
      home:  ApiTesterHome(),
    );
  }
}
