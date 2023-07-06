import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ShareProfileButton extends StatelessWidget {
  final Function() onPressed;

  const ShareProfileButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return buildShareOptions(context);
          },
        );
      },
      icon: Icon(Icons.share),
    );
  }

  Widget buildShareOptions(BuildContext context) {
    return Container(
      child: Wrap(
        children: [
          ListTile(
            leading: Icon(Icons.share),
            title: Text('Share on Instagram'),
            onTap: () {
              // Handle share on Instagram action
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.message),
            title: Text('Share on Messenger'),
            onTap: () {
              // Handle share on Messenger action
              Navigator.pop(context);
            },
          ),
          // Add more share options here
        ],
      ),
    );
  }
}
