import 'package:flutter/material.dart';
import 'package:oltinchi_oy_imtihon_oddiygina/kirish/kirish_soniyasi.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: KirishSoniyasi(),
    );
  }
}