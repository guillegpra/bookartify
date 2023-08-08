import 'package:flutter/material.dart';
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
}
