import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share/share.dart';

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
  const text = "Check out this artwork from BookARtify!";
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
      onTap: onClicked,
      child: SizedBox(
        width: 64,
        height: 64,
        child: Center(child: FaIcon(icon, color: color, size: 40))
      ),
    );
