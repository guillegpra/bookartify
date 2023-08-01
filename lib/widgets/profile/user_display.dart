import 'package:bookartify/services/database_api.dart';
import 'package:bookartify/widgets/icons_and_buttons/share_profile_button.dart';
import 'package:bookartify/widgets/profile/edit_profile.dart';
import 'package:bookartify/widgets/icons_and_buttons/follow_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserDisplay extends StatelessWidget {
  final String userId;
  final String username;
  final String bio;
  final String goodreadsUrl;

  const UserDisplay({super.key, required this.userId, required this.username,
  required this.bio, required this.goodreadsUrl});

  Future<void> _launchUrl(BuildContext context) async {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    if (goodreadsUrl == null || goodreadsUrl.isEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditProfileScreen(userId: userId),
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
        SizedBox(
          width: 160,
          child: Text(
            bio,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            softWrap: false,
            style: GoogleFonts.poppins(fontSize: 12),
          ),
        ),
        const SizedBox(height: 10), // FollowButton(isFollowing: false),
        Row(
          children: [
            Visibility(
              visible: userId != currentUser!.uid,
              child: FutureBuilder<bool>(
                future: isFollowingUser(currentUser!.uid, userId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  } else {
                    bool isFollowing = snapshot.data ?? false;
                    return FollowButton(
                      userId: userId,
                      isFollowing: isFollowing,
                    );
                  }
                },
              ),
            ),
            Visibility(
              visible: userId == currentUser!.uid,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                          EditProfileScreen(userId: userId,),
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
            ),
            ShareButton(onPressed: () {
              // TODO: share functionality
            })
          ],
        )
      ],
    );
  }
}
