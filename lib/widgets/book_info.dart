import 'package:bookartify/widgets/info_box.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BookInfo extends StatelessWidget {
  const BookInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.0, top: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: Color(0xFFF5EFE1),
              borderRadius: BorderRadius.circular(10)
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                "images/book_cover.jpg",
                fit: BoxFit.cover,
              ),
            )
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Book Title",
                style: GoogleFonts.dmSerifDisplay(
                  fontWeight: FontWeight.bold,
                  fontSize: 20
                ),
              ),
              Text("by Author Name"),
              Row(
                children: [
                  InfoBox(title: "Released", number: 2022),
                  SizedBox(width: 10.0),
                  InfoBox(title: "Pages", number: 340)
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
