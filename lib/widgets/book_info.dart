import 'package:bookartify/widgets/info_box.dart';
import 'package:bookartify/widgets/register_button.dart';
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
            height: 240,
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
              SizedBox(height: 8.0,),
              Row(
                children: [
                  InfoBox(title: "Released", number: 2022),
                  SizedBox(width: 10.0),
                  InfoBox(title: "Pages", number: 340)
                ],
              ),
              SizedBox(height: 8.0),
              IntrinsicWidth(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // TODO: take to upload cover page
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFBFA054),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                        ),
                        textStyle: GoogleFonts.dmSerifDisplay(
                          fontSize: 14,
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(6.0),
                        child: Text(
                          "Upload your cover",
                          style: TextStyle(
                              color: Color(0xFF2F2F2F)
                          ),
                        ),
                      )
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // TODO: take to upload art page
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2F2F2F),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                        ),
                        textStyle: GoogleFonts.dmSerifDisplay(
                          fontSize: 14,
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(6.0),
                        child: Text(
                          "Upload your art",
                          style: TextStyle(
                              color: Color(0xFFFBF8F2)
                          ),
                        ),
                      )
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
