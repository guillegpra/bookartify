import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:bookartify/widgets/build_social_buttons.dart';

class ShareButton extends StatelessWidget {
  final Function() onPressed;

  const ShareButton({super.key, required this.onPressed});

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
    return buildSocialButtons();
  }
}
