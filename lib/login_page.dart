import 'package:bookartify/widgets/register_button.dart';
import 'package:bookartify/widgets/divider_text.dart';
import 'package:bookartify/widgets/login_form.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /* -------- Welcome message -------- */
            Column(
              children: [
                Text(
                  "Welcome to",
                  style: GoogleFonts.poppins(
                    fontSize: 34,
                    letterSpacing: -1.5
                  )
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 48,
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.amber,
                          shape: BoxShape.circle
                      ),
                      child: Image.network(
                        "https://www.iconpacks.net/icons/2/free-opened-book-icon-3163-thumb.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                    Text(
                        "BookARtify",
                        style: GoogleFonts.dmSerifDisplay(
                          fontWeight: FontWeight.bold,
                          fontSize: 48,
                        )
                    ),
                  ],
                ),
              ],
            ),
            /* -------- Login form -------- */
            Container(
                margin: EdgeInsets.only(top: 15),
                child: LoginForm()
            ),
            /* -------- Divider -------- */
            Container(
                margin: const EdgeInsets.symmetric(horizontal: 45.0),
                child: const DividerWithText(text: "or")
            ),
            /* -------- Create account button -------- */
            RegisterButton(
              onPressed: () {
                print("Button clicked");
              },
              buttonText: "Create an account",
            )
          ],
        ),
      ),
    );
  }
}
