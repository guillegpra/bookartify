import 'package:bookartify/widgets/icons_and_buttons/save_icon.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/variety_art.dart';

class ArtImageContainer extends StatelessWidget {
  const ArtImageContainer({Key? key, required this.artwork}) : super(key: key);

  final VarietyArt artwork;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: const Color(0xFFF5EFE1),
          borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Expanded(
              flex: 5,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(artwork.artImagePath, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        artwork.artTitle,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                     
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(5, 5,5, 5),
                    child: SaveIcon(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
