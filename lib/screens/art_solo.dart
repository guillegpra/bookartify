import 'package:bookartify/widgets/icons_and_buttons/like_icon.dart';
import 'package:bookartify/widgets/icons_and_buttons/save_icon.dart';
import 'package:bookartify/widgets/icons_and_buttons/share_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bookartify/models/book_search.dart';

class ArtSoloScreen extends StatelessWidget {
  final String imagePath;
  final String imageTitle;
  final Book book;

  const ArtSoloScreen({super.key,
    required this.imagePath,
    required this.imageTitle,
    required this.book,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[50],
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(
                context); // Go back to the previous screen when the back button is pressed
          },
        ),
        title: Text(
          imageTitle, // Display the image title in the app bar
          style: GoogleFonts.dmSerifDisplay(
            // fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    imagePath, // Display the clicked image
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(42),
                    color: const Color.fromARGB(70, 192, 162, 73),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(25, 8, 25, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                imageTitle, // Display the image title
                                style: GoogleFonts.dmSerifDisplay(
                                    fontSize: 19, fontWeight: FontWeight.w600),
                              ),
                              Text(
                                'By artist', // Display the artist name
                                style: GoogleFonts.poppins(
                                    fontSize: 15, fontWeight: FontWeight.w300),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const LikeIcon(),
                              const SizedBox(width: 10),
                              const SaveIcon(),
                              // const SizedBox(width: 20),
                              ShareButton(
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(70, 192, 162, 73),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    crossAxisAlignment:
                        CrossAxisAlignment.start, // Align children to the top
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Book Title:",
                              style: GoogleFonts.dmSerifDisplay(
                                  fontSize: 19, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              book.title,
                              style: GoogleFonts.poppins(
                                  fontSize: 15, fontWeight: FontWeight.w300),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20), // Add spacing between the columns
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Author:",
                              style: GoogleFonts.dmSerifDisplay(
                                  fontSize: 19, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              book.author,
                              style: GoogleFonts.poppins(
                                  fontSize: 15, fontWeight: FontWeight.w300),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 10, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Description",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w300,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        print("Button pressed!");
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(
                            255, 192, 162, 73), // background color
                        foregroundColor: Colors.black, // text color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              5), // button's corner radius
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 0,
                        ),
                        child: Text(
                          "Add to Collection",
                          style: GoogleFonts.poppins(
                              fontSize: 16, fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        print("Button pressed!");
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 47, 47, 47),
                        foregroundColor: Colors.white, // text color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              5), // button's corner radius
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 28,
                        ),
                        child: Text(
                          "View in AR",
                          style: GoogleFonts.poppins(
                              fontSize: 16, fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.only(left: 18.0),
                  child: Text(
                    "View more works....",
                    style: GoogleFonts.poppins(
                        fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Replace the ArtGridView() with the relevant widgets to show more works if needed
            ],
          ),
        ),
      ),
    );
  }
}
