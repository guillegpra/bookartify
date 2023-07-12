import 'package:bookartify/services/usernames_db.dart';
import 'package:bookartify/utils.dart';
import 'package:bookartify/widgets/icons_and_buttons/loading_overlay.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

int _usernameCounter = 1;

Future<String> generateDefaultUsername() async {
  String defaultUsername = "user_$_usernameCounter";
  _usernameCounter++;

  bool isAvailable = await usernameAvailable(defaultUsername);
  while (!isAvailable) {
    defaultUsername = "user$_usernameCounter";
    _usernameCounter++;
    isAvailable = await usernameAvailable(defaultUsername);
  }

  return defaultUsername;
}

Future<void> signIn(BuildContext context, String email, String password) async {
  LoadingOverlay.show(context);

  try {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
  } on FirebaseAuthException catch (e) {
    Utils.showSnackBar(e.message, true);
  }

  LoadingOverlay.hide();
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

    LoadingOverlay.show(context);

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
        String defaultUsername = await generateDefaultUsername();
        addUsername(user!.uid, defaultUsername);
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

      LoadingOverlay.hide();
      return user;
    }
  }
}

Future<void> signUp(BuildContext context, String email, String password, String username) async {
  if (!(await usernameAvailable(username))) {
    Utils.showSnackBar("Username is already taken", true);
    return;
  }

  LoadingOverlay.show(context);

  try {
    UserCredential user = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);

    String selectedUsername = username.isNotEmpty ? username : await generateDefaultUsername();

    // add username to database
    await addUsername(user.user!.uid, selectedUsername);
  } on FirebaseAuthException catch (e) {
    Utils.showSnackBar(e.message, true);
  }

  LoadingOverlay.hide();
}

Future<void> signOut(BuildContext context) async {
  try {
    if (!kIsWeb && isSignedInWithGoogle(FirebaseAuth.instance.currentUser!)) {
      await GoogleSignIn().signOut();
    }
    await FirebaseAuth.instance.signOut();
  } catch (e) {
    Utils.showSnackBar("Error signing out. Please try again.", true);
  }
}

bool isSignedInWithGoogle(User user) {
  return user.providerData.any((userInfo) => userInfo.providerId == "google.com");
}