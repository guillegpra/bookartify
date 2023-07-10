import 'package:bookartify/is_tablet.dart';
import 'package:bookartify/widgets/inactive_searchbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bookartify/screens/viewmore_screen.dart';
import 'package:bookartify/widgets/icons_and_buttons/save_icon.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: InactiveSearchBar(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCardSection('Fiction', 'Art Work Title 1', 'Artist Name 1',
                'images/forYouSample.jpg', context),
            _buildCardSection('Fantasy', 'Art Work Title 2', 'Artist Name 2',
                'images/forYouSample.jpg', context),
          ],
        ),
      ),
    );
  }

  Widget _buildCardSection(String genre, String artTitle, String artist,
      String image, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            decoration: BoxDecoration(
              color: const Color.fromRGBO(245, 239, 225, 1),
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(
                color: const Color.fromRGBO(191, 160, 84, 1),
                width: 2.0,
              ),
            ),
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  genre,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    color: const Color.fromRGBO(47, 47, 47, 1),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 220.0, // Adjust the height of the card
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: !isTablet(context)
                  ? List.generate(4, (index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: _buildCard(artTitle, artist, image),
                      );
                    })
                  : List.generate(8, (index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: _buildCard(artTitle, artist, image),
                      );
                    }),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewMoreScreen(
                      genre: genre,
                    ),
                  ),
                );
              },
              child: const Text(
                'View More',
                style: TextStyle(
                  color: Color.fromRGBO(55, 34, 19, 1),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCard(String artTitle, String artist, String image) {
    return Card(
      color: const Color.fromRGBO(245, 239, 225, 1),
      child: SizedBox(
        width: 150.0, // Adjust the width of the card
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              image,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: Text(
                      artTitle,
                      style: GoogleFonts.dmSerifDisplay(fontSize: 18),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  SaveIcon(),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
              child: Text(
                artist,
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

