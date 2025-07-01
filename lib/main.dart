import 'package:flutter/material.dart';
import 'Pages/splash-screen.dart';
import 'Pages/home-page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hello Me',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Sans', // Ubah default ke Sans
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/home': (context) => const HomePage(),
      },
    );
  }
}
