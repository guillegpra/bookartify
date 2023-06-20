import 'package:bookartify/login_page.dart';
import 'package:bookartify/signup_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const Bookartify());
}

class Bookartify extends StatelessWidget {
  const Bookartify({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "BookARtify",
      theme: ThemeData(primarySwatch: Colors.amber),
      home: const LoginPage(),
    );
  }
}
