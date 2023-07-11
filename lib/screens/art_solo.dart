import 'package:bookartify/widgets/art_gridview.dart';
import 'package:bookartify/widgets/icons_and_buttons/like_icon.dart';
import 'package:bookartify/widgets/icons_and_buttons/save_icon.dart';
import 'package:bookartify/widgets/icons_and_buttons/share_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ArtSoloScreen extends StatelessWidget {
  const ArtSoloScreen({super.key});
  
  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            print('To be worked');
          },
        ),
        title: Text(
          'Book Title',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset(
                  'images/fanart.jpg',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical:0, horizontal:5),
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
                              'Artwork Title',
                              style: GoogleFonts.poppins(
                                  fontSize: 19, fontWeight: FontWeight.w500),
                            ),
                            Text(
                              'By Artist Username',
                              style: GoogleFonts.poppins(
                                  fontSize: 14, fontWeight: FontWeight.w300),
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
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 10, 0),
                child: Text(
                  "kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk.....",
                  style: GoogleFonts.poppins(
                      fontSize: 18, fontWeight: FontWeight.w300, color: Colors.grey),
                ),
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
                        borderRadius:
                            BorderRadius.circular(5), // button's corner radius
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
                        borderRadius:
                            BorderRadius.circular(5), // button's corner radius
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
            const ArtGridView(),
          ],
        ),
      
      ),
    );
  }
}
