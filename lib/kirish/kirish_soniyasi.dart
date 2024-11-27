import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'dart:async';

import 'package:oltinchi_oy_imtihon_oddiygina/kirish/registratsiya/register.dart';

class KirishSoniyasi extends StatefulWidget {
  const KirishSoniyasi({super.key});

  @override
  _KirishSoniyasiState createState() => _KirishSoniyasiState();
}

class _KirishSoniyasiState extends State<KirishSoniyasi> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => RegistratsiyaPage(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, 
      body: Center(
        child: Lottie.asset(
          'lottifor/1.json', 
          height: 180, 
        ),
      ),
    );
  }
}
