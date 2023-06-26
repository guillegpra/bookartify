import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UploadScreen extends StatelessWidget {
  const UploadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "Upload Screen",
          style: GoogleFonts.poppins(
              fontSize: 24
          ),
        ),
      ),
    );
  }
}
