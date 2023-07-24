import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_share/social_share.dart';
import 'package:flutter/services.dart'; // Import the Flutter services for clipboard functionality

enum SocialMedia {
  whatsapp,
  twitter,
}

Widget buildShareProfileButtons() => Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildShareProfileButton(
            icon: FontAwesomeIcons.whatsapp,
            color: Color(0xFF25D366),
            onClicked: () => share(SocialMedia.whatsapp),
          ),
          buildShareProfileButton(
            icon: FontAwesomeIcons.twitter,
            color: Color(0xFF1da1f2),
            onClicked: () => share(SocialMedia.twitter),
          ),

          // Add the Copy to Clipboard IconButton
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.content_copy, size: 34),
              onPressed: () => copyToClipboard(context),
            ),
          ),
        ],
      ),
    );

Future<void> share(SocialMedia socialPlatform) async {
  final text = "Check out my profile on BookARtify!";
  final profileLink =
      "https://i.pinimg.com/originals/a5/72/54/a572542b8b969a5d966570098990b330.jpg";

  switch (socialPlatform) {
    case SocialMedia.whatsapp:
      await SocialShare.shareWhatsapp(text);
      break;
    case SocialMedia.twitter:
      await SocialShare.shareTwitter(
        text,
        url: profileLink,
        hashtags: ["bookARtify"],
      );
      break;
  }
}

void copyToClipboard(BuildContext context) {
  final textToCopy =
      "https://i.pinimg.com/originals/a5/72/54/a572542b8b969a5d966570098990b330.jpg";
  Clipboard.setData(ClipboardData(text: textToCopy));

  // Show a snackbar to indicate that the link is copied.
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text("Copied to clipboard!"),
      duration: Duration(seconds: 2), // Adjust the duration as needed
    ),
  );
}

Widget buildShareProfileButton({
  required IconData icon,
  Color? color,
  required VoidCallback onClicked,
}) =>
    InkWell(
      child: Container(
          width: 64,
          height: 64,
          child: Center(child: FaIcon(icon, color: color, size: 40))),
      onTap: onClicked,
    );
