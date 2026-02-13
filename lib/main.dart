import 'package:dicoman/screens/login.dart';
import 'package:flutter/material.dart';
//import 'screens/main_navigation.dart';
void main() {
  runApp(const DicomanApp());
}

class DicomanApp extends StatelessWidget {
  const DicomanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dicoman DiST',
  theme: ThemeData(
    useMaterial3: true, 
    colorSchemeSeed:Color(0xFF006064),
    brightness: Brightness.light,
  ),

  darkTheme: ThemeData(
    useMaterial3: true,
    colorSchemeSeed: Color(0xFF006064),
    brightness: Brightness.dark,
  ),

  themeMode: ThemeMode.system,
      home: LoginScreen(),
    );
  }
}