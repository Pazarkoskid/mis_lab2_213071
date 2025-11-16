import 'package:flutter/material.dart';
import 'screens/home_screen.dart';


void main() {
  runApp(const MealApp());
}


class MealApp extends StatelessWidget {
  const MealApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MealApp',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const HomeScreen(),
    );
  }
}