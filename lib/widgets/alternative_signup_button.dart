import 'package:flutter/material.dart';

class AlternativeSignUpButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String link;

  const AlternativeSignUpButton({super.key, required this.onPressed, required this.link});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 45,
      height: 45,
      child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2F2F2F),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
            ),
          ),
          child: Image.network(
            link,
            fit: BoxFit.contain,
          )
      ),
    );
  }
}
