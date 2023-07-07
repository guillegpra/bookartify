import 'package:bookartify/widgets/info_box.dart';
import 'package:bookartify/widgets/icons_and_buttons/save_icon.dart';
import 'package:bookartify/widgets/upload_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

class BookInfoTablet extends StatelessWidget {
  const BookInfoTablet({super.key});

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
              width: MediaQuery.of(context).size.width * 0.20,
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
              const SizedBox(height: 8.0,),
              const Row(
                children: [
                  InfoBox(title: "Released", info: "April 2022"),
                  SizedBox(width: 10.0),
                  InfoBox(title: "Pages", info: "340")
                ],
              ),
              const SizedBox(height: 8.0),
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
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.3,
            child: Text(
              "The Seven Husbands of Evelyn Hugo tells the story of old Hollywood actor Evelyn Hugo, determined to secure an A-List spot in the industry by doing whatever it takes to get there. While attempting to complete her rise to stardom, she marries  seven husbands and outlives them all. Later in her life, Hugo then hires a lesser-known journalist to write her memoir and, for the first time in her decorated life, tells details and secrets about her love life leaving readers with no choice but to keep turning the pages.\n\nMonique Grant – the journalist hired by Hugo – goes on her own journey while learning about the actress and as the book goes on, Grant seeks to discover why she was chosen to document Hugo’s life. The reason is later revealed, in a twist leaving readers on edge.",
              maxLines: 20,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
              style: GoogleFonts.poppins(
                fontSize: 14
              )
            ),
          )
        ],
      ),
    );
  }
}
