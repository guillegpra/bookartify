/*import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_share/social_share.dart';
import 'package:flutter/services.dart'; // Import the Flutter services for clipboard functionality
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:bookartify/widgets/photo_widget.dart'; // Import url_launcher package

enum SocialMedia {
  whatsapp,
  twitter,
}

Widget buildSocialButtons(BuildContext context, Map<String, dynamic> post) =>
    Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildSocialButton(
            icon: FontAwesomeIcons.whatsapp,
            color: Color(0xFF25D366),
            onClicked: () => share(context, SocialMedia.whatsapp, post),
          ),
          buildSocialButton(
            icon: FontAwesomeIcons.twitter,
            color: Color(0xFF1da1f2),
            onClicked: () => share(context, SocialMedia.twitter, post),
          ),
          // Add the Copy to Clipboard IconButton
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.content_copy, size: 34),
              onPressed: () => copyToClipboard(context, post),
            ),
          ),
        ],
      ),
    );

Future<void> share(BuildContext context, SocialMedia socialPlatform,
    Map<String, dynamic> post) async {
  final text = "Check out this artwork from BookARtify!";
  final imageLink = post["url"].toString();

  switch (socialPlatform) {
    case SocialMedia.whatsapp:
      bool canLaunchWhatsApp =
          await canLaunchUrlString("whatsapp://send?text=");
      if (canLaunchWhatsApp) {
        await launchUrlString("whatsapp://send?text=$text");
      } else {
        // Show a message to the user indicating that WhatsApp is not installed.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("WhatsApp is not installed on your device."),
            duration: Duration(seconds: 2),
          ),
        );
      }
      break;
    case SocialMedia.twitter:
      await SocialShare.shareTwitter(
        text,
        url: imageLink,
        hashtags: ["bookARtify"],
      );
      break;
  }
}

void copyToClipboard(BuildContext context, Map<String, dynamic> post) {
  final textToCopy = post["url"].toString();
  Clipboard.setData(ClipboardData(text: textToCopy));

  // Show a snackbar to indicate that the link is copied to the clipboard.
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text("Copied to clipboard!"),
      duration: Duration(seconds: 2), // Adjust the duration as needed
    ),
  );
}

Widget buildSocialButton({
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
    );*/

/*import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_share/social_share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:bookartify/widgets/photo_widget.dart';

class ShareButton extends StatelessWidget {
  final Map<String, dynamic> post;

  const ShareButton({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => share(context, post), // Directly call the share function
      icon: const Icon(Icons.share),
    );
  }
}

Future<void> share(BuildContext context, Map<String, dynamic> post) async {
  final text = "Check out this artwork from BookARtify!";
  final imageLink = post["url"].toString();

  await SocialShare.shareOptions(
    text,
    url: imageLink,
  );
}

Widget buildSocialButtons(BuildContext context, Map<String, dynamic> post) =>
    Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildSocialButton(
            icon: FontAwesomeIcons.share, // Use a generic share icon
            color: Colors.blue, // Customize the color
            onClicked: () => share(context, post),
          ),
        ],
      ),
    );

Widget buildSocialButton({
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
    );*/
