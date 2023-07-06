import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonText;

  const RegisterButton({super.key, required this.onPressed, required this.buttonText});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2F2F2F),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)
          ),
          textStyle: GoogleFonts.dmSerifDisplay(
            fontSize: 18,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            buttonText,
            style: const TextStyle(
                color: Color(0xFFFBF8F2)
            ),
          ),
        )
    );
  }
}
