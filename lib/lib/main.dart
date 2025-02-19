import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(WarrantyApp());
}

class WarrantyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Warranty Service App',
      theme: ThemeData.dark(),
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
