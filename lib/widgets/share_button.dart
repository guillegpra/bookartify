import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ShareButton extends StatelessWidget {
  final Function() onPressed;

  const ShareButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: onPressed,
        icon: Icon(Icons.share)
    );
  }
}
