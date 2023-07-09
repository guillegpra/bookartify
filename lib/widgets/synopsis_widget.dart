import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SynopsisWidget extends StatelessWidget {
  final String synopsis;

  const SynopsisWidget({super.key, required this.synopsis});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          synopsis,
          style: GoogleFonts.poppins(fontSize: 14, color: Colors.black),
          textAlign: TextAlign.start,
        ),
      ),
    );
  }
}
