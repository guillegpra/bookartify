import 'package:bookartify/home_page.dart';
import 'package:bookartify/services/database_api.dart';
import 'package:bookartify/services/register.dart';
import 'package:bookartify/username_page.dart';
import 'package:bookartify/widgets/register/register_button.dart';
import 'package:bookartify/widgets/divider_text.dart';
import 'package:bookartify/widgets/register/login_form.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatelessWidget {
  final Function() onClickedCreate;

  const LoginPage({super.key, required this.onClickedCreate});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
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
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
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
                  margin: const EdgeInsets.only(top: 15),
                  child: const LoginForm()
              ),
              /* -------- Divider -------- */
              Container(
                  margin: const EdgeInsets.symmetric(horizontal: 45.0),
                  child: const DividerWithText(text: "or")
              ),
              /* -------- Create account button -------- */
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 40.0),
                width: double.infinity,
                child: RegisterButton(
                  // onPressed: () {
                  //   Navigator.push(
                  //       context,
                  //       MaterialPageRoute(builder: (context) => const SignUpPage()),
                  //   );
                  // },
                  onPressed: onClickedCreate,
                  buttonText: "Create an account",
                ),
              ),
              /* -------- Sign in with Google -------- */
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 40.0),
                width: double.infinity,
                child: RegisterButton(
                  onPressed: () async {
                    User? user = await signInWithGoogle(context);

                    if (user != null) {
                      print("-----------------------------------------------");
                      print(getUsernameById(user.uid));
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => getUsernameById(user.uid) != null ? const HomePage() : const UsernamePage())
                      );
                    }
                  },
                  buttonText: "Sign in with Google",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
