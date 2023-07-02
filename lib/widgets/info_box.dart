import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InfoBox extends StatelessWidget {
  final String title;
  final int number;

  const InfoBox({super.key, required this.title, required this.number});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFF5EFE1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Color(0xFFE3D4B5),
          width: 1
        )
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                color: const Color(0xFF372213),
                fontWeight: FontWeight.w500
              )
            ),
            Text(number.toString())
          ],
        ),
      ),
    );
  }
}
