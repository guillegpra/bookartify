import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PostWidget extends StatelessWidget {
  // final double width;
  final String path;
  final String title;

  const PostWidget({super.key, /* required this.width, */ required this.path, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: width,
      height: 250,
      decoration: BoxDecoration(
        color: Color(0xFFF5EFE1),
        borderRadius: BorderRadius.circular(10)
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                path,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 5),
            Text(
              title,
              style: GoogleFonts.dmSerifDisplay(
                fontSize: 16,
                fontWeight: FontWeight.bold
              ),
            )
          ],
        ),
      ),
    );
  }
}
