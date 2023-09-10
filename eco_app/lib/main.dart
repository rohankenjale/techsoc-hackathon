import 'package:eco_app/productSearch.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: ProductSearchPage(),
      theme: new ThemeData(scaffoldBackgroundColor: Color.fromARGB(255, 231, 250, 215)),
      );
  }
}