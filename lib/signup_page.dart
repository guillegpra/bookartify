import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
            "BookARtify",
            style: GoogleFonts.dmSerifDisplay(
              fontSize: 22.0
            ),
        ),
        leading: IconButton(
            onPressed: () {
              print("Icon pressed");
            },
            icon: Icon(Icons.arrow_back)
        ),
      ),
      body: Column()
    );
  }
}
