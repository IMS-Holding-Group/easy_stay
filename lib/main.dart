import 'package:flutter/material.dart';
import 'screens/register_screen.dart';

/// EasyStay Hotel Booking Application
/// Main entry point of the application
void main() {
  runApp(const EasyStayApp());
}

/// Root widget of the EasyStay application
class EasyStayApp extends StatelessWidget {
  const EasyStayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EasyStay',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        fontFamily: 'IBMPlexSansArabic',
      ),
      home: const RegisterScreen(),
    );
  }
}
