import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/synopsis_class.dart';

class SynopsisWidget extends StatelessWidget {
  const SynopsisWidget({super.key, required this.synopsis});

  final Synopsis synopsis;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          synopsis.synopsisInfo,
          style: GoogleFonts.poppins(fontSize: 16, color: Colors.black),
          textAlign: TextAlign.justify,
        ),
      ),
    );
  }
}
