import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DividerWithText extends StatelessWidget {
  final String text;

  const DividerWithText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        children: [
          Expanded(
            child: Divider(
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              "$text",
              style: GoogleFonts.poppins(
                fontSize: 15.0,
              ),
            ),
          ),
          Expanded(
              child: Divider(
                color: Colors.grey[700],
                height: 1.5,
              )
          )
        ],
      ),
    );
  }
}
