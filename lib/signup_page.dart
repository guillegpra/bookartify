import 'package:bookartify/widgets/register/alternative_signup_button.dart';
import 'package:bookartify/widgets/divider_text.dart';
import 'package:bookartify/widgets/register/signup_form.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignUpPage extends StatelessWidget {
  final Function() onClickedBack;

  const SignUpPage({super.key, required this.onClickedBack});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[50],
        elevation: 0,
        title: Text(
            "BookARtify",
            style: GoogleFonts.dmSerifDisplay(
              fontSize: 25.0
            ),
        ),
        leading: IconButton(
            // onPressed: () {
            //   Navigator.pop(context);
            // },
          onPressed: onClickedBack,
          icon: const Icon(Icons.arrow_back)
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start, // Align children to the start
            crossAxisAlignment: CrossAxisAlignment.start, // Align children to the start
            children: [
              /* -------- Title -------- */
              Container(
                margin: const EdgeInsets.only(left: 20.0, bottom: 10.0),
                child: Text(
                    "Create an account",
                    style: GoogleFonts.dmSerifDisplay(
                        fontSize: 28.0
                    ),
                ),
              ),
              /* -------- Sign up form -------- */
              const SignUpForm(),
              /* -------- or -------- */
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 25.0),
                child: const DividerWithText(text: "or")
              ),
              /* -------- Other platforms ?? -------- */
              // TODO
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  AlternativeSignUpButton(
                    onPressed: () {
                      print("Google button pressed");
                    },
                    link: "https://upload.wikimedia.org/wikipedia/commons/thumb/5/53/Google_%22G%22_Logo.svg/1176px-Google_%22G%22_Logo.svg.png?20230305195327"
                  ),
                  AlternativeSignUpButton(
                    onPressed: () {
                      print("Apple button pressed");
                    },
                    link: "https://upload.wikimedia.org/wikipedia/commons/thumb/3/31/Apple_logo_white.svg/1010px-Apple_logo_white.svg.png?20220821122232"
                  ),
                  AlternativeSignUpButton(
                      onPressed: () {
                        print("Goodreads button pressed");
                      },
                      link: "https://upload.wikimedia.org/wikipedia/commons/thumb/5/5a/Goodreads_logo_-_SuperTinyIcons.svg/1024px-Goodreads_logo_-_SuperTinyIcons.svg.png?20201124153956"
                  )
                ],
              )
            ],
          ),
        ),
      )
    );
  }
}
