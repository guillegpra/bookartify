import 'dart:async';

import 'package:bookartify/home_page.dart';
import 'package:bookartify/utils.dart';
import 'package:bookartify/widgets/register/register_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  bool isEmailVerified = false;
  bool canResendEmail = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if (!isEmailVerified) {
      sendVerificationEmail();

      timer = Timer.periodic(
        const Duration(seconds: 3),
        (_) => checkEmailVerified(),
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future checkEmailVerified() async {
    // call after email verification
    await FirebaseAuth.instance.currentUser!.reload();

    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    // cancel timer if verified
    if (isEmailVerified) timer?.cancel();
  }

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();

      // update canResendEmail variable
      setState(() {
        canResendEmail = false;
      });
      await Future.delayed(const Duration(seconds: 5));
      setState(() {
        canResendEmail = true;
      });
    } catch (e) {
      Utils.showSnackBar(e.toString(), true);
    }
  }

  @override
  Widget build(BuildContext context) => isEmailVerified
    ? const HomePage()
    : Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Verify email",
          style: GoogleFonts.dmSerifDisplay(),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "A verification email has been sent to your email account",
              style: GoogleFonts.dmSerifDisplay(
                fontSize: 20.0,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10,),
            Text(
              "Verify your account to use the app",
              style: GoogleFonts.poppins(
                  fontSize: 14.0
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10,),
            SizedBox(
              width: double.infinity,
              child: RegisterButton(
                onPressed: canResendEmail ? sendVerificationEmail : () {},
                buttonText: "Resend email",
              ),
            ),
            TextButton(
                onPressed: () {
                  // FirebaseAuth.instance.signOut();
                  FirebaseAuth.instance.currentUser!.delete();
                },
              child: Text(
                "Cancel",
                style: GoogleFonts.dmSerifDisplay(
                  color: const Color(0xFF2F2F2F),
                  fontSize: 18
                ),
              ),
            )
          ],
        ),
      ),
    );
}
