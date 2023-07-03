import 'package:bookartify/home_page.dart';
import 'package:bookartify/login_page.dart';
import 'package:bookartify/screens/art_screen.dart';
import 'package:bookartify/signup_page.dart';
import 'package:bookartify/firebase_options.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const Bookartify());
}

class Bookartify extends StatelessWidget {
  const Bookartify({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "BookARtify",
      theme: ThemeData(
        primarySwatch: Colors.amber,
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        )
      ),
      home: HomePage(),
    );
  }
}
