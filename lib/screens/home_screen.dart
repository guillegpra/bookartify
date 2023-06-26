import 'package:bookartify/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SearchScanBar(),
      body: Center(
        child: Text(
          "Home Screen",
          style: GoogleFonts.poppins(
              fontSize: 24
          ),
        ),
      ),
    );
  }
}
