import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:oltinchi_oy_imtihon_oddiygina/Home_page/Home.dart';
import 'package:oltinchi_oy_imtihon_oddiygina/kirish/registratsiya/register.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Text controllers for user input (assuming you want to pass these values to Homepage)
  final TextEditingController familiyaController = TextEditingController();
  final TextEditingController ismController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // Dispose controllers to prevent memory leaks
    familiyaController.dispose();
    ismController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: checkLoginStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              backgroundColor: Colors.white,
              body: Center(
                child: Lottie.asset(
                  'lottifor/1.json', // Lottie animation file path
                  height: 180,
                ),
              ),
            );
          } else {
            // If user is logged in, show HomePage, else show RegistrationPage
            if (snapshot.data == true) {
              return Homepage(
                familiya: familiyaController.text,
                ism: ismController.text,
              );
            } else {
              return RegistratsiyaPage();
            }
          }
        },
      ),
    );
  }

  // Check login status using SharedPreferences
  Future<bool> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }
}
