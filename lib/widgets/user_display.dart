import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:bookartify/widgets/share_profile_button.dart';

class UserDisplay extends StatelessWidget {
  final String username;

  const UserDisplay({super.key, required this.username});

  Future<void> _launchUrl() async {
    Uri url =
        Uri.parse("https://www.goodreads.com/user/sign_in"); // TODO: change url
    if (!await launchUrl(url)) {
      throw Exception("Could not lunch $url");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              username,
              style: GoogleFonts.dmSerifDisplay(
                  fontWeight: FontWeight.bold, fontSize: 24),
            ),
            IconButton(
                onPressed: () {
                  _launchUrl();
                },
                icon: Image.asset(
                  "images/goodreads_icon.png",
                  width: 15,
                  height: 15,
                ))
          ],
        ),
        SizedBox(
          width: 200,
          child: Text(
            "lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            softWrap: false,
            style: GoogleFonts.poppins(fontSize: 12),
          ),
        ),
        // FollowButton(isFollowing: false),
        Row(
          children: [
            ElevatedButton(
                onPressed: () {
                  // TODO: take you to edit profile
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFF5EFE1),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0))),
                child: Text(
                  "Edit profile",
                  style: GoogleFonts.poppins(color: Color(0xFF2F2F2F)),
                )),
            ShareProfileButton(onPressed: () {
              // TODO: share functionality
            })
          ],
        )
      ],
    );
  }
}
