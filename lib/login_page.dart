import 'package:bookartify/home_page.dart';
import 'package:bookartify/utils.dart';
import 'package:bookartify/widgets/register/register_button.dart';
import 'package:bookartify/widgets/divider_text.dart';
import 'package:bookartify/widgets/register/login_form.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatelessWidget {
  final Function() onClickedCreate;

  const LoginPage({super.key, required this.onClickedCreate});

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
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const HomePage())
                    );
                  }
                },
                buttonText: "Sign in with Google",
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<User?> signInWithGoogle(BuildContext context) async {
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user;

  // ------------------ for the web ------------------
  if (kIsWeb) {
    GoogleAuthProvider authProvider = GoogleAuthProvider();

    try {
      final UserCredential userCredential = await auth.signInWithPopup(authProvider);
      user = userCredential.user;
    } catch (e) {
      print(e);
    }
  }
  // ------------------ for everything else ------------------
  else {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential =
        await auth.signInWithCredential(credential);

        user = userCredential.user;
      } on FirebaseAuthException catch (e) {
        if (e.code == "account-exists-with-different-credential") {
          // handle error here
          Utils.showSnackBar(
              "The account already exists with a different credential.",
              true
          );
        }
        else if (e.code == "invalid-credential") {
          // handle error here
          Utils.showSnackBar(
              "Error occurred while accessing credentials. Try again.",
              true
          );
        }
      } catch (e) {
        // handle error here
        Utils.showSnackBar(
            "Error occurred using Google Sign-In. Try again.",
            true
        );
      }

      return user;
    }
  }
}
