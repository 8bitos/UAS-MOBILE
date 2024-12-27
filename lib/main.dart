import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uas_cookedex/account/acc_edit.dart';
import 'package:uas_cookedex/community/community.dart';
import 'package:uas_cookedex/home/notification.dart';

import 'package:uas_cookedex/screens/splash_screen.dart';
import 'package:uas_cookedex/home/home.dart'; // Import HomePage
import 'package:uas_cookedex/account/acc_page.dart';
import 'package:uas_cookedex/account/acc_setting.dart';

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
        textTheme: GoogleFonts.poppinsTextTheme(),
        primarySwatch: Colors.orange,
      ),
      initialRoute: '/', // Define the initial route
      routes: {
        '/': (context) => const SplashScreen(), 
        '/home': (context) => const HomePage(),
        '/account': (context) => const AccountPage(),
        '/notification':(context) => const NotificationPage(),
        '/community-recipes':(context) => const CommunityPage(),
        '/acc-setting':(context) => const AccSettingPage(),
        '/editProfile':(context) => const EditProfilePage(),
      },
    );
  }
}
