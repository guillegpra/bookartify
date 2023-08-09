/*import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:bookartify/widgets/build_social_buttons.dart';

class ShareButton extends StatelessWidget {
  final Function() onPressed;
  final Map<String, dynamic> post;

  const ShareButton({super.key, required this.onPressed, required this.post});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return buildShareOptions(context, post);
          },
        );
      },
      icon: const Icon(Icons.share),
    );
  }

  Widget buildShareOptions(BuildContext context, Map<String, dynamic> post) {
    return buildSocialButtons(context, post);
  }
}*/

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

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

void share(BuildContext context, Map<String, dynamic> post) {
  final text = "Check out this artwork from BookARtify!";
  final imageLink = post["url"].toString();

  final content = "$text\n$imageLink";

  Share.share(content);
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
    );
