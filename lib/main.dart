import 'package:bookartify/auth_page.dart';
import 'package:bookartify/home_page.dart';
import 'package:bookartify/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Something went wrong"),);
          }
          else if (snapshot.hasData) {
            // if user is logged in
            return const HomePage();
          }
          else {
            return const AuthPage();
          }
        },
      ),
    );
  }
}
