import 'package:bookartify/widgets/info_box.dart';
import 'package:bookartify/widgets/register_button.dart';
import 'package:bookartify/widgets/save_icon.dart';
import 'package:bookartify/widgets/upload_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BookInfo extends StatelessWidget {
  const BookInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0, top: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            // height: 240,
            // height: MediaQuery.of(context).size.height * 0.3,
            // take up 42% of the screen width
            width: MediaQuery.of(context).size.width * 0.42,
            decoration: BoxDecoration(
              color: const Color(0xFFF5EFE1),
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
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
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
                      const Text("by Author Name"),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 15),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      child: SaveIcon(),
                    ),
                  )
                ],
              ),
              SizedBox(height: 8.0,),
              Row(
                children: [
                  InfoBox(title: "Released", info: "April 2022"),
                  SizedBox(width: 10.0),
                  InfoBox(title: "Pages", info: "340")
                ],
              ),
              SizedBox(height: 8.0),
              IntrinsicWidth(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    UploadButton(
                      buttonLabel: 'Upload your cover',
                      onPressed: () {
                        // TODO
                      },
                      backgroundColor: const Color(0xFFBFA054),
                      foregroundColor: const Color(0xFF2F2F2F),
                      icon: const Icon(
                        CupertinoIcons.add,
                        size: 22,
                      ),
                    ),
                    UploadButton(
                      buttonLabel: 'Upload your art',
                      onPressed: () {
                        // TODO
                      },
                      backgroundColor: const Color(0xFF2F2F2F),
                      foregroundColor: const Color(0xFFFBF8F2),
                      icon: const Icon(
                        CupertinoIcons.add,
                        size: 22,
                      ),
                    ),
                    // ElevatedButton(
                    //   onPressed: () {
                    //     // TODO: take to upload art page
                    //   },
                    //   style: ElevatedButton.styleFrom(
                    //     backgroundColor: const Color(0xFF2F2F2F),
                    //     shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(10)
                    //     ),
                    //     textStyle: GoogleFonts.dmSerifDisplay(
                    //       fontSize: 14,
                    //     ),
                    //   ),
                    //   child: const Padding(
                    //     padding: EdgeInsets.all(6.0),
                    //     child: Text(
                    //       "Upload your art",
                    //       style: TextStyle(
                    //           color: Color(0xFFFBF8F2)
                    //       ),
                    //     ),
                    //   )
                    // ),
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
