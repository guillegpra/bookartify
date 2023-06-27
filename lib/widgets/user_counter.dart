import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UserCounter extends StatelessWidget {
  final String name;
  final int number;

  const UserCounter({super.key, required this.name, required this.number});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
            name,
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                color: Color(0xFF8A6245)
            )
        ),
        Text("$number")
      ],
    );
  }
}
