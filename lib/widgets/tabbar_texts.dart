import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTab extends StatelessWidget {
  const CustomTab({
    super.key,
    required this.text,
    this.isSelected = false,
  });

  final String text;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Text(
        text,
        style: GoogleFonts.poppins(
            fontSize: isSelected ? 18 : 16,
            fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
            color: Colors.black),
      ),
    );
  }
}
