import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

enum SocialMedia { facebook, twitter, pinterest }

Widget buildSocialButtons() => Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: buildSocialButton(
              icon: FontAwesomeIcons.squareFacebook,
              color: Color(0xFF0075fc),
              onClicked: () => share(SocialMedia.facebook),
            ),
          ),
          Expanded(
            child: buildSocialButton(
              icon: FontAwesomeIcons.twitter,
              color: Color(0xFF1da1f2),
              onClicked: () => share(SocialMedia.twitter),
            ),
          ),
          Expanded(
            child: buildSocialButton(
              icon: FontAwesomeIcons.squarePinterest,
              color: Color(0xFFE60023),
              onClicked: () => share(SocialMedia.pinterest),
            ),
          ),
          /*Expanded(
            child: InkWell(
              child: Container(
                width: 45,
                height: 45,
                child: Image.asset(
                  'images/ig_logo.png', // Replace with the path to your Instagram icon image
                  width: 20,
                  height: 20,
                ),
              ),
              onTap: () => share(SocialMedia.instagram),
            ),
          ),*/
        ],
      ),
    );

Future share(SocialMedia socialPlatform) async {
  final subject = "Check out this artwork from BookARtify!";
  final text = "Check out this artwork from BookARtify!";
  final urlShare = Uri.encodeComponent(
      "https://i.pinimg.com/originals/a5/72/54/a572542b8b969a5d966570098990b330.jpg");

  final urls = {
    SocialMedia.facebook:
        'https://www.facebook.com/sharer/sharer.php?u=$urlShare',
    SocialMedia.twitter:
        'https://twitter.com/intent/tweet?text=$text&url=$urlShare',
    SocialMedia.pinterest:
        'https://www.pinterest.com/pin/create/button/?url=$urlShare&description=$text',
    /*SocialMedia.instagram:
        'https://www.instagram.com/create/broadcast/?url=$urlShare&caption=$text',*/
  };

  final url = Uri.parse(urls[socialPlatform]!);

  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  }
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
    );
