import 'package:flutter/material.dart';

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
      icon: const Icon(Icons.share),
    );
  }

  Widget buildShareOptions(BuildContext context) {
    return Wrap(
      children: [
        ListTile(
          leading: const Icon(Icons.share),
          title: const Text('Share on Instagram'),
          onTap: () {
            // Handle share on Instagram action
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.message),
          title: const Text('Share on Messenger'),
          onTap: () {
            // Handle share on Messenger action
            Navigator.pop(context);
          },
        ),
        // Add more share options here
      ],
    );
  }
}
