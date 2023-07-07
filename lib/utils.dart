import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Utils {
  static final messengerKey = GlobalKey<ScaffoldMessengerState>();

  static showSnackBar(String? text, bool? error) {
    if (text == null || error == null) return;
    
    final snackBar = SnackBar(
      content: Text(
        text,
        style: GoogleFonts.poppins(
          color: error ? Colors.white : Colors.black,
        ),
      ),
      backgroundColor: error ? Colors.red : const Color(0xFFF5EFE1),
    );

    messengerKey.currentState!
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}