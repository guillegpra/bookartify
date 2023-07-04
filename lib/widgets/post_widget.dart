import 'package:bookartify/is_tablet.dart';
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
      // height: 250,
      decoration: BoxDecoration(
        color: const Color(0xFFF5EFE1),
        borderRadius: BorderRadius.circular(10)
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                path,
                height: !isTablet(context) ? 200 : 480,
                fit: BoxFit.fitHeight,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              title,
              style: GoogleFonts.dmSerifDisplay(
                fontSize: !isTablet(context) ? 16 : 20,
                fontWeight: FontWeight.bold
              ),
            )
          ],
        ),
      ),
    );
  }
}
