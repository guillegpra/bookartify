import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:bookartify/widgets/icons_and_buttons/share_profile_button.dart';
import 'package:bookartify/services/user_bios_db.dart';
import 'package:bookartify/services/user_goodreads_links_db.dart';
import 'package:bookartify/widgets/profile/edit_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserDisplay extends StatelessWidget {
  final String username;

  const UserDisplay({super.key, required this.username});

  Future<void> _launchUrl(BuildContext context) async {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    String? goodreadsUrl = await getUserGoodreadsUrl(currentUser.uid);
    if (goodreadsUrl == null || goodreadsUrl.isEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditProfileScreen(currentUser: currentUser),
        ),
      );
      return;
    }

    Uri url = Uri.parse(goodreadsUrl);
    if (!await launchUrl(url)) {
      throw Exception("Could not lunch $url");
    }
  }

  @override
  Widget build(BuildContext context) {
    final User? currentUser = FirebaseAuth.instance.currentUser;

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
                  _launchUrl(context);
                },
                icon: Image.asset(
                  "images/goodreads_icon.png",
                  width: 15,
                  height: 15,
                ))
          ],
        ),
        FutureBuilder<String?>(
          future: currentUser != null ? getUserBio(currentUser.uid) : null,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text('Error retrieving bio');
            } else {
              final bio = snapshot.data;
              return SizedBox(
                width: 130,
                child: Text(
                  bio ?? 'hi',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                  style: GoogleFonts.poppins(fontSize: 12),
                ),
              );
            }
          },
        ),
        const SizedBox(height: 10), // FollowButton(isFollowing: false),
        Row(
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          EditProfileScreen(currentUser: currentUser),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF5EFE1),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0))),
                child: Text(
                  "Edit profile",
                  style: GoogleFonts.poppins(color: const Color(0xFF2F2F2F)),
                )),
            ShareButton(onPressed: () {
              // TODO: share functionality
            })
          ],
        )
      ],
    );
  }
}
