import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cookédex',
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(), // Default semua teks menggunakan Poppins
        primarySwatch: Colors.orange,
      ),
      home: const SplashScreen(), // Splash screen awal
    );
  }
}
