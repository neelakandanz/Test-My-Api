import 'package:flutter/material.dart';
import 'app/mvc/view/home_screen.dart';

void main() {
  runApp(const ApiTesterApp());
}

//test
class ApiTesterApp extends StatelessWidget {
  const ApiTesterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Test My Api',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const ApiTesterHome(),
    );
  }
}
